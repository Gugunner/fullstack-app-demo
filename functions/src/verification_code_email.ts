import * as express from "express";
import { logger } from "firebase-functions/v2";
import { AppException } from "./exception/app_exception";
import { Request } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { defineInt } from "firebase-functions/params";
import { IMPLEMENT_FIREBASE } from "./util/parametrized_states";
import { checkBodyFields, checkEmptyBody } from "./util/request_body_checks";

/** The code found here works in the same flow, writing two Firebase functions in the same module are only used because it is highly probable that the user will use the same Firebase functions instance to execute  both functions to receive and verify the email*/

export const sendEmail = defineInt('SEND_EMAIL', { default: IMPLEMENT_FIREBASE.block, description: 'Enables or disables real mail sending' });

export enum VerificationType {
    register = 'register',
    login = 'login',
}

/**
Send a verification code to the email provided in the request body
The code is stored in the collection 'codes' with the email as the document id
and the code is sent to the email in the language provided in the request body.
 * 
 * @param {Request} request 
 * @param {express.Response} response 
 * @throws AppException If the body is undefined, or the email or language code are not included or the code could not be stored or the email could not be sent
 */
export async function sendVerificationCode(request: Request, response: express.Response): Promise<void> {
    //Check if the body is undefined
    checkEmptyBody(request.body);
    //Check if the email and language code are included
    checkBodyFields(request.body, ['email', 'languageCode', 'verificationType']);
    const { languageCode, email, verificationType } = request.body;
    //Check that it has a valid verification type
    checkVerificationType(verificationType);
    //Check user verification can be completed given the verification type
    await checkUserCanReceiveVerificationCode(email, verificationType);
    const code = createNewCode();
    const sendEmailValue = sendEmail.value();
    if (sendEmailValue === IMPLEMENT_FIREBASE.mock || sendEmailValue === IMPLEMENT_FIREBASE.send) {
        await sendCodeToEmail(email, languageCode, code);
    }
    await storeCode(email, code);
    response.status(202).send({ code: 0 });

    /**
     * Checks if the verification type is a valid value in the VerificationType enum.
     * @param verificationType The verification type to check
     * @throws AppException If the verification type is not a valid value in the VerificationType enum.
     */
    function checkVerificationType(verificationType: string): void {
        const check = verificationType in VerificationType;
        if (!check) {
            throw new AppException({
                code: 'invalid-argument',
                errorCode: 'invalid-body-fields',
                message: 'Include a valid verificationt type [register, login].',
                prefix: 'piix-functions',
                statusCode: 400,
            });
        }
    }

    /**
     * Checks if the user can receive a verification code given the verification type
     * by checking if the email exists in the users collection or not.
     * If the user can receive the code, the function will return without errors.
     * @param email where the code will be sent.
     * @param verificationType indicates if the user is registering or logging in.
     * @throws [AppException] If the email is already and the verification type is register.
     * @throws [AppException] If the email is not found and the verification type is login.
     */
    async function checkUserCanReceiveVerificationCode(email: string, verificationType: string): Promise<void> {
        //Check if a user exists with the same email.
        const userExists = await userExistWithEmail(email);
        //If the verification type is register and the user exists, throw an exception.
        if (verificationType == VerificationType.register.toString() && userExists) {
            throw new AppException({
                code: 'already-exists',
                errorCode: 'email-already-exists',
                message: 'The email is already in use.',
                prefix: 'piix-auth',
                statusCode: 409,
            });
        }
        //If the verification type is login and the user does not exist, throw an exception.
        if (verificationType == VerificationType.login.toString() && !userExists) {
            throw new AppException({
                code: 'not-found',
                errorCode: 'email-not-found',
                message: 'The email was not found.',
                prefix: 'piix-auth',
                statusCode: 404,
            });
        }
        
        /**
         * Checks if a user exists with the same email.
         * @param email The email to check to see if a user exists with the same email
         * @returns {boolean} True if a user exists with the same email, false otherwise.
         */
        async function userExistWithEmail(email: string): Promise<boolean> {
            //Query the users collection to see if a user exists with the same email.
            const docQuery = await admin.firestore().collection('users').where('email', '==', email).get();
            //If the query is empty, return false, otherwise return if the document exists.
            if (docQuery.empty) return false;
            return docQuery.docs[0].exists;
        }
    }
}

/**
 * 
 * @param email The email value which will be the document id and the email property inside the document.
 * @param code The code that is expected to be verified.
 * @throws AppException If the document could not be added to the collection 'codes'
 * 
 * If a document already exists with the same email, it will be overwritten and the code will change.
 */
async function storeCode(email: string, code: string): Promise<void> {
    try {
        const docRef = admin.firestore().collection('codes').doc(email)
        await docRef.set({ email, code });
        logger.log(`Email and code were sent and stored`);
    } catch (error) {
        logger.error(`The code cannot be stored inside codes ${error}`);
        throw new AppException({
            code: 'aborted',
            errorCode: 'document-not-added',
            message: 'Could not store the verification code.',
            prefix: 'store',
            statusCode: 500,
        });// Or handle more gracefully
    }
}

/**Creates a new 6 digit string code
 * 
 * @returns {string} A 6 digit string code
*/
//The function is exported as a variable module so it can be mocked and tested
export const createNewCode = (): string => {
    //Creates a base value that controls the length of the number (7)
    const max = Math.pow(10, 7); // 10^7
    //Creates the mininimum value equal to the real length of the number (6)
    const min = max/10; // 10^7/10 = 10^6
    //Creates a random value greater than 0 but less than 1 with 16 decimal places
    //Multiply the value by the difference between the max and the min to obtain a (7) digit value
    //Add one to prevent values to start at 0
    //Floor the value to remove additional decimals
    //Add the min value to sum 1000000 to the current result the most significant 1 will be discarded at the end
    const number = Math.floor(Math.random() * (max - min + 1)) + min; 
    //ex. 0.2442534423448654*(10^7-10^6+1) + 10^6 = 0.2442534423448654*(9000001) + 10^6 = 2198280.981 + 10^6 = 3198280
    //Return the value interpolated as a string startign from the pos 1 to only return 6 digits
    return `${number}`.substring(1); // 198280
}

/**
 * Sends the code to the email provided in the language provided when a new email document is added to the collection 'emails'
 * inside Firestore. The email is sent using the template 'verification_code_{languageCode}' that is found in the collection 'email_templates' 
 * 
 * @param email The email to send the code to
 * @param languageCode The language code to send the email in
 * @param code The generated code to be verified
 * @throws AppException If the email could not be stored in the collection 'emails'
 */
async function sendCodeToEmail( email: string, languageCode: string, code: string): Promise<void> {
    try {
        //Get the template name
        const templateName = `verification_code_${languageCode}`;
        //Add the email to the collection to trigger the firebase email service extension
        const collectionRef = admin.firestore().collection('emails');
        await collectionRef.add({
            to: [email],
            template: {
                name: templateName,
                data: {
                    code: code,
                }
            }
        });
    } catch (error) {
        logger.error(`The code cannot be stored inside emails -> ${error}`);
        //Throw an exception if the email could not be stored in the collection
        //which means it cannot be read by the firebase email service extension
        throw new AppException({
            code: 'aborted',
            errorCode: 'email-not-sent',
            message: 'Could not send the verification code to the email.',
            prefix: 'piix-functions',
            statusCode: 500,
        });
    }
}


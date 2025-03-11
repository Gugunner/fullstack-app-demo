import { AppException } from "../exception/app_exception";

/**
 * Check if the body of the request is undefined
 * 
 * @param body The body of the request
 * @throws AppException If the body is undefined
 */
export function checkEmptyBody(body: object): void {
    if (body === undefined) {
        throw new AppException({
            code: 'invalid-argument',
            errorCode: 'invalid-body',
            message: 'The request has no body.',
            prefix: 'piix-functions',
            statusCode: 400,
        });
    }
}

/**
 * Check if the body of the request has the required fields.
 * 
 * @param body The body of the request
 * @param fields The fields that the body must have
 * @param message An optional message to be used in the AppException
 * @throws AppException If the body does not have the required fields
 */

export function checkBodyFields(body: any, fields: Array<string>, message?: string | undefined): void {
    fields.forEach((field) => {
        //Check if the body has the required field
        if (!(body as object).hasOwnProperty(field)) {
            var definedMessage = message;
            //If the message is not defined, create a default message
            if (definedMessage === undefined) {
                definedMessage = `The body does not have the required fields [${fields.join(', ')}]`;
            }
            throw new AppException({
                code: 'invalid-argument',
                errorCode: 'invalid-body-fields',
                message: definedMessage,
                prefix: 'piix-functions',
                statusCode: 400,
            });
        }
    });
}

//TODO: Check for excluyent body fields
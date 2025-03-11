import { Robot } from './utils/robot';

//Tests for the sendVerificationCodeRequest function
describe('Send Verification Code Request', () => {
    const robot = new Robot();
    //Clear the mocks after each test
   afterEach(() => {
    jest.clearAllMocks();
   });
    it(`WHEN a valid email, languageCode and verificationType is received
    AND a code is created
    AND the code is stored in an email document
    AND the code is stored in a code document
    THEN the response status code will be a 200
    AND the returned response body will be a code: 0`, async () => {
        await robot.auth.sendVerificationCode.expectToSucceed();
    });
    it(`WHEN the request body is undefined
    THEN throw an AppException with 'invalid-body' errorCode `, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenBodyIsUndefined();
    });
    it(`WHEN the request body is empty
    THEN throw an AppException with 'invalid-body-fields' errorCode `, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenBodyIsEmpty();
    });
    it(`WHEN the request body does not have an email
    THEN throw an AppException with 'invalid-body-fields' errorCode `, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenBodyHasNoEmail();
    });
    it(`WHEN the request body does not have a languageCode
    THEN throw an AppException with 'invalid-body-fields' errorCode `, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenBodyHasNoLanguageCode();
    });
    it(`WHEN the request body does not have a verificationType
    THEN throw an AppException with 'invalid-body-fields' errorCode `, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenBodyHasNoVerificationType();
    });
    it(`WHEN a valid email, languageCode and verificationType is received
    AND the verificationt type is register
    AND the email already exists in the users collection
    THEN throw an AppException with 'email-already-exists' errorCode`, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenEmailExistButVerificationTypeIsRegister();
    });
    it(`WHEN a valid email, languageCode and verificationType is received
    AND the verificationt type is login
    AND the email does not exists in the users collection
    THEN throw an AppException with 'email-not-found' errorCode`, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenEmailDoesNotExistButVerificationTypeIsLogin();
    });
    it(`WHEN a valid email, languageCode and verificationType is received
    AND a code can be created
    THEN the code cannot be stored in an email document
    AND throw an AppException with 'email-not-sent' errorCode`, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenEmailDocumentCannotBeStored();
    });
    it(`WHEN a valid email, languageCode and verificationType is received
    AND a code can be created
    AND the code is stored in an email document
    THEN the code cannot be stored in a code document
    AND throw an AppException with 'document-not-added' errorCode`, async () => {
        await robot.auth.sendVerificationCode.expectToFailWhenCodeDocumentCannotBeStored();
    });
});


import { Robot } from './utils/robot';

describe('Create Account and Custom Token With Email Request', () => {
    const robot = new Robot();
    afterEach(() => {
        jest.clearAllMocks();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    THEN a firebase user will be created with custom claim userAccount: true
    AND the user will be stored
    AND a custom token will be created
    AND the returned response body will contain the custom token`, async () => {
        await robot.auth.createWithEmail.expectToSucceed();
    });
    it(`WHEN the request body is undefined
    THEN throw an AppException with "invalid-body" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenBodyIsUndefined();
    });
    it(`WHEN the request body is empty
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenBodyIsEmpty();
    });
    it(`WHEN the request body does not have email
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenBodyHasNoEmail();
    });
    it(`WHEN the request body does not have a code
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenBodyHasNoCode();
    });
    it(`WHEN the request body does not have a languageCode
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenBodyHasNoLanguageCode();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the document of the codes collection does not exist
    THEN throw an AppException with 'document-not-found'`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenCodeDocumentDoesNotExist();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the document of the codes collection has no data
    THEN throw an AppException with 'unknown' errorCode and 'failed-precondition' code`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenCodeDocumentHasNoData();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the codes do not match
    THEN throw an AppException with 'incorrect-verification-code' errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenCodesDoNotMatch();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    THEN the code cannot be deleted
    AND the code field property is emptied
    AND a firebase user will be created with custom claim userAccount: true
    AND the user will be stored
    AND a custom token will be created
    AND the returned response body will contain the custom token`, async () => {
        await robot.auth.createWithEmail.expectToSucceedButFailToRemoveCodeDocument();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    THEN the firebase user cannot be created
    AND throw an AppException with 'user-not-created' errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenNoFirebaseUserIsCreated();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    AND a firebase user will be created with custom claim userAccount: true
    THEN the user cannot be stored in firestore
    AND throw an AppException with 'user-not-created' errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenUserCannotBeStored();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    AND the user is created in firebase
    AND the user is stored
    THEN the welcome email document cannot be stored 
    AND the custom token is created
    AND the returned response body will contain the custom token`, async () => {
        await robot.auth.createWithEmail.expectToSucceedButFailToStoreWelcomeEmailDocument();
    });
    it(`WHEN a valid email, code and languageCode is received
    AND the code is successfully verified
    AND the user is created in firebase
    AND the user is stored
    THEN the custom token cannot be created
    AND throw an AppException with "custom-token-failed" errorCode`, async () => {
        await robot.auth.createWithEmail.expectToFailWhenCustomTokenCannotBeCreated();
    });
});

//Tests for getCustomTokenForCustomSignInRequest function
describe('Get Custom Token for Custom Sign In Request', () => {
    const robot = new Robot();
    afterEach(() => {
        jest.clearAllMocks();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfully verified
    THEN the user is retrieved from firestore 
    AND a custom token will be created 
    AND the returned response body will contain the custom token`, async () => {
        await robot.auth.customSignIn.expectToSuceed();
    });
    it(`WHEN the request body is undefined
    THEN throw an AppException with "invalid-body" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenBodyIsUndefined();
    });
    it(`WHEN the request body is empty
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenBodyIsEmpty();
    });
    it(`WHEN the request body does not have an email
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenBodyHasNoEmail();
    });
    it(`WHEN the request body does not have a code
    THEN throw an AppException with "invalid-body-fields" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenBodyHasNoCode();
    });
    it(`WHEN a valid email and code is received
    AND the document with the provided email does not exist in the codes collection
    THEN throw an AppException with 'document-not-found' errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenCodeDocumentDoesNotExist();
    });
    it(`WHEN a valid email and code is received
    AND the document of the codes collection has no data
    THEN throw an AppException with 'unknown' errorCode and 'failed-precondition' code`, async () => {
        await robot.auth.customSignIn.expectToFailWhenCodeDocumentHasNoData();
    });
    it(`WHEN a valid email and code is received
    AND the codes do not match
    THEN throw an AppException with 'incorrect-verification-code' errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenCodesDoNotMatch();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfully verified
    AND the code document cannot be deleted
    THEN the code will be removed
    AND the user is retrieved from firestore 
    AND a custom token will be created 
    AND the returned response body will contain the custom token`, async () => {
        await robot.auth.customSignIn.expectToSucceedButFailToRemoveCodeDocument();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfuly verified
    THEN the user cannot be found in the query
    AND throw an AppException with "query-is-empty" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenNoUserIsFoundInQuery();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfuly verified
    AND the user document does not exist
    AND throw an AppException with "not-found" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenUserDocumentDoesNotExist();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfuly verified
    AND the user document has no data
    AND throw an AppException with 'unknown' errorCode and 'failed-precondition' code`, async () => {
        await robot.auth.customSignIn.expectToFailWHenUserDocumentHasNoData();
    });
    it(`WHEN a valid email and code is received
    AND the code is successfully verified
    AND the user is retrieved from firestore 
    THEN the custom token cannot be created
    AND throw an AppException with "custom-token-failed" errorCode`, async () => {
        await robot.auth.customSignIn.expectToFailWhenCustomTokenCannotBeCreated();
    });
});

describe('Revoke Refresh Tokens Request', () => {
    const robot = new Robot();
    afterEach(() => {
        jest.clearAllMocks();
    });
    it(`WHEN a valid id token is included in the headers authorization
    AND the id token is verified
    AND the users refresh tokens are revoked
    AND the uid is obtained from the decoded id token
    AND the user is obtained from the uid
    AND the user tokensValidAfterTime is read from user
    THEN the metadata of revokeTime is stored
    AND the response returns a 200 with a { code: 0} body`, async () => {
        await robot.auth.revokeToken.expectToSucceed();
    });
    it(`WHEN a valid id token is included in the headers authorization
    THEN throw an AppException with 'no-id-token-present' errorCode and 'permission-denied' code`, async () => {
        await robot.auth.revokeToken.expectToFailWhenThereIsNoAuthorizationHeader();
    });
    it(`WHEN a valid id token is included in the headers authorization
    THEN the id token is expired 
    AND throw an AppException with 'id-token-expired' errorCode and 'failed-precondition' code`, async () => {
        await robot.auth.revokeToken.expectToFailWhenIdTokenIsExpired();
    });
    it(`WHEN a valid id token is included in the headers authorization
    THEN the id token is revoked
    AND throw an AppException with 'id-token-expired' errorCode and 'failed-precondition' code`, async () => {
        await robot.auth.revokeToken.expectToFailWhenIdTokenIsRevoked();
    });
    it(`WHEN a valid id token is included in the headers authorization
    THEN the id token is invalid
    AND throw an AppException with 'invalid-id-token' errorCode and 'permission-denied' code`, async () => {
        await robot.auth.revokeToken.expectToFailWhenIdTokenIsInvalid();
    });
    it(`WHEN a valid id token is included in the headers authorization
    AND the id token is verified
    THEN the users refresh tokens cannot be revoked 
    AND throw an unhandle Error`, async () => {
        await robot.auth.revokeToken.expectToFailWhenRefreshIdTokensCannotBeRevoked();
    });
    it(`WHEN a valid id token is included in the headers authorization
    AND the users refresh tokens are revoked
    AND the uid is obtained from the decoded id token
    THEN user cannot be obtained from the uid 
    AND throw an unhandle Error`, async () => {
        await robot.auth.revokeToken.expectToFailWhenUserCannotBeObtained();
    });
    it(`WHEN a valid id token is included in the headers authorization
    AND the users refresh tokens are revoked
    AND the uid is obtained from the decoded id token
    AND the user is obtained from the uid
    AND the user tokensValidAfterTime is read from user
    THEN the revokeTime cannot be stored in metadata 
    AND the response returns a 200 with a { code: 0} body`, async () => {
        await robot.auth.revokeToken.expectToSucceedButFailToStoreRevokeTime();
    });
});

/**
 * Helps mock the private functions that mock Firebase Firestore
 * by setting specific values that are used when testing the firebase functions for creating an account or
 * getting a custom sign in token.
 * This interface allows to have named parameters in the mock functions. Which
 * makes the code more readable.
 */
export interface MockFirestore {
    rejectSetUser?: boolean,
    userQueryIsEmpty?: boolean,
    userExists?: boolean,
    userData?: jest.Mock,
    codeExists?: boolean,
    codeData?: jest.Mock,
    rejectDeleteCode?: boolean,
    rejectSetCode?: boolean,
    rejectAddEmail?: boolean,
    rejectSetMetadata?: boolean,
}

/**
 * Helps mock the private functions that mock Firebase Auth
 * by setting specific values that are used when testing the firebase functions for creating an account or
 * getting a custom sign in token.
 * This interface allows to have named parameters in the mock functions. Which
 * makes the code more readable.
 */
export interface MockFirebaseAuth {
    rejectCreateUser?: boolean,
    rejectCreateCustomToken?: boolean,
    rejectTokenExpired?: boolean,
    rejectTokenRevoked?: boolean,
    rejectInvalidToken?: boolean,
    rejectRevokeRefreshTokens?: boolean,
    rejectGetUser?: boolean,
}
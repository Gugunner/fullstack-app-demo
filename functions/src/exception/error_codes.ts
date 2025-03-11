/**
 * All codes defined for the 'auth' errorCodes that can be thrown
 */
type FirebaseAdminAuthErrorCodes = 'unknown' | 'id-token-expired'
| 'id-token-revoked' | 'invalid-email' | 'invalid-id-token' | 'invalid-uid' | 'too-many-requests'
| 'uid-already-exists' | 'user-not-found' | 'user-not-created';

/**
 * All codes defined for the 'store' errorCodes that can be thrown
 */
type FirebaseAdminFirestoreErrorCodes = 'unknown' | 'document-not-added' | 'document-not-created'
| 'document-not-deleted' | 'document-not-set' | 'document-not-updated' | 'document-not-found' | 'query-is-empty';

/**
 * All codes defined for the piix-auth errorCodes that can be thrown
 */
type PiixAuthErrorCodes = 'unknown' | 'email-already-exists' | 'email-not-found' | 'incorrect-verification-code'
| 'custom-token-failed' | 'no-id-token-present';

/** 
 * All codes defined for the piix-functions errorCodes that can be thrown 
*/
type PiixFunctionsErrorCodes = 'invalid-body' | 'invalid-body-fields' | 'email-not-sent';

export type ErrorCode = FirebaseAdminAuthErrorCodes | FirebaseAdminFirestoreErrorCodes 
| PiixAuthErrorCodes | PiixFunctionsErrorCodes;

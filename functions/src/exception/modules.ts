import { ErrorCode } from './error_codes';

/**
 * Defines the modules of the application
 */
export type ModulePrefix = 'auth' | 'store' | 'piix-auth' | 'piix-functions';

/**
 * Defines the structure of a submodule
 */
export interface SubModule {
  name: string;
  codeNumber: string;
  prefix: ModulePrefix;
  errorCode: ErrorCode;
}

export const FirebaseAdminAuth: Module = {
	'unknown': {
		name: 'UNKNOWN',
		codeNumber: '0000',
		prefix: 'auth',
		errorCode: 'unknown',
	},
	'id-token-expired': {
		name: 'EXPIRED',
		codeNumber: '0001',
		prefix: 'auth',
		errorCode: 'id-token-expired'
	},
	'id-token-revoked': {
		name: 'REVOKED',
		codeNumber: '0002',
		prefix: 'auth',
		errorCode: 'id-token-expired'
	},
	'invalid-email': {
		name: 'INVALID_EMAIL',
		codeNumber: '0003',
		prefix: 'auth',
		errorCode: 'invalid-email',
	},
	'invalid-id-token': {
		name: 'INVALID_TOKEN',
		codeNumber: '0004',
		prefix: 'auth',
		errorCode: 'invalid-id-token',
	},
	'invalid-uid': {
		name: 'INVALID_UID',
		codeNumber: '0005',
		prefix: 'auth',
		errorCode: 'invalid-uid',
	},
	'too-many-requests': {
		name: 'TOO_MANY_REQUESTS',
		codeNumber: '0006',
		prefix: 'auth',
		errorCode: 'too-many-requests',
	},
	'uid-already-exists': {
		name: 'UID_ALREADY_EXISTS',
		codeNumber: '0007',
		prefix: 'auth',
		errorCode: 'uid-already-exists',
	},
	'user-not-found': {
		name: 'NO_USER',
		codeNumber: '0008',
		prefix: 'auth',
		errorCode: 'user-not-found',
	},
	'user-not-created': {
		name: 'USER_NOT_CREATED',
		codeNumber: '0009',
		prefix: 'auth',
		errorCode: 'user-not-created',
	},
}

export const FirebaseAdminFirestore: Module = {
	'unknown': {
		name: 'UNKNOWN',
		codeNumber: '0100',
		prefix: 'store',
		errorCode: 'unknown',
	},
	'document-not-added': {
		name: 'DOCUMENT_NOT_ADDED',
		codeNumber: '0101',
		prefix: 'store',
		errorCode: 'document-not-added',
	},
	'document-not-created': {
		name: 'DOCUMENT_NOT_CREATED',
		codeNumber: '0102',
		prefix: 'store',
		errorCode: 'document-not-created',
	},
	'document-not-deleted': {
		name: 'DOCUMENT_NOT_DELETED',
		codeNumber: '0103',
		prefix: 'store',
		errorCode: 'document-not-deleted',
	},
	'document-not-set': {
		name: 'DOCUMENT_NOT_SET',
		codeNumber: '0104',
		prefix: 'store',
		errorCode: 'document-not-set',
	},
	'document-not-updated': {
		name: 'DOCUMENT_NOT_UPDATED',
		codeNumber: '0105',
		prefix: 'store',
		errorCode: 'document-not-updated',
	},
	'document-not-found': {
		name: 'DOCUMENT_NOT_FOUND',
		codeNumber: '0106',
		prefix: 'store',
		errorCode: 'document-not-found',
	},
	'query-is-empty': {
		name: 'QUERY_IS_EMPTY',
		codeNumber: '0107',
		prefix: 'store',
		errorCode: 'query-is-empty',
	},
}

export const PiixAuth: Module = {
	'unknown': {
		name: 'UNKNOWN',
		codeNumber: '2000',
		prefix: 'piix-auth',
		errorCode: 'unknown',
	},
	'email-already-exists': {
		name: 'EMAIL_ALREADY_EXISTS',
		codeNumber: '2001',
		prefix: 'piix-auth',
		errorCode: 'email-already-exists',
	},
	'email-not-found': {
		name: 'EMAIL_NOT_FOUND',
		codeNumber: '2002',
		prefix: 'piix-auth',
		errorCode: 'email-not-found',
	},
	'incorrect-verification-code': {
		name: 'INCORRECT_VERIFICATION_CODE',
		codeNumber: '2003',
		prefix: 'piix-auth',
		errorCode: 'incorrect-verification-code',
	},
	'custom-token-failed': {
		name: 'CUSTOM_TOKEN_FAILED',
		codeNumber: '2004',
		prefix: 'piix-auth',
		errorCode: 'custom-token-failed',
	},
	'no-id-token-present': {
		name: 'NO_ID_TOKEN_PRESENT',
		codeNumber: '2005',
		prefix: 'piix-auth',
		errorCode: 'no-id-token-present',
	},
}


export const PiixFunctions: Module = {
	'unknown': {
		name: 'UNKNOWN',
		codeNumber: '3000',
		prefix: 'piix-functions',
		errorCode: 'unknown',
	},
	'invalid-body': {
		name: 'INVALID_BODY',
		codeNumber: '3001',
		prefix: 'piix-functions',
		errorCode: 'invalid-body',
	},
	'invalid-body-fields': {
		name: 'INVALID_BODY_FIELDS',
		codeNumber: '3002',
		prefix: 'piix-functions',
		errorCode: 'invalid-body-fields',
	},
	'email-not-sent': {
		name: 'UNKNOWN',
		codeNumber: '3003',
		prefix: 'piix-functions',
		errorCode: 'email-not-sent',
	},
}

export type Module = {[key: string]: SubModule};


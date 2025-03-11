import * as admin from 'firebase-admin';
import { Request } from 'firebase-functions/v2/https';
import { DecodedIdToken } from 'firebase-admin/auth';
import { logger } from 'firebase-functions/v2';
import { AppException } from '../exception/app_exception';

export function getIdTokenFromHeaders(request: Request): string {
    if (!request.headers.authorization) {
        throw new AppException({
            code: 'permission-denied',
            errorCode: 'no-id-token-present',
            message: 'The request does not have an authorization header.',
            prefix: 'piix-auth',
            statusCode: 401,
        });
    }
    const idToken = request.headers.authorization!.split('Bearer')[1];
    return idToken.trim();
}

/**
     * 
     * @param idToken The id token to verify
     * @returns @type{DecodedIdToken} The decoded id token
     * @throws {AppException} If the id token could not be verified
     */
export async function getDecodedIdToken(idToken: string): Promise<DecodedIdToken> {
    try {
        const checkRevoked = true;
        const decodedIdToken = await admin.auth().verifyIdToken(idToken, checkRevoked);
        return decodedIdToken;
    } catch (error) {
        //If the id token was revoked or expired throw an AppException with not acceptable status code
        logger.error(`The id Token ${idToken} could not be verified when revoking refresh tokens-> ${error}`);
        if (error == 'auth/id-token-revoked' || error == 'auth/id-token-expired') {
            throw new AppException({
                code: 'failed-precondition',
                errorCode: 'id-token-expired',
                message: 'The id token was revoked or expired.',
                prefix: 'auth',
                statusCode: 406,
            });
        } 
        //If the id token could not be verified, throw an AppException with unauthorized status code
        throw new AppException({
            code: 'permission-denied',
            errorCode: 'invalid-id-token',
            message: 'The id token is invalid.',
            prefix: 'auth',
            statusCode: 401,
        });
    }
}
import * as admin from 'firebase-admin';
import * as myFunctions from '../../../src/index';
import * as express from 'express';
import { Request } from 'firebase-functions/v2/https';
import { DocumentData } from 'firebase-admin/firestore';
import { MockFirebaseAuth, MockFirestore } from './mock_interfaces';
import { mockObjectProperty } from '../mock_objects';
import { AppException } from '../../../src/exception/app_exception';
import { SubModule } from '../../../src/exception/modules';

/**
 * This robot is used to test all the scenarios when revoking the users refresh tokens
 */
export class RevokeRefreshTokenRobot {

    //Spy which will be used to check if the function is called
    private _spyRequest = jest.spyOn(myFunctions, 'revokeRefreshTokensRequest');

    //The uid that is in the idToken
    private _uid: string;

    //The constructor initializes the variables
    constructor({
        uid,
    }: {
        uid: string;
    }) {
        this._uid = uid;
    }

    //The id token to be verified
    private get _idToken() {
        return 'ABCDEFGH1234567890';
    }

    private get _headers() {
        return {
            authorization: `Bearer ${this._idToken}`,
        }
    }

    //The decoded token from the id token
    private get _decodedToken() {
        return {
            uid: this._uid,
        };
    }

    //The user object that is returned when the user is obtained
    private get _user() {
        return {
            tokensValidAfterTime: 'Sun, 31 Dec 1899 00:00:00 GMT',
        };
    }

    //The function that will be used to verify the id token
    private _verifyIdToken(rejectExpired: boolean, rejectRevoked: boolean, rejectInvalidToken: boolean): jest.Mock {
        //The function that will be used to verify the id token
        const verifyIdToken = jest.fn((idToken: string, checkRevoked: boolean): any => {
            expect(idToken).toBe(this._idToken);
            expect(checkRevoked).toBe(true);
            return this._decodedToken;
        });
        //If the function is to be rejected
        if (rejectExpired) {
            //Reject the function
            verifyIdToken.mockRejectedValue('auth/id-token-expired');
        } else if (rejectRevoked) {
            verifyIdToken.mockRejectedValue('auth/id-token-revoked');
        } else if (rejectInvalidToken) {
            verifyIdToken.mockRejectedValue('auth/invalid-id-token');
        }
        //Return the function
        return verifyIdToken;
    }

    //The function that will be used to revoke the refresh tokens
    private _revokeRefreshTokens(reject: boolean): jest.Mock {
        //The function that will be used to revoke the refresh tokens
        const revokeRefreshTokens = jest.fn((uid: string): any => {
            expect(uid).toBe(this._uid);
        });
        //If the function is to be rejected
        if (reject) {
            revokeRefreshTokens.mockRejectedValue(new Error('mock error'));
        }
        //Return the function
        return revokeRefreshTokens;
    }

    //The function that will be used to get the user
    private _getUser(reject: boolean): jest.Mock {
        //The function that will be used to get the user
        const getUser = jest.fn((uid: string): any => {
            expect(uid).toBe(this._uid);
            return this._user;
        });
        //If the function is to be rejected
        if (reject) {
            //Reject the function
            getUser.mockRejectedValue(new Error('mock error'));
        }
        //Return the function
        return getUser;
    }

    //The metdata document reference that will be used to set the metadata document
    private _metadataDocRef(reject: boolean): any {
        //The function that will be used to set the metadata document
        const set = jest.fn((document: DocumentData): any => {
            const utcRevokeTimeInSecs = new Date(this._user.tokensValidAfterTime).getTime() / 1000;
            expect(document).toStrictEqual({ revokeTime: utcRevokeTimeInSecs});
        });
        //If the function is to be rejected
        if (reject) {
            //Reject the function
            set.mockRejectedValue(new Error('mock error'));
        }
        //Return the document reference
        return {
            doc: jest.fn((docId: string) => {
                expect(docId).toBe(this._uid);
                return {
                    set: set,
                };
            })
        }
    }
    

    //The mock function for the Firebase Auth
    private _mockFirebaseAuth({rejectTokenExpired = false, rejectTokenRevoked = false, rejectInvalidToken = false, rejectRevokeRefreshTokens = false, rejectGetUser = false}: MockFirebaseAuth): void {
        //The auth object
        const auth = jest.fn(() => ({
            verifyIdToken: this._verifyIdToken(rejectTokenExpired, rejectTokenRevoked, rejectInvalidToken),
            revokeRefreshTokens: this._revokeRefreshTokens(rejectRevokeRefreshTokens),
            getUser: this._getUser(rejectGetUser),
        }));
        //Add the auth to the admin mocked object
        mockObjectProperty(admin, auth, 'auth');
    }

    //The mock function for the Firebase Firestore
    private _mockFirestore({rejectSetMetadata = false}: MockFirestore): void {
        //The firestore object
        const firestore = jest.fn(() => ({
            collection: jest.fn((collection: string) => {
                expect(collection).toBe('metadata');
                return this._metadataDocRef(rejectSetMetadata);
            })
        }));
        //Add the firestore to the admin mocked object
        mockObjectProperty(admin, firestore, 'firestore');
    }

    //****************************Test Cases****************************************//

    public async expectToSucceed() {
        this._mockFirebaseAuth({});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(200);
                return {
                    send: (body: any) => {
                        expect(body).toStrictEqual({ code: 0, });
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(3);
        expect(admin.firestore).toHaveBeenCalledTimes(1);
    }

    public async expectToFailWhenThereIsNoAuthorizationHeader() {
        this._mockFirebaseAuth({});
        this._mockFirestore({});
        const req = { headers: {} };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(401);
                return {
                    send: (body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('permission-denied');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('no-id-token-present');
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenIdTokenIsExpired() {
        this._mockFirebaseAuth({rejectTokenExpired: true});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(406);
                return {
                    send: (body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('failed-precondition');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('id-token-expired');
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenIdTokenIsRevoked() {
        this._mockFirebaseAuth({rejectTokenRevoked: true});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(406);
                return {
                    send: (body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('failed-precondition');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('id-token-expired');
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenIdTokenIsInvalid() {
        this._mockFirebaseAuth({rejectInvalidToken: true});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(401);
                return {
                    send: (body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('permission-denied');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('invalid-id-token');
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenRefreshIdTokensCannotBeRevoked() {
        this._mockFirebaseAuth({rejectRevokeRefreshTokens: true});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {};
        try {
            //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        } catch (e) {
            expect(e).toBeInstanceOf(Error);
            expect((e as Error).message).toBe('mock error');
        }
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(2);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenUserCannotBeObtained() {
        this._mockFirebaseAuth({rejectGetUser: true});
        this._mockFirestore({});
        const req = { headers: this._headers };
        const res = {};
        try {
            //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        } catch (e) {
            expect(e).toBeInstanceOf(Error);
            expect((e as Error).message).toBe('mock error');
        }
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(3);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToSucceedButFailToStoreRevokeTime() {
        this._mockFirebaseAuth({});
        this._mockFirestore({rejectSetMetadata: true});
        const req = { headers: this._headers };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(200);
                return {
                    send: (body: any) => {
                        expect(body).toStrictEqual({ code: 0, });
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.revokeRefreshTokensRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(3);
        expect(admin.firestore).toHaveBeenCalledTimes(1);
    }

}
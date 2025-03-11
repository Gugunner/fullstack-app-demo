import * as admin from 'firebase-admin';
// import { CreateRequest } from 'firebase-admin/auth';
import { mockObjectProperty } from '../mock_objects';
import * as express from 'express';
import { Request } from 'firebase-functions/v2/https';
import * as myFunctions from '../../../src/index';
import { AppException } from '../../../src/exception/app_exception';
import { SubModule } from '../../../src/exception/modules';
import { MockFirestore, MockFirebaseAuth } from './mock_interfaces';

/**
 * This robot is used to test all the scenarios when getting a custom token for custom sign in.
 */
export class GetCustomTokenForCustomSignInRobot {

    //Spy which will be used to check if the function was called
    private _spyRequest = jest.spyOn(myFunctions, 'getCustomTokenForCustomSignInRequest');

    //THe code that will be used to verify the email
    private _code: string;

    //The email that will be used to get the user
    private _email: string;

    //The uid that is in the user document
    private _uid: string; 

    //The custom token that will be created by the Firebase Create Custom Token function
    private _customToken: string;
    
    //The constructor initializes the variables
    constructor({
        code,
        email,
        uid,
        customToken,
    }: {
        code: string,
        email: string,
        uid: string,
        customToken: string,
    }) {
        this._code = code;
        this._email = email;
        this._uid = uid;
        this._customToken = customToken;
    }
    
    //The default code data that will be returned by the code document
    private get _codeData(): jest.Mock {
        return  jest.fn(() => ({ code: this._code }));
    }

    //The code document that will be returned by the firestore
    private _codeDoc(exists: boolean , data: any): any {
        return {
            exists: exists,
            data: data,
        }
    }

    //The user data that will be returned by the Firebase Create User function
    private get _userData(): jest.Mock {
        return jest.fn(() => ({ uid: this._uid }));
    }

    //The code document reference that will be returned by the firestore
    private _codeDocRef(exists: boolean, data: jest.Mock, rejectDelete: boolean): any {
        //The delete code function
        const deleteCode = jest.fn();
        //If the delete should be rejected
        if (rejectDelete) {
            //Reject the delete code function
            deleteCode.mockRejectedValue(new Error('mock error'));
        }
        //Return the code document reference
        return {
            doc: jest.fn((docId: string) => {
                expect(docId).toBe(this._email);
                return  {
                    get: jest.fn(async () => (this._codeDoc(exists, data))),
                    path: `codes/${this._email}`,
                    id: this._email,
                    delete: deleteCode,
                    set: jest.fn((data: any, options: any) => {
                        expect(data).toStrictEqual({ code: '' });
                        expect(options).toStrictEqual({ merge: true });
                    }),
                };
            })
        }
    }

    //The user document that will be returned by the firestore
    private _userDoc(exists: boolean, data: jest.Mock) {
        return {
            exists: exists,
            data: data,
            id: this._uid,
        }
    }

    //The user document query that will be returned by the firestore
    private _userDocQuery(empty: boolean, exists: boolean, data: jest.Mock) {
        return {
            empty: empty,
            docs: [this._userDoc(exists, data)]
        };
    }

    //The user collections query that will be returned by the firestore
    private _userCollectionsQuery(empty: boolean, exists: boolean, data: jest.Mock) {
        return {
            where: jest.fn((fieldProperty: string, opStr: string, value: any) => {
                expect(fieldProperty).toBe('email');
                expect(opStr).toBe('==');
                expect(value).toBe(this._email);
                return {
                    get: jest.fn(async () => this._userDocQuery(empty, exists, data))
                }
            })
        }
    }

    //The mock function for the Firebase Auth
    private _mockFirebaseAuth({rejectCreateCustomToken = false}: MockFirebaseAuth) {
        //The create custom token function
        const createCustomToken = jest.fn((uid: string): any => {
            expect(uid).toStrictEqual(uid);
            return this._customToken;
        });
        //If the create custom token should be rejected
        if (rejectCreateCustomToken) {
            //Reject the create custom token function
            createCustomToken.mockRejectedValue(new Error('mock error'));
        }
        //The auth object
        const auth = jest.fn(() => ({
            createCustomToken: createCustomToken,
        }));
        //Add the auth to the admin mocked object
        mockObjectProperty(admin, auth, 'auth');
    }

    //The mock function for the Firebase Firestore
    private _mockFirebaseFirestore({userQueryIsEmpty = false, userExists = true, userData = this._userData,  codeExists = true, codeData = this._codeData, rejectDeleteCode = false}: MockFirestore): void {
        //The firestore object
        const firestore = jest.fn(() => ({
            collection: jest.fn((collection: string) => {
                if (collection === 'users') return this._userCollectionsQuery(userQueryIsEmpty, userExists, userData);
                if (collection === 'codes') return this._codeDocRef(codeExists, codeData, rejectDeleteCode);
                return {};
            })
        }));
        //Add the firestore to the admin mocked object
        mockObjectProperty(admin, firestore, 'firestore');
    }

    //****************************Test Cases****************************************//

    public async expectToSuceed() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(200);
                return {
                    send: (body: any) => {
                        expect(body).toStrictEqual({ customToken: this._customToken, code: 0, })
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

    public async expectToFailWhenBodyIsUndefined() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = {};
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(400);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('invalid-body');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenBodyIsEmpty() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = { body: { } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(400);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('invalid-body-fields');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenBodyHasNoEmail() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = { body: { code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(400);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('invalid-body-fields');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenBodyHasNoCode() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = { body: { email: this._email } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(400);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('invalid-body-fields');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(0);
    }

    public async expectToFailWhenCodeDocumentDoesNotExist() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({
            codeExists: false,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(404);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('document-not-found');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(1);
    }

    public async expectToFailWhenCodeDocumentHasNoData() {
        this._mockFirebaseAuth({});
        const data = jest.fn().mockImplementation(() => undefined);
        this._mockFirebaseFirestore({
            codeData: data,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(500);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('failed-precondition');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('unknown');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(1);
    }

    public async expectToFailWhenCodesDoNotMatch() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({});
        const req = { body: { email: this._email, code: '654321' } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(409);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('incorrect-verification-code');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(1);
    }

    public async expectToSucceedButFailToRemoveCodeDocument() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({
            rejectDeleteCode: true,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(200);
                return {
                    send: (body: any) => {
                        expect(body).toStrictEqual({ customToken: this._customToken, code: 0, })
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

    public async expectToFailWhenNoUserIsFoundInQuery() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({
            userQueryIsEmpty: true,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(412);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('query-is-empty');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

    public async expectToFailWhenUserDocumentDoesNotExist() {
        this._mockFirebaseAuth({});
        this._mockFirebaseFirestore({
            userExists: false,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(500);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('document-not-found');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

    public async expectToFailWHenUserDocumentHasNoData() {
        this._mockFirebaseAuth({});
        const data = jest.fn().mockImplementation(() => undefined);
        this._mockFirebaseFirestore({
            userData: data,
        });
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: jest.fn((code: number): any => {
                expect(code).toBe(500);
                return {
                    send: jest.fn((body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        expect((body as AppException).code).toBe('failed-precondition');
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('unknown');
                    })
                }
            })            
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(0);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

    public async expectToFailWhenCustomTokenCannotBeCreated() {
        this._mockFirebaseAuth({
            rejectCreateCustomToken: true,
        });
        this._mockFirebaseFirestore({});
        const req = { body: { email: this._email, code: this._code } };
        const res = {
            status: (code: any): any => {
                expect(code).toStrictEqual(500);
                return {
                    send: (body: any) => {
                        expect(body).toBeInstanceOf(AppException);
                        const subModule = (body as AppException).details as SubModule;
                        expect(subModule.errorCode).toBe('custom-token-failed');
                    }
                }
            }
        };
        //Await the call for Promises
        await myFunctions.getCustomTokenForCustomSignInRequest(req as Request, (res as unknown) as express.Response);
        expect(this._spyRequest).toHaveBeenCalledTimes(1);
        expect(admin.auth).toHaveBeenCalledTimes(1);
        expect(admin.firestore).toHaveBeenCalledTimes(2);
    }

}
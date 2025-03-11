/**
 * A defined type used when using Firebase extensions or other services
 * that require specific checks to determine whether they should execute or not.
 * 
 * For example sending an email using firebase email extension should have a logic that
 * allows to be mocked when unit testing the app, blocked when testing the app with the
 * Firebase emulator suite and finally send the email when using real implementations.
 * 
 */
export enum IMPLEMENT_FIREBASE {
    'mock' = 0, /* Allows to execute mocked firebase implementations */
    'send' = 1, /* Allows to execute real firebase implementations */
    'block' = 2, /* Blocks any firebase implementation whether mocked or real */
}
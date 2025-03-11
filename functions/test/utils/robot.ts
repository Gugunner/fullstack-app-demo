import { AccountAuthRobot } from './account_auth_robot/account_auth.robot';


/**
 * This robot is a wrapper for the robots that are uses to test all the firebase functions.
 */
export class Robot {

    //The robot to create an account and login
    auth: AccountAuthRobot;

    //The constructor initializes the robots
    constructor() {
        this.auth = new AccountAuthRobot();
    }

}
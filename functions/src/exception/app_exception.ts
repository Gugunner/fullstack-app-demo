import { HttpsError, FunctionsErrorCode } from "firebase-functions/v2/https";
import * as modules from "./modules";
import { ErrorCode } from "./error_codes";

/**
 * Represents an exception that can be thrown in the application
 */
export class AppException extends HttpsError {
  
  statusCode: number;

  constructor({
    code,
    errorCode,
    message,
    prefix,
    statusCode,
  }: {
    code: FunctionsErrorCode;
    errorCode: ErrorCode,
    message: string;
    prefix: modules.ModulePrefix,
    statusCode: number,
  }) {
    var submodule = undefined;
    if (errorCode !== null && (typeof errorCode) === 'string') {
		// Get the module
        const module = AppException._getModule(prefix);
        submodule = module[errorCode];
    }
	// Call the parent constructor
    super(code, message, submodule);
    this.statusCode = statusCode;
  }

  private static _getModule(modulePrefix: modules.ModulePrefix): modules.Module {
    switch (modulePrefix) {
      case 'auth': return modules.FirebaseAdminAuth;
	  case 'store': return modules.FirebaseAdminFirestore;
	  case 'piix-auth': return modules.PiixAuth;
      default: return modules.PiixFunctions;
    }
  }
}
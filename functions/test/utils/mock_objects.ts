///Adds a property to an object that is a jest mock
/** 
* @param obj The object to add the property to
* @param prop The jest mock property to add
* @param propName The name of the property to add
*/
export const mockObjectProperty = (obj: any, prop: jest.Mock, propName: string) => {
    Object.defineProperty(obj, propName, {
        //Make the property return the mock
        get: jest.fn(() => prop),
        //Make the property configurable so it can be deleted
        configurable: true,
    });
}
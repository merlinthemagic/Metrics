//  Created by Martin Madsen on 1/19/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.
import Foundation

enum MTOException : Error {
    //classObj, MethodName, Message, Code
    case InMethod(AnyObject, String, String, Int)
}


//How to use:
//do {
//    try self.locObj.stop();
//} catch {
//    print("Error info: \(error)")
//}

struct MTO {

    struct Model {
        
        struct Database {
        }
        struct Network {
        }
        struct Identification {
        } 
    }
}

//  Created by Martin Madsen on 1/19/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.
import Foundation

extension MTO.Model.Network {
    
    public class HTTPData {
        
        
        private var _dbConn = 0;
        
        
        public func postData(_ url: URL, _ dataArray: Array<Any>)
        {
            
            //            var request = URLRequest(url: URL(string: "http://www.thisismylink.com/postName.php")!)
            //            request.httpMethod = "POST"
            //            let postString = "id=13&name=Jack"
            //            request.httpBody = postString.data(using: .utf8)
            //            let task = URLSession.shared.dataTask(with: request) { data, response, error in
            //                guard let data = data, error == nil else {                                                 // check for fundamental networking error
            //                    print("error=\(error)")
            //                    return
            //                }
            //
            //                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            //                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
            //                    print("response = \(response)")
            //                }
            //
            //                let responseString = String(data: data, encoding: .utf8)
            //                print("responseString = \(responseString)")
            //            }
            
        }
    }
}

//  Created by Martin Madsen on 1/19/17.
//  Copyright © 2017 Merlin Industries. All rights reserved.
import Foundation

extension MTO.Model.Network {
    
    public class HTTPData {
        
        public func postJson(_ url: String, _ postData: Any)
        {
            
            //json data like this:
            //let postData: [String: Any] = ["title": "ABC", "dict": ["1":"First", "2":"Second"]];
            // or like this (for loop):
            //var postData = [[String:Any]]();
            //then loop over your array and append to postData
            
            //in PHP you would have to pick up the data like this:
            //json_decode($GLOBALS["HTTP_RAW_POST_DATA"], true); // array of the posted data

            let jsonData = try? JSONSerialization.data(withJSONObject: postData, options: .prettyPrinted);

            // create post request
            let url = URL(string: url)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            
            task.resume()
        }
    }
}

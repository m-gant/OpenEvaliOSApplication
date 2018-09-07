//
//  DatabaseRequester.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/7/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class DatabaseRequester {
    
    
    static func searchFor(courseNumber searchText: String, callback: @escaping (([CourseResponse]) -> ()) ) {
        let finalSearchText = searchText.replacingOccurrences(of: " ", with: "%20")
        let baseUrlPath = "https://openeval-server.herokuapp.com/classes/\(finalSearchText)"
        guard let url = URL(string: baseUrlPath) else {
            print("error with url when searching courses")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                print(error as Any)
                return
            }
            
            var requestCourseResponses: [CourseResponse] = []
            
            if let response = try? JSONDecoder().decode(CourseResponseWrapper.self, from: data!) {
                requestCourseResponses = response.message
            }
            
            callback(requestCourseResponses)
            
        }).resume()
        
    }
}

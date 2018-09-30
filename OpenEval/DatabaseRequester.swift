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
    
    static func deployDefaultSurvey(startDate: Date, endDate: Date, name: String, course: String, semester: String, professor: String) {
        
        let startDateInterval = Int(startDate.timeIntervalSince1970)
        let endDateInterval = Int(endDate.timeIntervalSince1970)
        
        let httpCourse = course.replacingOccurrences(of: " ", with: "%20")
        let httpSemester = semester.replacingOccurrences(of: " ", with: "%20")
        
        let baseURlPath = "https://openeval-server.herokuapp.com/surveys/default/\(startDateInterval)/\(endDateInterval)/\(name)/\(httpCourse)/\(httpSemester)/\(professor)"
        
        guard let url = URL(string: baseURlPath) else {
            print("error creating url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error as Any)
                return
            }
            
            print(response)
        
        }.resume()
        
        
    }
    
    static func getCourseSurveys(professor: String, course: String, callback: @escaping (([Survey]) -> ())) {
        
        
        let httpCourse = course.replacingOccurrences(of: " ", with: "%20")
        
        let baseURLPath = "https://openeval-server.herokuapp.com/surveys/\(professor)/\(httpCourse)"
        
        guard let url = URL(string: baseURLPath) else {
            print("error creating url")
            return
        }
        
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error as Any)
                return
            }
            
            var surveyResponses: [Survey] = []
            
            if let response = try? JSONDecoder().decode(SurveyResponseWrapper.self, from: data!) {
                surveyResponses = response.message
                for resp in surveyResponses {
                    print(resp.name)
                }
            } else {
                print("error with decoding response")
            }
            
            callback(surveyResponses)
            
        }.resume()
    }
}

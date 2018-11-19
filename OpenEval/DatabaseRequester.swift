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
        
        
        let httpCourse = course.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? course
        
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
    
    static func getCoursesFor(studentId: String, callback: @escaping (([StudentCourseResponse]) -> ())) {
        
        let url = URL(string: "https://openeval-server.herokuapp.com/studentRegCourses/\(studentId)")!
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                print(error, error?.localizedDescription)
                return
            }
            
            if let responseWrapper = try? JSONDecoder().decode(StudentCourseResponseWrapper.self, from: data) {
                let courseResponses = responseWrapper.message
                callback(courseResponses)
            } else {
                callback([])
            }
        }.resume()
        
        
    }
    
    static func getCourseFor(professorId: String, callback: @escaping (([CourseResponse]) -> ())) {
        
        let url = URL(string: "https://openeval-server.herokuapp.com/registeredCourses/\(professorId)")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data , responses, error) in
            guard let data = data else {
                print(error, error?.localizedDescription)
                return
            }
            
            if let courseResponseWrapper = try? JSONDecoder().decode(CourseResponseWrapper.self, from: data) {
                callback(courseResponseWrapper.message)
            } else {
                callback([])
            }
            
        }.resume()
        
    }
    
    static func professorRegisterFor(course: CourseResponse, professorId: String, completion: @escaping (() -> ()) ) {
    
        let body = ["courseNumber": course.courseNumber, "courseName": course.courseName, "professor" : professorId]
        
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
    
        let url = URL(string: "https://openeval-server.herokuapp.com/registeredCourses/register")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        request.httpMethod = "POST"
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print(error, error?.localizedDescription)
                return
            }
            
            print(response)
            completion()
        }.resume()
    }
    
    static func getDefaultQuestions(callback: @escaping (([Question]) -> ())) {
        
        let url = URL(string: "https://openeval-server.herokuapp.com/questions/default")!
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print(error, error?.localizedDescription)
                return
            }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                print("Couldn't convert to json")
                return
            }
            
            var questions: [Question] = []
            
            let responseDict = jsonObject as! [String: Any]
            let message = responseDict["message"] as! [[String: Any]]
            let questionsResponse = message.first!
            let questionsDict = questionsResponse["questions"] as! [[String: Any]]
            for questionDict in questionsDict {
                let type = questionDict["type"] as! String
                let questionString = questionDict["question"] as! String
                let options : [String] = questionDict["options"] as? [String] ?? []
                let question = Question(type: type, question: questionString, options: options)
                questions.append(question)
            }
            
            callback(questions)
        }.resume()
        
    }
    
    
    static func sendSurveyQuestionResponse(question: Question, studentId: String, surveyId: String, response: String, completion: @escaping (() -> ())) {
        let type = question.type
        let questionString = question.question
        
        let body: [String: String] = ["type": type, "gatech_id": studentId, "surveyID": surveyId, "question": questionString, "response": response]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let url = URL(string: "https://openeval-server.herokuapp.com/responses/responseComplete")!
        
        var request = URLRequest(url: url)
        
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print (error, error?.localizedDescription)
                return
            }
            //print(response)
            
            completion()
        }.resume()
        
    }
    
}

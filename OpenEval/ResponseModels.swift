//
//  ResponseModels.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/7/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

struct CourseResponse: Codable {
    var _id: String
    var courseName: String
    var courseNumber: String
}

struct CourseResponseWrapper: Codable {
    var message: [CourseResponse]
}

struct SurveyResponseWrapper: Codable {
    var message: [Survey]
}

struct StudentCourseResponseWrapper : Codable {
    var message: [StudentCourseResponse]
}

struct StudentCourseResponse: Codable {
    var _id: String
    var courseName: String
    var courseNumber: String
    var professor: String
}

struct Survey : Codable {
    var _id: String
    var startTime: Int
    var endTime: Int
    var name: String
    
    
    func availability() -> Bool {
        
        let startDate = Date(timeIntervalSince1970: Double(exactly: startTime)!)
        let endDate = Date(timeIntervalSince1970: Double(exactly: endTime)!)
        let currentDate = Date()
        
        return (currentDate >= startDate) && (currentDate <= endDate)
        
    }
    
    
    func startDateString() -> String {
        
        let startDate = Date(timeIntervalSince1970: Double(exactly: startTime)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        
        return formatter.string(from: startDate)
    }
    
    func endDateString() -> String {
        
        let endDate = Date(timeIntervalSince1970: Double(exactly: endTime)!)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        
        return formatter.string(from: endDate)
    }
    
    
}

struct Question: Hashable {
    
    var type: String
    var question: String
    var options: [String] = []
    
    var hashValue: Int {
        return question.hashValue
    }
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return (lhs.question == rhs.question && lhs.type == rhs.type && lhs.options == rhs.options)
    }
    
}

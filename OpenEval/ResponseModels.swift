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

struct Survey : Codable {
    var _id: String
    var startTime: Int
    var endTime: Int
    var name: String
    
    
}

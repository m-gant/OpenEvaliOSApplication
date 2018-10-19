//
//  CourseCellView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/7/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class CourseCellView: NibView {

    @IBOutlet weak var courseNumberLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    
    func configure(courseNumber: String, courseName: String) {
        courseNameLabel.text = courseName
        courseNumberLabel.text = courseNumber

    }
    

}

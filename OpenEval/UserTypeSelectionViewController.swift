//
//  UserTypeSelectionViewController.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 11/3/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class UserTypeSelectionViewController: UIViewController {

    
    @IBOutlet weak var studentButton: UIButton!
    @IBOutlet weak var professorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //format buttons
        studentButton.layer.cornerRadius = studentButton.frame.height / 2
        professorButton.layer.cornerRadius = professorButton.frame.height / 2
        
        
       
    }
    
    
    @IBAction func studentButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let studentCourseSurveysVC = storyboard.instantiateViewController(withIdentifier: "studentCourseSurveys") as? StudentCourseSurveysViewController {
            studentCourseSurveysVC.configureSelf(sender: self, studentId: "cperez3")
        }
    }
    

    @IBAction func professorButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let professorCoursesVC = storyboard.instantiateViewController(withIdentifier: "professorCourses") as? ProfessorCoursesVC {
            professorCoursesVC.configureSelf(sender: self, professorId: "abray3")
        }
    }
    
}

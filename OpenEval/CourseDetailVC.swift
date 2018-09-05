//
//  CourseDetailVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/4/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class CourseDetailVC: UIViewController {

    @IBOutlet weak var courseTitleLabel: UILabel!
    var courseName: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        courseTitleLabel.text = courseName
    }
    
    func presentSelf(sender: UIViewController, with courseTitle: String) {
        courseName = courseTitle
        if let vc = sender as? ProfessorCoursesVC {
            vc.presentVC(self)
        }
        
    }


}

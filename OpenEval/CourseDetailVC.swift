//
//  CourseDetailVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/4/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class CourseDetailVC: UIViewController {


    var courseName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseName
        
    }
    
    func configureSelf(sender: UIViewController, with courseTitle: String) {
        courseName = courseTitle
        sender.navigationController?.pushViewController(self, animated: true)
        
    }


}


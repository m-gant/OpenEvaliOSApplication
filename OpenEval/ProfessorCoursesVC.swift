//
//  ProfessorCoursesVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/2/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ProfessorCoursesVC: UIViewController {
    
    
    var courseNames: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let savedCourseNames = UserDefaults.standard.object(forKey: "Burdell") as? [String] {
            courseNames = savedCourseNames
            tableView.reloadData()
        }
    }
    
    
    @IBAction func addCourseButtonPressed(_ sender: Any) {
        
        if let courseSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "courseSearch") as? CourseSearchVC {
            self.addChildViewController(courseSearchVC)
            self.view.addSubview(courseSearchVC.view)
            courseSearchVC.view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addConstraints([
                courseSearchVC.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30),
                courseSearchVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                courseSearchVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                courseSearchVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            
            courseSearchVC.assignClosures(onDismiss: {
                courseSearchVC.view.removeFromSuperview()
                courseSearchVC.removeFromParentViewController()
            }) { (courseNumber) in
                self.courseNames.append(courseNumber)
                UserDefaults.standard.set(self.courseNames, forKey: "Burdell")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    
   
}


extension ProfessorCoursesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = courseNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseNames.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let courseName = courseNames[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let courseDetail = storyBoard.instantiateViewController(withIdentifier: "courseDetail") as? CourseDetailVC {
            courseDetail.configureSelf(sender: self, with: courseName)
        }
    }
    
    
    
    
    
}

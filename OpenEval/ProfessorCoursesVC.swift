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
        let alert = UIAlertController(title: "Enter Course Number", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "LMC 1234, CS 4567, etc."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (action) in
            let textField = alert.textFields![0]
            if let text = textField.text {
                self.courseNames.append(text)
                UserDefaults.standard.set(self.courseNames, forKey: "Burdell")
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(submitAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentVC(_ VC: UIViewController) {
        present(VC, animated: true, completion: nil)
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
            courseDetail.presentSelf(sender: self, with: courseName)
        }
    }
    
    
    
    
    
}

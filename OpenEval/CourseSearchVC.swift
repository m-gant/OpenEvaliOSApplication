//
//  CourseSearchVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/6/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class CourseSearchVC: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var onDismiss: (() -> ())!
    var onCellSelect: ((CourseResponse) -> ())!
    
    var searchResults: [CourseResponse] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func assignClosures(onDismiss: @escaping (() -> ()), onCellSelect: @escaping ((CourseResponse) -> ())) {
        self.onDismiss = onDismiss
        self.onCellSelect = onCellSelect
    }

   

}


extension CourseSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DatabaseRequester.searchFor(courseNumber: searchText) { (courseResponses) in
            self.searchResults = courseResponses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onDismiss()
    }
    
    
}

extension CourseSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let courseNameCell = UITableViewCell()
        courseNameCell.textLabel?.text = searchResults[indexPath.row].courseNumber + ", " + searchResults[indexPath.row].courseName
        return courseNameCell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCourse = searchResults[indexPath.row]
        let alert = UIAlertController(title: "Are you sure?", message: "You are registering for \(selectedCourse.courseNumber)" , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.onCellSelect(selectedCourse)
            self.onDismiss()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

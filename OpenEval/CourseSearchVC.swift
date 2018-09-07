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
    var onCellSelect: ((String) -> ())!
    
    var searchResults: [CourseResponse] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
       
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func assignClosures(onDismiss: @escaping (() -> ()), onCellSelect: @escaping ((String) -> ())) {
        self.onDismiss = onDismiss
        self.onCellSelect = onCellSelect
    }

   

}


extension CourseSearchVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
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
        var courseNameCell = UITableViewCell()
        courseNameCell.textLabel?.text = searchResults[indexPath.row].courseNumber + ", " + searchResults[indexPath.row].courseName
        return courseNameCell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onCellSelect(searchResults[indexPath.row].courseNumber)
        onDismiss()
    }
    
}

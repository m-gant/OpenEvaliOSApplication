//
//  ProfessorCoursesVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/2/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ProfessorCoursesVC: UIViewController {
    
    
    var courses: [CourseResponse] = []
    @IBOutlet weak var scrollContentView: UIView!
    
    //CoursesView
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    @IBOutlet weak var coursesViewSeparatorView: UIView!
    
    let professorCoursesView = CollectionComponentView()
    let blurg = ProfessorCoursesView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(type(of: blurg).description().components(separatedBy: ".").last!)
        configureViews()
        
        if let savedCoursesData = UserDefaults.standard.object(forKey: "Burdell") as? Data, let savedCourses = try? PropertyListDecoder().decode([CourseResponse].self, from: savedCoursesData) {
            courses = savedCourses
            coursesCollectionView.reloadData()
        }
    }
    
    func configureViews() {
        
       configureCoursesView()
        
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
            }) { (courseResponse) in
                self.courses.append(courseResponse)
                
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.courses), forKey: "Burdell")
                DispatchQueue.main.async {
                    self.coursesCollectionView.reloadData()
                }
            }
            
        }
        
    }
    
    
   
}



//MARK: Courses View Handling
extension ProfessorCoursesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configureCoursesView() {
        coursesCollectionView.delegate = self
        coursesCollectionView.dataSource = self
        coursesViewSeparatorView.layer.cornerRadius = coursesViewSeparatorView.frame.height / 2
        coursesCollectionView.register(ProfessorCourseCollectionViewCell.self, forCellWithReuseIdentifier: "professorCoursesCell")
        coursesCollectionView.backgroundColor = .clear
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        coursesCollectionView.setCollectionViewLayout(layout, animated: false)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "professorCoursesCell", for: indexPath) as! ProfessorCourseCollectionViewCell
        let course = courses[indexPath.item]
        cell.layout(courseName: course.courseName, courseNumber: course.courseNumber)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 2 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCourse = courses[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let courseDetailVC = storyboard.instantiateViewController(withIdentifier: "courseDetail") as? CourseDetailVC {
            courseDetailVC.configureSelf(sender: self, with: selectedCourse)
        }
    }
    
    
}



//
//  StudentCourseSurveysViewController.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 11/3/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class StudentCourseSurveysViewController: UIViewController {

    var studentId: String!
    var scrollContentView: UIView!
    var courseNumbers: [String] = []
    var courseProfessors : [String : String] = [:]
    var courseCollectionViews : [UICollectionView: String] = [:]
    var courseViews : [String : UIView] = [:]
    var courseSurveys : [String: [Survey]] = [:]
    let COURSEVIEWHEIGHT : CGFloat = 225
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Course Surveys"
        // Do any additional setup after loading the view.
        layoutScrollView()
        layoutCourseViews()
        
    }
    

    func layoutScrollView() {
        
        let masterScrollView = UIScrollView()
        scrollContentView = UIView()
        self.view.addSubview(masterScrollView)
        masterScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            masterScrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            masterScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            masterScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            masterScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)])
        
        masterScrollView.addSubview(scrollContentView)
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        masterScrollView.addConstraints([
            scrollContentView.topAnchor.constraint(equalTo: masterScrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: masterScrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: masterScrollView.trailingAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: masterScrollView.bottomAnchor),
            scrollContentView.heightAnchor.constraint(equalToConstant: self.view.frame.height),
            scrollContentView.widthAnchor.constraint(equalToConstant: self.view.frame.width)])
        scrollContentView.backgroundColor = UIColor.groupTableViewBackground
        
    }
    
    func retrieveData(completion: @escaping (() -> ())) {
        DatabaseRequester.getCoursesFor(studentId: studentId) { (courseResponses) in
            for courseResponse in courseResponses {
                self.courseNumbers.append(courseResponse.courseNumber)
                self.courseProfessors[courseResponse.courseNumber] = courseResponse.professor
                DatabaseRequester.getCourseSurveys(professor: courseResponse.professor, course: courseResponse.courseNumber, callback: { (surveys) in
                    self.courseSurveys[courseResponse.courseNumber] = surveys
                    completion()
                })
            }
            
            
            
        }
    }
    
    func layoutCourseViews() {
        
        retrieveData {
            
            DispatchQueue.main.async {
                
                self.scrollContentView.heightAnchor.constraint(equalToConstant: CGFloat(self.courseNumbers.count) * self.COURSEVIEWHEIGHT)
                for index in 0..<self.courseNumbers.count {
                    let course = self.courseNumbers[index]
                    let courseView = self.createCourseSurveysView(courseName: course)
                    self.courseViews[course] = courseView
                    
                    
                    self.scrollContentView.addSubview(courseView)
                    courseView.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollContentView.addConstraints([
                        courseView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor),
                        courseView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor),
                        courseView.heightAnchor.constraint(equalToConstant: self.COURSEVIEWHEIGHT)
                        ])
                    
                    
                    if index != 0 {
                        let prevCourse = self.courseNumbers[index - 1]
                        let prevCourseView = self.courseViews[prevCourse] ?? UIView()
                        courseView.topAnchor.constraint(equalTo: prevCourseView.bottomAnchor).isActive = true
                        
                    } else {
                        courseView.topAnchor.constraint(equalTo: self.scrollContentView.topAnchor).isActive = true
                    }
                    
                    
                    
                    
                }
                
            }
        }
        
        
    }
    
    
    func createCourseSurveysView(courseName: String) -> UIView {
        let courseView = UIView()
        let courseNameLabel = UILabel()
        courseNameLabel.attributedText = NSAttributedString(string: courseName, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 26, weight: .bold)])
        
        courseView.addSubview(courseNameLabel)
        courseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        courseNameLabel.topAnchor.constraint(equalTo: courseView.topAnchor, constant: 10).isActive = true
        courseNameLabel.leadingAnchor.constraint(equalTo: courseView.leadingAnchor, constant: 10).isActive = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let courseCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: COURSEVIEWHEIGHT), collectionViewLayout: layout)
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
        courseCollectionView.backgroundColor = .clear
        courseCollectionViews[courseCollectionView] = courseName
        
        courseCollectionView.register(SurveyCollectionViewCell.self, forCellWithReuseIdentifier: "courseSurvey")
        
        courseView.addSubview(courseCollectionView)
        courseCollectionView.translatesAutoresizingMaskIntoConstraints = false
        courseView.addConstraints([
            courseCollectionView.topAnchor.constraint(equalTo: courseNameLabel.bottomAnchor, constant: 10),
            courseCollectionView.leadingAnchor.constraint(equalTo: courseView.leadingAnchor, constant: 10),
            courseCollectionView.trailingAnchor.constraint(equalTo: courseView.trailingAnchor, constant: -10),
            courseCollectionView.bottomAnchor.constraint(equalTo: courseView.bottomAnchor, constant: -10)
            ])
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        courseView.addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        courseView.addConstraints([
            separatorView.leadingAnchor.constraint(equalTo: courseView.leadingAnchor, constant: 10),
            separatorView.topAnchor.constraint(equalTo: courseCollectionView.bottomAnchor, constant: 5),
            separatorView.trailingAnchor.constraint(equalTo: courseView.trailingAnchor, constant: -10),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
            ])
        separatorView.layer.cornerRadius = separatorView.frame.height / 2
        
        
        
        
        return courseView
    }
    
    func configureSelf(sender: UIViewController, studentId: String) {
        self.studentId = studentId
        sender.navigationController?.pushViewController(self, animated: true)
    }

}


extension StudentCourseSurveysViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let courseNumber = courseCollectionViews[collectionView] else {
            return 0
        }
        
        guard let surveys = courseSurveys[courseNumber] else {
            return 0
        }
        
        return surveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let course = courseCollectionViews[collectionView] else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseSurvey", for: indexPath) as! SurveyCollectionViewCell
            return cell
        }
        
        guard let surveys = courseSurveys[course] else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseSurvey", for: indexPath) as! SurveyCollectionViewCell
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "courseSurvey", for: indexPath) as! SurveyCollectionViewCell
        cell.layoutForCourseDetail(survey: surveys[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.1, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let course = courseCollectionViews[collectionView] else {
            return
        }
        
        guard let surveys = courseSurveys[course] else {
            return
        }
        
        let curSurvey = surveys[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if curSurvey.availability(), let surveyResponsesViewController = storyboard.instantiateViewController(withIdentifier: "surveyResponse") as? SurveyResponseViewController {
            surveyResponsesViewController.configureSelf(sender: self, studentId: self.studentId, survey: curSurvey)
        } else if !curSurvey.availability() {
            let surveyNotAvailableAlert = UIAlertController(title: "Survey is no longer available", message: "Please choose another available survey.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel)
            surveyNotAvailableAlert.addAction(OKAction)
            self.present(surveyNotAvailableAlert, animated: true, completion: nil)
        }
        
    }
    
    
}

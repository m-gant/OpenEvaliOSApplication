//
//  ProfessorCoursesVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/2/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ProfessorCoursesVC: UIViewController {
    
    var professorId: String!
    var courses: [CourseResponse] = []
    var scrollContentView: UIView!
    var courseNumbers: [String] = []
    var courseCollectionViews : [UICollectionView: String] = [:]
    var courseViews : [String : UIView] = [:]
    var courseSurveys : [String: [Survey]] = [:]
    var additionButtons : [UIButton: String] = [:]
    let COURSEVIEWHEIGHT : CGFloat = 225
    var totalCourses = 0
    var courseSurveysLoaded = 0 {
        didSet {
            if (courseSurveysLoaded != 0 && courseSurveysLoaded == totalCourses) {
                layoutCourseViews()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layoutScrollView()
        //retrieveData()
        self.navigationItem.title = "Courses"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        reset()
        retrieveData()
        
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
            scrollContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.frame.height),
            scrollContentView.widthAnchor.constraint(equalToConstant: self.view.frame.width)])
        scrollContentView.backgroundColor = UIColor.groupTableViewBackground
        
    }
    
    func layoutCourseViews() {
        
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
                
                if index == self.courseNumbers.count - 1 {
                    self.scrollContentView.bottomAnchor.constraint(equalTo: courseView.bottomAnchor, constant: 10).isActive = true
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
        
        
        let surveyAdditionButton = UIButton()
        let surveyAdditionButtonAttributedTitle = NSAttributedString(string: "+", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 32, weight: .light), NSAttributedStringKey.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1 , alpha: 1)])
        surveyAdditionButton.setAttributedTitle(surveyAdditionButtonAttributedTitle, for: .normal)
        surveyAdditionButton.addTarget(self, action: #selector(addSurveyToCourse(sender:)), for: .touchUpInside)
        additionButtons[surveyAdditionButton] = courseName
        
        courseView.addSubview(surveyAdditionButton)
        surveyAdditionButton.translatesAutoresizingMaskIntoConstraints = false
        surveyAdditionButton.topAnchor.constraint(equalTo: courseView.topAnchor, constant: 10).isActive = true
        surveyAdditionButton.trailingAnchor.constraint(equalTo: courseView.trailingAnchor, constant: -10).isActive = true
        surveyAdditionButton.heightAnchor.constraint(equalTo: courseNameLabel.heightAnchor, multiplier: 1).isActive = true
        
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
    
    
    @objc func addSurveyToCourse(sender: UIButton) {
        if let courseName = additionButtons[sender] {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let defaultSurveySettingsVC = storyboard.instantiateViewController(withIdentifier: "defaultSurveySettingsVC") as? DefaultSurveySettingsVC {
                defaultSurveySettingsVC.configure(sender: self, courseName: courseName, professorId: professorId)
            }
        }
    }
        
    
    
    func retrieveData() {
        
        totalCourses = 0
        courseSurveysLoaded = 0
        
        DatabaseRequester.getCoursesFor(professorId: professorId) { (courseResponses) in
            self.totalCourses = courseResponses.count
            for courseResponse in courseResponses {
                print(courseResponse.courseNumber)
                self.courseNumbers.append(courseResponse.courseNumber)
                DatabaseRequester.getCourseSurveys(professor: self.professorId, course: courseResponse.courseNumber, callback: { (surveys) in
                    self.courseSurveys[courseResponse.courseNumber] = surveys
                    self.courseSurveysLoaded += 1
                    print(self.totalCourses)
                    
                })
            }
        }   
        
    }
    
    func reset() {
        
        courseNumbers = []
        courseCollectionViews = [:]
        courseViews = [:]
        courseSurveys = [:]
        additionButtons = [:]
        totalCourses = 0
        courseSurveysLoaded = 0
        DispatchQueue.main.async {
            for subview in self.scrollContentView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        
    }
    
    
    func configureSelf(sender: UIViewController, professorId: String) {
        sender.navigationController?.pushViewController(self, animated: true)
        self.professorId = professorId
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
                
                DatabaseRequester.professorRegisterFor(course: courseResponse, professorId: self.professorId, completion: {
                    self.courses.append(courseResponse)
                    self.reset()
                    self.retrieveData()
                    
                })
                
            }
            
        }
        
    }
    
    
   
}



//MARK: Courses View Handling
extension ProfessorCoursesVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        
        guard let course = courseCollectionViews[collectionView] else { return }
        guard let surveys = courseSurveys[course] else { return }
        let curSurvey = surveys[indexPath.item]
        
        let alert = UIAlertController(title: "Pick Action", message: nil, preferredStyle: .actionSheet)
        
        let viewResponsesAction = UIAlertAction(title: "View Responses", style: .default) { (_) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let viewResponsesVC = storyboard.instantiateViewController(withIdentifier: "viewSurveyResponsesVC") as? ViewSurveyResponsesViewController {
                viewResponsesVC.configureSelf(sender: self, surveyId: curSurvey._id)
            }
            
        }
        
        let emailAction = UIAlertAction(title: "Send Email Reminder", style: .default) { (_) in
            //do something
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(viewResponsesAction)
        alert.addAction(emailAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
       

    }
    
    
    
}



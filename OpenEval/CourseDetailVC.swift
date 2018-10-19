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
    var course: CourseResponse!
    var surveys: [Survey] = []
    
    @IBOutlet weak var surveyTypeView: UIView!
    @IBOutlet weak var defaultSurveyButton: UIButton!
    @IBOutlet weak var surveyTypeSeparatorView: UIView!
    
// Created Surveys View
    @IBOutlet weak var createdSurveysView: UIView!
    @IBOutlet weak var surveysCollectionView: UICollectionView!
    @IBOutlet weak var createdSurveysSeparatorView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseName
    
        configureSurveyTypeView()
        configureCreateSuveysView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DatabaseRequester.getCourseSurveys(professor: "gpburdell3", course: courseName) { (surveys) in
            self.surveys = surveys
            DispatchQueue.main.async {
                self.surveysCollectionView.reloadData()
            }
        }
        
    }
    
    func configureSelf(sender: UIViewController, with course: CourseResponse) {
        self.course = course
        courseName = course.courseNumber
        sender.navigationController?.pushViewController(self, animated: true)
        
    }
    
    
    
    @IBAction func defaultSurveyButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let defaultSurveySettingsVC = storyboard.instantiateViewController(withIdentifier: "defaultSurveySettingsVC") as? DefaultSurveySettingsVC {
            defaultSurveySettingsVC.configure(sender: self, courseName: courseName)
        }
    }
    

}

//MARK: Survey Type View
extension CourseDetailVC {
    
    func configureSurveyTypeView() {
        
        surveyTypeView.backgroundColor = .clear
        defaultSurveyButton.layer.cornerRadius = 10
        surveyTypeSeparatorView.backgroundColor = .lightGray
        surveyTypeSeparatorView.layer.cornerRadius = surveyTypeSeparatorView.frame.height / 2
        
    }
}

//MARK: Created Surveys View
extension CourseDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func configureCreateSuveysView() {
        
        createdSurveysView.backgroundColor = .clear
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        surveysCollectionView.setCollectionViewLayout(layout, animated: false)
        surveysCollectionView.delegate = self
        surveysCollectionView.dataSource = self
        surveysCollectionView.backgroundColor = .clear
        surveysCollectionView.register(SurveyCollectionViewCell.self, forCellWithReuseIdentifier: "surveys")
        
        createdSurveysSeparatorView.backgroundColor = .lightGray
        createdSurveysSeparatorView.layer.cornerRadius = createdSurveysSeparatorView.frame.height / 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "surveys", for: indexPath) as! SurveyCollectionViewCell
        cell.layoutForCourseDetail(survey: surveys[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2 - 10, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
}


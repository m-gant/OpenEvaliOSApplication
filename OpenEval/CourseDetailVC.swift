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
    var surveys: [Survey] = []
    
    @IBOutlet weak var defaultSurveyButton: UIButton!
    @IBOutlet weak var customSurveyButton: UIButton!
    
    @IBOutlet weak var surveysCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = courseName
        
        defaultSurveyButton.layer.cornerRadius = defaultSurveyButton.frame.height / 2
        customSurveyButton.layer.cornerRadius = customSurveyButton.frame.height / 2
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        surveysCollectionView.setCollectionViewLayout(layout, animated: false)
        surveysCollectionView.delegate = self
        surveysCollectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        DatabaseRequester.getCourseSurveys(professor: "gpburdell3", course: courseName) { (surveys) in
            self.surveys = surveys
            DispatchQueue.main.async {
                self.surveysCollectionView.reloadData()
            }
        }
        
    }
    
    func configureSelf(sender: UIViewController, with courseTitle: String) {
        courseName = courseTitle
        sender.navigationController?.pushViewController(self, animated: true)
        
    }
    
    
    
    @IBAction func defaultSurveyButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let defaultSurveySettingsVC = storyboard.instantiateViewController(withIdentifier: "defaultSurveySettingsVC") as? DefaultSurveySettingsVC {
            defaultSurveySettingsVC.configure(sender: self, courseName: courseName)
        }
    }
    

}


extension CourseDetailVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! BasicCollectionViewCell
        cell.textLabel.text = surveys[indexPath.item].name
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.5, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}


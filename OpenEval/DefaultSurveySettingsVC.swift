//
//  DefaultSurveySettingsVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/24/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class DefaultSurveySettingsVC: UIViewController {
    
    var professorId: String!
    @IBOutlet weak var surveyNameView: UIView!
    @IBOutlet weak var surveyNameTextField: UITextField!
    @IBOutlet weak var surveyNameSeparatorView: UIView!
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var deployDefaultSurveyButton: UIButton!
    
    var courseName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        deployDefaultSurveyButton.layer.cornerRadius = deployDefaultSurveyButton.frame.height / 2
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
        self.navigationItem.title = "Survey Settings"
        surveyNameTextField.delegate = self
        configureSurveyNamesView()
    }
    
    func configure(sender: UIViewController, courseName: String, professorId: String) {
        self.courseName = courseName
        sender.navigationController?.pushViewController(self, animated: true)
        self.professorId = professorId
        
    }
    
    func datesValid() -> Bool {
        return (startDatePicker.date < endDatePicker.date)
    }
    
    func presentInvalidDatesAlert() {
        let alert = UIAlertController(title: "Invalid Dates", message: "Please make sure that your start date is before the end date.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deployDefaultSurveyButtonPressed(_ sender: Any) {
        if datesValid() {
            //do whatever
            let surveyName = surveyNameTextField.text != "" ? surveyNameTextField.text! : "DefaultSurvey"
            let surveyNameString = surveyName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? surveyName
            DatabaseRequester.deployDefaultSurvey(startDate: startDatePicker.date, endDate: endDatePicker.date, name: surveyNameString, course: courseName, semester: "Fall 2018", professor: professorId)
            self.navigationController?.popViewController(animated: true)
        } else {
            presentInvalidDatesAlert()
        }
    }
    
    

}

//MARK: Survey Name View

extension DefaultSurveySettingsVC : UITextFieldDelegate{
    
    func configureSurveyNamesView() {
        
        surveyNameSeparatorView.backgroundColor = .lightGray
        surveyNameSeparatorView.layer.cornerRadius = surveyNameSeparatorView.frame.height / 2
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//
//  DefaultSurveySettingsVC.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 9/24/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class DefaultSurveySettingsVC: UIViewController {
    
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
        self.navigationItem.title = "Default Survey Settings"
    }
    
    func configure(sender: UIViewController, courseName: String) {
        self.courseName = courseName
        sender.navigationController?.pushViewController(self, animated: true)
        
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
            DatabaseRequester.deployDefaultSurvey(startDate: startDatePicker.date, endDate: endDatePicker.date, name: "testSurvey1", course: courseName, semester: "Fall 2018", professor: "gpburdell3")
            self.navigationController?.popViewController(animated: true)
        } else {
            presentInvalidDatesAlert()
        }
    }
    

}

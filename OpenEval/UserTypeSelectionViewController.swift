//
//  UserTypeSelectionViewController.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 11/3/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class UserTypeSelectionViewController: UIViewController {

    
  
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //format buttons
        usernameTextField.layer.cornerRadius = usernameTextField.frame.height / 2
        
        passwordTextField.layer.cornerRadius = passwordTextField.frame.height / 2
        submitButton.layer.cornerRadius = submitButton.frame.height / 2
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
       
    }
    
    
    func studentLogin(username: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let studentCourseSurveysVC = storyboard.instantiateViewController(withIdentifier: "studentCourseSurveys") as? StudentCourseSurveysViewController {
            studentCourseSurveysVC.configureSelf(sender: self, studentId: username)
        }
    }
    

    func professorLogin(username: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let professorCoursesVC = storyboard.instantiateViewController(withIdentifier: "professorCourses") as? ProfessorCoursesVC {
            professorCoursesVC.configureSelf(sender: self, professorId: username)
        }
    }
    
    func presentIncompleteFormsAlert() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Incomplete Form", message: "Please enter a valid username and password.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func presentInvalidUsernamePassword() {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Invalid Username and Password", message: "Please enter a valid username and password.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(OKAction)
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, username != "" else {
            presentIncompleteFormsAlert()
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            presentIncompleteFormsAlert()
            return
        }
        
        DatabaseRequester.validate(username: username, password: password) { (valid, professor) in
            guard valid else {
                DispatchQueue.main.async {
                    self.presentInvalidUsernamePassword()
                }
                return
            }
            
            if professor {
                DispatchQueue.main.async {
                    self.professorLogin(username: username)
                }
            } else {
                DispatchQueue.main.async {
                    self.studentLogin(username: username)
                }
            }
        }
    }
    
    
    
    
}

extension UserTypeSelectionViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}

//
//  SurveyResponseViewController.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 11/12/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class SurveyResponseViewController: UIViewController {

    var studentId: String!
    var surveyId: String!
    var survey: Survey!
    var scrollContentView: UIView!
    var buttonQuestion : [UIButton: Question] = [:]
    var responses : [Question: String] = [:]
    var textViewQuestion : [UITextView: Question] = [:]
    var questionViews : [String: UIView] = [:]
    let MULTIPLECHOICEBUTTONHEIGHT = 60
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        layoutScrollView()
        layoutQuestionViews()
    }
    

    func configureSelf(sender: UIViewController, studentId: String, survey: Survey) {
        sender.navigationController?.pushViewController(self, animated: true)
        self.studentId = studentId
        self.survey = survey
        self.surveyId = survey._id
        self.navigationItem.title = survey.name
    }
    
    
    //set up scroll view to place everything in
    //get the questions that need to be displayed
    //for each question set up the view that will hold the question contents
    //add each question to the scroll view
    //add a submit button at the bottom
    
    func layoutScrollView() {
        
        let masterScrollView = UIScrollView()
        masterScrollView.keyboardDismissMode = .interactive
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
    
    
    func createQuestionView(question: Question) -> UIView {
        let questionView = UIView()
        
        let questionLabel = UILabel()
        questionLabel.attributedText = NSAttributedString(string: question.question, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: .bold)])
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        questionView.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionView.addConstraints([
            questionLabel.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 10),
            questionLabel.topAnchor.constraint(equalTo: questionView.topAnchor, constant: 10),
            questionLabel.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -10)
            ])
        
        var answerView = UIView()
        
        if question.type == "mc" {
            
            let stackView = UIStackView()
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            
            for index in 0..<question.options.count {
                let multipleChoiceButton = UIButton()
                let questionString = question.options[index]
                multipleChoiceButton.tag = index
                buttonQuestion[multipleChoiceButton] = question
                multipleChoiceButton.addTarget(self, action: #selector(multipleChoiceButtonTarget(sender:)), for: .touchUpInside)
                multipleChoiceButton.heightAnchor.constraint(equalToConstant: CGFloat(MULTIPLECHOICEBUTTONHEIGHT)).isActive = true
                multipleChoiceButton.widthAnchor.constraint(equalToConstant: CGFloat(self.view.frame.width - 20)).isActive = true
                stackView.addArrangedSubview(multipleChoiceButton)
                
                multipleChoiceButton.layer.borderWidth = 2
                multipleChoiceButton.layer.borderColor = UIColor.green.cgColor
                
                let selectedAttributedTitle = NSAttributedString(string: questionString, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: .semibold)])
                let normalAttributedTitle = NSAttributedString(string: questionString, attributes: [NSAttributedStringKey.foregroundColor : UIColor.green, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: .semibold)])
                multipleChoiceButton.setAttributedTitle(normalAttributedTitle, for: .normal)
                multipleChoiceButton.setAttributedTitle(selectedAttributedTitle, for: .selected)
                
                
                
            }
            
            stackView.spacing = 10
            stackView.heightAnchor.constraint(equalToConstant: CGFloat(question.options.count * MULTIPLECHOICEBUTTONHEIGHT) + (stackView.spacing * CGFloat(question.options.count - 1))).isActive = true
            
            answerView = stackView
            
            
        } else if question.type == "free" {
            
            let textView = UITextView()
            textViewQuestion[textView] = question
            textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            textView.layer.cornerRadius = 10
            textView.delegate = self
            textView.backgroundColor = .white
            
            answerView = textView
            
        }
        
        //answerView = UIView()
        //answerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        answerView.isHidden = false
        questionView.addSubview(answerView)
        answerView.translatesAutoresizingMaskIntoConstraints = false
        questionView.addConstraints([
            answerView.leadingAnchor.constraint(equalTo: questionView.leadingAnchor, constant: 10),
            answerView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 10),
            answerView.trailingAnchor.constraint(equalTo: questionView.trailingAnchor, constant: -10),
            answerView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: -10)
            ])
        
        return questionView
    }
    
    func layoutQuestionViews() {
        
        DatabaseRequester.getDefaultQuestions { (questions) in
            
            DispatchQueue.main.async {
                
                for index in 0..<questions.count {
                    
                    let questionView = self.createQuestionView(question: questions[index])
                    self.questionViews[questions[index].question] = questionView
                    questionView.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollContentView.addSubview(questionView)
                    self.scrollContentView.addConstraints([
                        questionView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 0),
                        questionView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: 0)
                        ])
                    
                    if index != 0 {
                        
                        let prevQuestion = questions[index - 1]
                        if let prevQuestionView = self.questionViews[prevQuestion.question] {
                            questionView.topAnchor.constraint(equalTo: prevQuestionView.bottomAnchor, constant: 10).isActive = true
                        }
                        
                    } else {
                        
                        questionView.topAnchor.constraint(equalTo: self.scrollContentView.topAnchor, constant: 10).isActive = true
                        
                    }
                    
                    if index == questions.count - 1 {
                        //self.scrollContentView.heightAnchor.
                        //self.scrollContentView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 10).isActive = true
                        
                        let submitButton = UIButton()
                        submitButton.backgroundColor = .green
                        submitButton.addTarget(self, action: #selector(self.submitButtonPressed(sender:)), for: .touchUpInside)
                        self.scrollContentView.addSubview(submitButton)
                        submitButton.translatesAutoresizingMaskIntoConstraints = false
                        
                        let normalAttributedTitle = NSAttributedString(string: "SUBMIT", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: .bold)])
                        
                        submitButton.setAttributedTitle(normalAttributedTitle, for: .normal)
                        
                    
                        
                        self.scrollContentView.addConstraints([
                            submitButton.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 10),
                            submitButton.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 10),
                            submitButton.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: -10),
                            submitButton.heightAnchor.constraint(equalToConstant: 45),
                            self.scrollContentView.bottomAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 10)
                            ])
                        
                       
                    }
                    
            
                }
                
            }
            
        }
        
       
    }
    
    
    @objc func multipleChoiceButtonTarget(sender: UIButton) {
        
       
        
        print("called")
        if let parentView = sender.superview as? UIStackView {
            for subView in parentView.arrangedSubviews {
                if let button = subView as? UIButton {
                    if button != sender {
                        button.isSelected = false
                        button.backgroundColor = .white
                    } else {
                        button.isSelected = true
                        button.backgroundColor = .green
                    }
                }
            }
        }
        
        if let question = buttonQuestion[sender] {
            responses[question] = sender.titleLabel?.text
        }
        
    }
    
    @objc func submitButtonPressed(sender: UIButton) {
        
        //perhaps do a question check and alert user if all questions haven't been answered
        
        
        for question in responses.keys {
            //send request to update survey results
            let response = responses[question] ?? "No response"
            DatabaseRequester.sendSurveyQuestionResponse(question: question, studentId: self.studentId, surveyId: self.surveyId, response: response) {
                //Do nothing
            }
        }
        
        
        let alert = UIAlertController(title: "Survey Responses Submitted!", message: nil, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
}


extension SurveyResponseViewController: UITextViewDelegate {
    
    
    func textViewDidChange(_ textView: UITextView) {
        if let question = textViewQuestion[textView] {
            responses[question] = textView.text
        }
    }
    
    
}

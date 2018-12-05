//
//  ViewSurveyResponsesViewController.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 12/3/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ViewSurveyResponsesViewController: UIViewController {
    
    var surveyId: String!
    var scrollContentView: UIView!
    var surveyQuestionResponses : [SurveyQuestionResponse] = []
    var responseViews: [SurveyQuestionResponse: UIView] = [:]
    var MULTIPLECHOICEOPTIONHEIGHT = 60

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutScrollView()
        layoutQuestionViews()
        navigationItem.title = "Responses"
        
    }
    
    func configureSelf(sender: UIViewController, surveyId: String) {
        self.surveyId = surveyId
        sender.navigationController?.pushViewController(self, animated: true)
    }
    
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
    
    func createQuestionView(surveyQuestionResponse: SurveyQuestionResponse) -> UIView {
        let questionView = UIView()
        
        let questionLabel = UILabel()
        questionLabel.attributedText = NSAttributedString(string: surveyQuestionResponse.question, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 22, weight: .bold)])
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
        
        if surveyQuestionResponse.type == "mc" {
            
            let stackView = UIStackView()
            stackView.alignment = .center
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            
            for mcOption in surveyQuestionResponse.mcResponsesCounts.keys {
                
                let multipleChoiceOptionLabel = UILabel()
                multipleChoiceOptionLabel.translatesAutoresizingMaskIntoConstraints = false
                let optionCount = surveyQuestionResponse.mcResponsesCounts[mcOption] ?? 0
                multipleChoiceOptionLabel.attributedText = NSAttributedString(string: "\(mcOption): \(String(optionCount))", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 22, weight: .semibold), NSAttributedStringKey.foregroundColor : UIColor.green])
                    multipleChoiceOptionLabel.textAlignment = .left
                    stackView.addArrangedSubview(multipleChoiceOptionLabel)
                
            }
            
            let numOptions = surveyQuestionResponse.mcResponsesCounts.keys.count
            stackView.spacing = 10
            stackView.heightAnchor.constraint(equalToConstant: CGFloat(numOptions * MULTIPLECHOICEOPTIONHEIGHT) + (stackView.spacing * CGFloat(numOptions - 1))).isActive = true
            answerView = stackView
            
            
        } else if surveyQuestionResponse.type == "free" {
            
            let textView = UITextView()
            textView.isEditable = false
            var combinedResponses = ""
            for freeResponse in surveyQuestionResponse.freeResponses {
                combinedResponses += "~ " + freeResponse + " \n"
            }
            textView.text = combinedResponses
            textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            textView.layer.cornerRadius = 10
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
        
        DatabaseRequester.getResponseTo(survey: surveyId, callback: { (surveyQuestionResponses) in
            
            DispatchQueue.main.async {
                
                for index in 0..<surveyQuestionResponses.count {
                    
                    let questionView = self.createQuestionView(surveyQuestionResponse: surveyQuestionResponses[index])
                    self.responseViews[surveyQuestionResponses[index]] = questionView
                    questionView.translatesAutoresizingMaskIntoConstraints = false
                    self.scrollContentView.addSubview(questionView)
                    self.scrollContentView.addConstraints([
                        questionView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor, constant: 0),
                        questionView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor, constant: 0)
                        ])
                    
                    if index != 0 {
                        
                        let prevQuestion = surveyQuestionResponses[index - 1]
                        if let prevQuestionView = self.responseViews[prevQuestion] {
                            questionView.topAnchor.constraint(equalTo: prevQuestionView.bottomAnchor, constant: 10).isActive = true
                        }
                        
                    } else {
                        questionView.topAnchor.constraint(equalTo: self.scrollContentView.topAnchor, constant: 10).isActive = true
                    }
                    
                    if index == surveyQuestionResponses.count - 1 {
                        
                        self.scrollContentView.bottomAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 10).isActive = true
                        
                    }
                    
                    
                }
            }
                
            
            
        })
            
        
            
    }
    

}

//
//  SurveyCollectionViewCell.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/19/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class SurveyCollectionViewCell: UICollectionViewCell {
    
    let surveyDetailsView = SurveyDetailsView().loadNib() as! SurveyDetailsView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainSurveyDetailsView()
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constrainSurveyDetailsView()
    }
    
    func constrainSurveyDetailsView() {
        self.contentView.addSubview(surveyDetailsView)
        surveyDetailsView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            surveyDetailsView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            surveyDetailsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            surveyDetailsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            surveyDetailsView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        //Add shadows (Does nothing when clipped to bounds) 
//        self.layer.shadowRadius = 5
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 5, height: 5)
//        self.layer.shadowOpacity = 0.5
    }
    
    func layoutForCourseDetail(survey: Survey) {
        
        surveyDetailsView.headerLabel.text = survey.name
        surveyDetailsView.subtitleLabel1.textColor = survey.availability() ? UIColor.green : UIColor.red
        surveyDetailsView.subtitleLabel1.text = survey.availability() ? "Available" : "Unavailable"
        surveyDetailsView.subtitleLabel2.text = "\(survey.startDateString()) - \(survey.endDateString())"
        
        
    }
    
}

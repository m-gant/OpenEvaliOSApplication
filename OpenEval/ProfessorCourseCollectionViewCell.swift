//
//  ProfessorCourseCollectionViewCell.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/7/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ProfessorCourseCollectionViewCell: UICollectionViewCell {
    
    let courseView = CourseCellView().loadNib() as! CourseCellView
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        constrainCourseView()
        
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constrainCourseView()
    }
    
    func constrainCourseView() {
        self.contentView.addSubview(courseView)
        courseView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            courseView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            courseView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            courseView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            courseView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
            ])
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func layout(courseName: String, courseNumber: String) {
        courseView.configure(courseNumber: courseNumber, courseName: courseName)
    }
    
}

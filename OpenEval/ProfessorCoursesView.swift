//
//  ProfessorCoursesView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/6/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ProfessorCoursesView: NibView {

    
    @IBOutlet weak var coursesCollectionView: UICollectionView!
    
    func configure() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
    coursesCollectionView.setCollectionViewLayout(layout, animated: false)
        
    }
    
}



//
//  SurveyDetailsView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/19/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class SurveyDetailsView: NibView {

    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var subtitleLabel1: UILabel!
    @IBOutlet weak var subtitleLabel2: UILabel!
    
    
    func configure(header: String, subtitle1: String, subtitle2: String) {
        
        headerLabel.text = header
        subtitleLabel1.text = subtitle1
        subtitleLabel2.text = subtitle2
        
    }
    
    
}

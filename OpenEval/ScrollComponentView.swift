//
//  ScrollComponentView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/6/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class ScrollComponentView<T: NibView>: NibView {

    @IBOutlet weak var componentTitleLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    var contentView: T?
    
    func configure(title: String, contentView: T, height: CGFloat) {
        
        self.contentView = contentView
        componentTitleLabel.text = title
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
            contentView.topAnchor.constraint(equalTo: componentTitleLabel.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        contentView.heightAnchor.constraint(equalToConstant: height)
            ])
        self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 15).isActive = true
        separatorView.layer.cornerRadius = separatorView.frame.height / 2
        self.backgroundColor = .clear
    }
    
}

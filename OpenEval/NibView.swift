//
//  NibView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/6/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    var view: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

}

private extension NibView {
    
    func xibSetup() {
        backgroundColor = .clear
        view = loadNib()
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
    }
    
}

extension UIView {
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nameWithGenerics = String(describing: type(of: self))
        let className = nameWithGenerics.components(separatedBy: "<").first!
        let nibName = className
        print(nibName)
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
}

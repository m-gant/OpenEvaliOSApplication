//
//  CollectionComponentView.swift
//  OpenEval
//
//  Created by Mitchell  Gant on 10/12/18.
//  Copyright © 2018 OpenEvalInc. All rights reserved.
//

import UIKit

class CollectionComponentView<T: UICollectionViewCell>: NibView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var containerView: ScrollComponentView<CollectionComponentView>!
    
    func configure(cellType: T.Type, reuseIdentifier: String,  height: CGFloat, title: String) {
        
        let nibName = String(describing: type(of: self)).components(separatedBy: "<").first!
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        containerView = ScrollComponentView().loadNib() as! ScrollComponentView
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.register(T.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .clear
        containerView.configure(title: title, contentView: self, height: height)
        
    }
    

}

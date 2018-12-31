//
//  ShelfCellView.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import UIKit

class ShelfCellView: UICollectionViewCell {
    let shelfBackground = UIImageView()
    let bookBackground = UIView()
    var bookCover = UIImageView()
    let indicator = UIActivityIndicatorView()
    let spine = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(shelfBackground)
        addSubview(bookBackground)
        
        bookBackground.addSubview(bookCover)
        bookBackground.addSubview(spine)
        bookBackground.addSubview(indicator)
        
        bookCover.layer.shadowColor = UIColor.black.cgColor
        bookCover.layer.shadowRadius = 10
        bookCover.layer.shadowOffset = CGSize(width: 0, height: 0)
        bookCover.layer.shadowOpacity = 0.7
        
        indicator.color = .magenta
        spine.image = Utils().loadImage(name: "spine")
        spine.isHidden = true
        shelfBackground.isUserInteractionEnabled = true
        bookCover.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

//
//  ShelfHeaderCellView.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 28/12/2018.
//

import UIKit

class ShelfHeaderCellView: UICollectionReusableView {
    let header = UIImageView()
    let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        header.image = Utils().loadImage(name: "header")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
        header.contentMode = .scaleToFill
        headerLabel.textAlignment = .center
        headerLabel.shadowColor = .brown
        headerLabel.shadowOffset = CGSize(width: 0.0, height: 1.0)
        addSubview(header)
        addSubview(headerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}

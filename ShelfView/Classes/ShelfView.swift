//
//  ShelfView.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

public class ShelfView: UIView,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    
    private let indicatorWidth = Double(50)
    private let bookCoverMargin = Double(10)
    private let spineWidth = CGFloat(8)
    private let bookBackgroundMarignTop = Double(23)
    
    public static let BOOK_SOURCE_DEVICE_DOCUMENTS = 1
    public static let BOOK_SOURCE_DEVICE_LIBRARY = 2
    public static let BOOK_SOURCE_DEVICE_CACHE = 3
    public static let BOOK_SOURCE_URL = 4
    public static let BOOK_SOURCE_RAW = 5
    
    private static let START = "start"
    private static let END = "end"
    private static let CENTER = "center"
    
    private var bookModel = [BookModel]()
    private var shelfModel = [ShelfModel]()
    
    private var bookSource = 0
    private var numberOfTilesPerRow: Int!
    private var shelfHeight: Int!
    private var shelfWidth: Int!
    private let gridItemWidth = Dimens.gridItemWidth
    private let gridItemHeight = Dimens.gridItemHeight
    private var shelfView: UICollectionView!
    private var trueGridItemWidth: Double!
    private let layout = UICollectionViewFlowLayout()
    private let utils = Utils()
    public weak var delegate: ShelfViewDelegate!
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if Int(frame.width) < gridItemWidth {
            fatalError("ShelfView width cannot be less than \(gridItemWidth)")
        }
        initData(bookModel: self.bookModel, width: frame.width, height: frame.height)
    }
    
    
    
    public func loadData (bookModel: [BookModel], bookSource : Int) {
        utils.delay(0){
            self.bookSource = bookSource
            self.processData(bookModel: bookModel)
        }
    }
    
    
    private func initData (bookModel: [BookModel], width: CGFloat, height: CGFloat) {
        
        shelfView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width , height: height), collectionViewLayout: layout)
        shelfView.register(ShelfCellView.self, forCellWithReuseIdentifier: "ShelfCellView")
        shelfView.dataSource = self
        shelfView.delegate =  self
        shelfView.alwaysBounceVertical = false
        shelfView.bounces = false
        addSubview(shelfView)
        
        shelfView.backgroundColor = utils.hexStringToUIColor("#C49E7A")
        
        self.bookModel.removeAll()
        self.bookModel.append(contentsOf: bookModel)
        self.shelfModel.removeAll()
        shelfView.showsVerticalScrollIndicator = false
        shelfView.showsHorizontalScrollIndicator = false
        
        shelfWidth = Int(shelfView.frame.width)
        shelfHeight = Int(shelfView.frame.height)
        numberOfTilesPerRow = shelfWidth / gridItemWidth
        
        trueGridItemWidth = Double(shelfWidth) / Double(numberOfTilesPerRow)
        layout.itemSize = CGSize(width: trueGridItemWidth , height: Double(gridItemHeight))
        shelfView.collectionViewLayout.invalidateLayout()
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let sizeOfModel = bookModel.count
        var numberOfRows = sizeOfModel / numberOfTilesPerRow
        let remainderTiles = sizeOfModel % numberOfTilesPerRow
        
        
        if (remainderTiles > 0) {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for  i in 0 ..< fillUp  {
                if (i == (fillUp - 1)) {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                } else {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                }
            }
        }
        
        if ((numberOfRows * gridItemHeight) < shelfHeight) {
            let remainderRowHeight = (shelfHeight - (numberOfRows * gridItemHeight)) / gridItemHeight
            
            if (remainderRowHeight == 0) {
                for i in 0 ..< numberOfTilesPerRow  {
                    if (i == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if (i == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            } else if (remainderRowHeight > 0) {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if ((i % numberOfTilesPerRow) == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                }
            }
        }
        
        reloadItems()
    }
    
    
    private func processData (bookModel: [BookModel]) {
        
        self.bookModel.removeAll()
        self.bookModel.append(contentsOf: bookModel)
        self.shelfModel.removeAll()
        
        for  i in 0 ..< bookModel.count {
            let bookCoverSource = bookModel[i].bookCoverSource
            let bookId = bookModel[i].bookId
            let bookTitle = bookModel[i].bookTitle
            
            if ((i % numberOfTilesPerRow) == 0) {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.START))
            } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.END))
            } else {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.CENTER))
            }
        }
        
        
        let sizeOfModel = bookModel.count
        var numberOfRows = sizeOfModel / numberOfTilesPerRow
        let remainderTiles = sizeOfModel % numberOfTilesPerRow
        
        if (remainderTiles > 0) {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for i in 0 ..< fillUp {
                if (i == (fillUp - 1)) {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                } else {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                }
            }
        }
        
        if ((numberOfRows * gridItemHeight) < shelfHeight) {
            let remainderRowHeight = (shelfHeight - (numberOfRows * gridItemHeight)) / gridItemHeight
            
            if (remainderRowHeight == 0) {
                for i in 0 ..< numberOfTilesPerRow {
                    if (i == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if (i == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            } else if (remainderRowHeight > 0) {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if ((i % numberOfTilesPerRow) == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            }
        }
        
        reloadItems()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let position = indexPath.row
        let shelfItem = shelfModel[position]
        let bookCover = shelfItem.bookCoverSource.trim()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShelfCellView", for: indexPath) as! ShelfCellView
        cell.shelfBackground.frame = CGRect(x: 0, y: 0, width: trueGridItemWidth, height: Double(gridItemHeight))
        cell.shelfBackground.contentMode = .scaleToFill
        
        switch shelfItem.type {
        case ShelfView.START:
            cell.shelfBackground.image = utils.loadImage(name: "left")
            break
        case ShelfView.END:
            cell.shelfBackground.image = utils.loadImage(name: "right")
            break
        default:
            cell.shelfBackground.image = utils.loadImage(name: "center")
            break
        }
        
        cell.bookCover.kf.indicatorType = .none
        cell.bookBackground.frame = CGRect(x: (trueGridItemWidth - Dimens.bookWidth)/2, y: bookBackgroundMarignTop, width: Dimens.bookWidth, height: Dimens.bookHeight)
        cell.bookCover.frame = CGRect(x: bookCoverMargin/2, y: bookCoverMargin, width: Dimens.bookWidth - bookCoverMargin, height: Dimens.bookHeight - bookCoverMargin)
        cell.indicator.frame = CGRect(x: (Dimens.bookWidth - indicatorWidth)/2, y: (Dimens.bookHeight - indicatorWidth)/2, width: indicatorWidth, height: indicatorWidth)
        cell.indicator.startAnimating()
        
        switch (bookSource) {
        case ShelfView.BOOK_SOURCE_DEVICE_CACHE:
            if shelfItem.show && bookCover != "" {
                let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
                if let dirPath = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(bookCover)
                    let image = UIImage(contentsOfFile: imageURL.path)
                    cell.bookCover.image = image
                    cell.indicator.stopAnimating()
                    cell.spine.isHidden = false
                }
            }
            break
        case ShelfView.BOOK_SOURCE_DEVICE_LIBRARY:
            if shelfItem.show && bookCover != "" {
                let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
                if let dirPath = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(bookCover)
                    let image = UIImage(contentsOfFile: imageURL.path)
                    cell.bookCover.image = image
                    cell.indicator.stopAnimating()
                    cell.spine.isHidden = false
                }
            }
            break
        case ShelfView.BOOK_SOURCE_DEVICE_DOCUMENTS:
            if shelfItem.show && bookCover != "" {
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                if let dirPath = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(bookCover)
                    let image = UIImage(contentsOfFile: imageURL.path)
                    cell.bookCover.image = image
                    cell.indicator.stopAnimating()
                    cell.spine.isHidden = false
                }
            }
            break
        case ShelfView.BOOK_SOURCE_URL:
            if shelfItem.show && bookCover != "" {
                let url = URL(string: bookCover)!
                cell.bookCover.kf.setImage(with: url, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if error == nil {
                        cell.indicator.stopAnimating()
                        cell.spine.isHidden = false
                    }
                })
            }
            break
        case ShelfView.BOOK_SOURCE_RAW:
            if shelfItem.show && bookCover != "" {
                cell.bookCover.image = UIImage(named: bookCover)
                cell.indicator.stopAnimating()
                cell.spine.isHidden = false
            }
            break
        default:
            if shelfItem.show && bookCover != "" {
                let url = URL(string: "https://www.packtpub.com/sites/default/files/cover_1.png")!
                cell.bookCover.kf.setImage(with: url, completionHandler: {
                    (image, error, cacheType, imageUrl) in
                    if error == nil {
                        cell.indicator.stopAnimating()
                        cell.spine.isHidden = false
                    }
                })
            }
            break
        }
        
        cell.bookBackground.isHidden = !shelfItem.show
        cell.spine.frame = CGRect(x: CGFloat(bookCoverMargin)/2, y: CGFloat(bookCoverMargin), width: spineWidth, height: cell.bookCover.frame.height)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shelfModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.row
        if shelfModel[position].show {
            delegate.onBookClicked(self, position: position, bookId: shelfModel[position].bookId, bookTitle: shelfModel[position].bookTitle)
        }
    }
    
    private func reloadItems () {
        shelfView.reloadData()
    }
    
    public func updateData (bookModel: [BookModel]) {
        processData(bookModel: bookModel)
        reloadItems()
    }
    
    
    public func resize(width: CGFloat, height: CGFloat, bookModel: [BookModel]) {
        
        if bookSource == 0 {
            fatalError("You can't resize a shelfView when you've not called loadData (bookModel: [BookModel], bookSource : Int)")
        }
        
        shelfView.frame = CGRect(x: 0, y: 0, width: width , height: height)
        
        self.bookModel.removeAll()
        self.bookModel.append(contentsOf: bookModel)
        self.shelfModel.removeAll()
        
        shelfWidth = Int(shelfView.frame.width)
        shelfHeight = Int(shelfView.frame.height)
        numberOfTilesPerRow = shelfWidth / gridItemWidth
        
        trueGridItemWidth = Double(shelfWidth) / Double(numberOfTilesPerRow)
        layout.itemSize = CGSize(width: trueGridItemWidth, height: Double(gridItemHeight))
        shelfView.collectionViewLayout.invalidateLayout()
        
        var sizeOfModel = bookModel.count
        var numberOfRows = sizeOfModel / numberOfTilesPerRow
        var remainderTiles = sizeOfModel % numberOfTilesPerRow
        
        
        if (remainderTiles > 0) {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for  i in 0 ..< fillUp  {
                if (i == (fillUp - 1)) {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                } else {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                }
            }
        }
        
        if ((numberOfRows * gridItemHeight) < shelfHeight) {
            let remainderRowHeight = (shelfHeight - (numberOfRows * gridItemHeight)) / gridItemHeight
            
            if (remainderRowHeight == 0) {
                for i in 0 ..< numberOfTilesPerRow  {
                    if (i == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if (i == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            } else if (remainderRowHeight > 0) {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if ((i % numberOfTilesPerRow) == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            }
        }
        
        
        self.bookModel.removeAll()
        self.bookModel.append(contentsOf: bookModel)
        self.shelfModel.removeAll()
        
        for  i in 0 ..< bookModel.count {
            let bookCoverSource = bookModel[i].bookCoverSource
            let bookId = bookModel[i].bookId
            let bookTitle = bookModel[i].bookTitle
            
            if ((i % numberOfTilesPerRow) == 0) {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.START))
            } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.END))
            } else {
                self.shelfModel.append(ShelfModel.init(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: ShelfView.CENTER))
            }
        }
        
        
        sizeOfModel = bookModel.count
        numberOfRows = sizeOfModel / numberOfTilesPerRow
        remainderTiles = sizeOfModel % numberOfTilesPerRow
        
        if (remainderTiles > 0) {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for i in 0 ..< fillUp {
                if (i == (fillUp - 1)) {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                } else {
                    self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                }
            }
        }
        
        if ((numberOfRows * gridItemHeight) < shelfHeight) {
            let remainderRowHeight = (shelfHeight - (numberOfRows * gridItemHeight)) / gridItemHeight
            
            if (remainderRowHeight == 0) {
                for i in 0 ..< numberOfTilesPerRow {
                    if (i == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if (i == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            } else if (remainderRowHeight > 0) {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if ((i % numberOfTilesPerRow) == 0) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.START))
                    } else if ((i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1)) {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.END))
                    } else {
                        self.shelfModel.append(ShelfModel.init(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: ShelfView.CENTER))
                    }
                    
                }
            }
        }
        
        reloadItems()
        
    }
}

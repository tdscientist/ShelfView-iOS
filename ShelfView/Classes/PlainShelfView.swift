//
//  PlainShelfView.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Kingfisher
import UIKit

public class PlainShelfView: UIView {
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
    
    private var bookSource = BOOK_SOURCE_URL
    
    private var numberOfTilesPerRow: Int!
    private var shelfHeight: Int!
    private var shelfWidth: Int!
    private let gridItemWidth = Dimens.gridItemWidth
    private let gridItemHeight = Dimens.gridItemHeight
    private var shelfView: UICollectionView!
    private var trueGridItemWidth: Double!
    private let layout = UICollectionViewFlowLayout()
    private let utils = Utils()
    public weak var delegate: PlainShelfViewDelegate!
    private var viewHasBeenInitialized = false
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        if Int(frame.width) < gridItemWidth {
            fatalError("ShelfView width cannot be less than \(gridItemWidth)")
        }
        initializeShelfView(width: frame.width, height: frame.height)
    }
    
    public convenience init(frame: CGRect, bookModel: [BookModel], bookSource: Int) {
        self.init(frame: frame)
        utils.delay(0) {
            self.bookSource = bookSource
            self.bookModel = bookModel
            self.processData()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if viewHasBeenInitialized {
            let width = frame.width
            let height = frame.height
            shelfView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            shelfWidth = Int(shelfView.frame.width)
            shelfHeight = Int(shelfView.frame.height)
            numberOfTilesPerRow = shelfWidth / gridItemWidth
            trueGridItemWidth = Double(shelfWidth) / Double(numberOfTilesPerRow)
            layout.itemSize = CGSize(width: trueGridItemWidth, height: Double(gridItemHeight))
            shelfView.collectionViewLayout.invalidateLayout()
            reloadBooks(bookModel: bookModel)
        }
    }
    
    private func initializeShelfView(width: CGFloat, height: CGFloat) {
        shelfView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        shelfView.register(ShelfCellView.self, forCellWithReuseIdentifier: ShelfCellView.identifier)
        shelfView.dataSource = self
        shelfView.delegate = self
        shelfView.alwaysBounceVertical = false
        shelfView.bounces = false
        shelfView.showsVerticalScrollIndicator = false
        shelfView.showsHorizontalScrollIndicator = false
        shelfView.backgroundColor = UIColor("#C49E7A")
        addSubview(shelfView)
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        shelfWidth = Int(shelfView.frame.width)
        shelfHeight = Int(shelfView.frame.height)
        numberOfTilesPerRow = shelfWidth / gridItemWidth
        trueGridItemWidth = Double(shelfWidth) / Double(numberOfTilesPerRow)
        
        layout.itemSize = CGSize(width: trueGridItemWidth, height: Double(gridItemHeight))
        shelfView.collectionViewLayout.invalidateLayout()
        
        buildShelf(sizeOfModel: 0)
        viewHasBeenInitialized = true
    }
    
    private func loadEmptyShelfBlocks(type: String) {
        shelfModel.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: type))
    }
    
    private func loadFilledShelfBlocks(bookCoverSource: String, bookId: String, bookTitle: String, type: String) {
        shelfModel.append(ShelfModel(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: type))
    }
    
    public func reloadBooks(bookModel: [BookModel]) {
        self.bookModel = bookModel
        processData()
    }
    
    public func addBooks(bookModel: [BookModel]) {
        self.bookModel = self.bookModel + bookModel
        processData()
    }
    
    private func processData() {
        shelfModel.removeAll()
        
        for i in 0 ..< bookModel.count {
            let bookCoverSource = bookModel[i].bookCoverSource
            let bookId = bookModel[i].bookId
            let bookTitle = bookModel[i].bookTitle
            
            if (i % numberOfTilesPerRow) == 0 {
                loadFilledShelfBlocks(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, type: PlainShelfView.START)
            } else if (i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1) {
                loadFilledShelfBlocks(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, type: PlainShelfView.END)
            } else {
                loadFilledShelfBlocks(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, type: PlainShelfView.CENTER)
            }
        }
        
        buildShelf(sizeOfModel: bookModel.count)
    }
    
    private func buildShelf(sizeOfModel: Int) {
        var numberOfRows = sizeOfModel / numberOfTilesPerRow
        let remainderTiles = sizeOfModel % numberOfTilesPerRow
        
        if remainderTiles > 0 {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for i in 0 ..< fillUp {
                if i == (fillUp - 1) {
                    loadEmptyShelfBlocks(type: PlainShelfView.END)
                } else {
                    loadEmptyShelfBlocks(type: PlainShelfView.CENTER)
                }
            }
        }
        
        if (numberOfRows * gridItemHeight) < shelfHeight {
            let remainderRowHeight = (shelfHeight - (numberOfRows * gridItemHeight)) / gridItemHeight
            
            if remainderRowHeight == 0 {
                for i in 0 ..< numberOfTilesPerRow {
                    if i == 0 {
                        loadEmptyShelfBlocks(type: PlainShelfView.START)
                    } else if i == (numberOfTilesPerRow - 1) {
                        loadEmptyShelfBlocks(type: PlainShelfView.END)
                    } else {
                        loadEmptyShelfBlocks(type: PlainShelfView.CENTER)
                    }
                }
            } else if remainderRowHeight > 0 {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if (i % numberOfTilesPerRow) == 0 {
                        loadEmptyShelfBlocks(type: PlainShelfView.START)
                    } else if (i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1) {
                        loadEmptyShelfBlocks(type: PlainShelfView.END)
                    } else {
                        loadEmptyShelfBlocks(type: PlainShelfView.CENTER)
                    }
                }
            }
        }
        
        shelfView.reloadData()
    }
}

extension PlainShelfView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let position = indexPath.row
        let shelfItem = shelfModel[position]
        let bookCover = shelfItem.bookCoverSource.trim()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfCellView.identifier, for: indexPath) as! ShelfCellView
        cell.shelfBackground.frame = CGRect(x: 0, y: 0, width: trueGridItemWidth, height: Double(gridItemHeight))
        cell.shelfBackground.contentMode = .scaleToFill
        
        switch shelfItem.type {
        case PlainShelfView.START:
            cell.shelfBackground.image = utils.loadImage(name: "left")
            break
        case PlainShelfView.END:
            cell.shelfBackground.image = utils.loadImage(name: "right")
            break
        default:
            cell.shelfBackground.image = utils.loadImage(name: "center")
            break
        }
        
        cell.bookCover.kf.indicatorType = .none
        cell.bookBackground.frame = CGRect(x: (trueGridItemWidth - Dimens.bookWidth) / 2, y: bookBackgroundMarignTop, width: Dimens.bookWidth, height: Dimens.bookHeight)
        cell.bookCover.frame = CGRect(x: bookCoverMargin / 2, y: bookCoverMargin, width: Dimens.bookWidth - bookCoverMargin, height: Dimens.bookHeight - bookCoverMargin)
        cell.indicator.frame = CGRect(x: (Dimens.bookWidth - indicatorWidth) / 2, y: (Dimens.bookHeight - indicatorWidth) / 2, width: indicatorWidth, height: indicatorWidth)
        cell.indicator.startAnimating()
        
        switch bookSource {
        case PlainShelfView.BOOK_SOURCE_DEVICE_CACHE:
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
        case PlainShelfView.BOOK_SOURCE_DEVICE_LIBRARY:
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
        case PlainShelfView.BOOK_SOURCE_DEVICE_DOCUMENTS:
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
        case PlainShelfView.BOOK_SOURCE_URL:
            if shelfItem.show && bookCover != "" {
                let url = URL(string: bookCover)!
                cell.bookCover.kf.setImage(with: url) { result in
                    switch result {
                    case .success:
                        cell.indicator.stopAnimating()
                        cell.spine.isHidden = false
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            break
        case PlainShelfView.BOOK_SOURCE_RAW:
            if shelfItem.show && bookCover != "" {
                cell.bookCover.image = UIImage(named: bookCover)
                cell.indicator.stopAnimating()
                cell.spine.isHidden = false
            }
            break
        default:
            if shelfItem.show && bookCover != "" {
                let url = URL(string: "https://www.packtpub.com/sites/default/files/cover_1.png")!
                cell.bookCover.kf.setImage(with: url) { result in
                    switch result {
                    case .success:
                        cell.indicator.stopAnimating()
                        cell.spine.isHidden = false
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
            break
        }
        
        cell.bookBackground.isHidden = !shelfItem.show
        cell.spine.frame = CGRect(x: CGFloat(bookCoverMargin) / 2, y: CGFloat(bookCoverMargin), width: spineWidth, height: cell.bookCover.frame.height)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shelfModel.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let position = indexPath.row
        if shelfModel[position].show {
            delegate.onBookClicked(self, index: position, bookId: shelfModel[position].bookId, bookTitle: shelfModel[position].bookTitle)
        }
    }
}

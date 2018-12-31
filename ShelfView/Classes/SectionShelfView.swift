//
//  SectionShelfView.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 27/12/2018.
//

import Kingfisher
import UIKit

public class SectionShelfView: UIView {
    private let indicatorWidth = Double(50)
    private let bookCoverMargin = Double(10)
    private let spineWidth = CGFloat(8)
    private let bookBackgroundMarignTop = Double(23)
    private let headerReferenceSizeHeight = CGFloat(50)
    
    public static let BOOK_SOURCE_DEVICE_DOCUMENTS = 1
    public static let BOOK_SOURCE_DEVICE_LIBRARY = 2
    public static let BOOK_SOURCE_DEVICE_CACHE = 3
    public static let BOOK_SOURCE_URL = 4
    public static let BOOK_SOURCE_RAW = 5
    
    private static let START = "start"
    private static let END = "end"
    private static let CENTER = "center"
    
    private var bookModelSection = [BookModelSection]()
    private var shelfModelSection = [ShelfModelSection]()
    
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
    public weak var delegate: SectionShelfViewDelegate!
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
    
    public convenience init(frame: CGRect, bookModelSection: [BookModelSection], bookSource: Int) {
        self.init(frame: frame)
        utils.delay(0) {
            self.bookSource = bookSource
            self.bookModelSection = bookModelSection
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
            layout.headerReferenceSize = CGSize(width: shelfView.frame.width, height: headerReferenceSizeHeight)
            shelfView.collectionViewLayout.invalidateLayout()
            reloadBooks(bookModelSection: bookModelSection)
        }
    }
    
    private func initializeShelfView(width: CGFloat, height: CGFloat) {
        shelfView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout)
        shelfView.register(ShelfCellView.self, forCellWithReuseIdentifier: ShelfCellView.identifier)
        shelfView.register(ShelfHeaderCellView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShelfHeaderCellView.identifier)
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
        layout.headerReferenceSize = CGSize(width: shelfView.frame.width, height: headerReferenceSizeHeight)
        shelfView.collectionViewLayout.invalidateLayout()
        
        buildSingleSectionShelf(sizeOfModel: 0)
        viewHasBeenInitialized = true
    }
    
    public func reloadBooks(bookModelSection: [BookModelSection]) {
        self.bookModelSection = bookModelSection
        processData()
    }
    
    public func addBooks(bookModelSection: [BookModelSection]) {
        self.bookModelSection = self.bookModelSection + bookModelSection
        processData()
    }
    
    private func processData() {
        shelfModelSection.removeAll()
        var cummulativeShelfHeight = 0
        
        for i in 0 ..< bookModelSection.count {
            let sectionItem = bookModelSection[i]
            let sectionName = sectionItem.sectionName
            let sectionId = sectionItem.sectionId
            let sectionBooks = sectionItem.sectionBooks
            let sectionBooksCount = sectionBooks.count
            var shelfModelArray = [ShelfModel]()
            
            for j in 0 ..< sectionBooksCount {
                let bookCoverSource = sectionBooks[j].bookCoverSource
                let bookId = sectionBooks[j].bookId
                let bookTitle = sectionBooks[j].bookTitle
                
                if (j % numberOfTilesPerRow) == 0 {
                    shelfModelArray.append(ShelfModel(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: SectionShelfView.START))
                } else if (j % numberOfTilesPerRow) == (numberOfTilesPerRow - 1) {
                    shelfModelArray.append(ShelfModel(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: SectionShelfView.END))
                } else {
                    shelfModelArray.append(ShelfModel(bookCoverSource: bookCoverSource, bookId: bookId, bookTitle: bookTitle, show: true, type: SectionShelfView.CENTER))
                }
                
                if j == (sectionBooksCount - 1) {
                    var numberOfRows = sectionBooksCount / numberOfTilesPerRow
                    let remainderTiles = sectionBooksCount % numberOfTilesPerRow
                    
                    if remainderTiles > 0 {
                        numberOfRows = numberOfRows + 1
                        let fillUp = numberOfTilesPerRow - remainderTiles
                        for i in 0 ..< fillUp {
                            if i == (fillUp - 1) {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                            } else {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                            }
                        }
                    }
                    cummulativeShelfHeight += (numberOfRows * gridItemHeight) + Int(headerReferenceSizeHeight)
                }
            }
            
            if i == (bookModelSection.count - 1) {
                if cummulativeShelfHeight < shelfHeight {
                    let remainderRowHeight = (shelfHeight - cummulativeShelfHeight) / gridItemHeight
                    
                    if remainderRowHeight == 0 {
                        for i in 0 ..< numberOfTilesPerRow {
                            if i == 0 {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.START))
                            } else if i == (numberOfTilesPerRow - 1) {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                            } else {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                            }
                        }
                    } else if remainderRowHeight > 0 {
                        let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                        for i in 0 ..< fillUp {
                            if (i % numberOfTilesPerRow) == 0 {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.START))
                            } else if (i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1) {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                            } else {
                                shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                            }
                        }
                    }
                }
            }
            
            shelfModelSection.append(ShelfModelSection(sectionName: sectionName, sectionId: sectionId, sectionShelf: shelfModelArray))
        }
        
        shelfView.reloadData()
    }
    
    private func buildSingleSectionShelf(sizeOfModel: Int) {
        var numberOfRows = sizeOfModel / numberOfTilesPerRow
        let remainderTiles = sizeOfModel % numberOfTilesPerRow
        var shelfModelArray = [ShelfModel]()
        
        if remainderTiles > 0 {
            numberOfRows = numberOfRows + 1
            let fillUp = numberOfTilesPerRow - remainderTiles
            for i in 0 ..< fillUp {
                if i == (fillUp - 1) {
                    shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                } else {
                    shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                }
            }
        }
        
        if ((numberOfRows * gridItemHeight) + Int(headerReferenceSizeHeight)) < shelfHeight {
            let remainderRowHeight = (shelfHeight - ((numberOfRows * gridItemHeight) + Int(headerReferenceSizeHeight))) / gridItemHeight
            
            if remainderRowHeight == 0 {
                for i in 0 ..< numberOfTilesPerRow {
                    if i == 0 {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.START))
                    } else if i == (numberOfTilesPerRow - 1) {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                    } else {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                    }
                }
            } else if remainderRowHeight > 0 {
                let fillUp = numberOfTilesPerRow * (remainderRowHeight + 1)
                for i in 0 ..< fillUp {
                    if (i % numberOfTilesPerRow) == 0 {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.START))
                    } else if (i % numberOfTilesPerRow) == (numberOfTilesPerRow - 1) {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.END))
                    } else {
                        shelfModelArray.append(ShelfModel(bookCoverSource: "", bookId: "", bookTitle: "", show: false, type: SectionShelfView.CENTER))
                    }
                }
            }
        }
        
        shelfModelSection.append(ShelfModelSection(sectionName: "", sectionId: "", sectionShelf: shelfModelArray))
        shelfView.reloadData()
    }
}

extension SectionShelfView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let position = indexPath.row
        let shelfItem = shelfModelSection[section].sectionShelf[position]
        let bookCover = shelfItem.bookCoverSource.trim()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShelfCellView.identifier, for: indexPath) as! ShelfCellView
        cell.shelfBackground.frame = CGRect(x: 0, y: 0, width: trueGridItemWidth, height: Double(gridItemHeight))
        cell.shelfBackground.contentMode = .scaleToFill
        
        switch shelfItem.type {
        case SectionShelfView.START:
            cell.shelfBackground.image = utils.loadImage(name: "left")
            break
        case SectionShelfView.END:
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
        case SectionShelfView.BOOK_SOURCE_DEVICE_CACHE:
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
        case SectionShelfView.BOOK_SOURCE_DEVICE_LIBRARY:
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
        case SectionShelfView.BOOK_SOURCE_DEVICE_DOCUMENTS:
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
        case SectionShelfView.BOOK_SOURCE_URL:
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
        case SectionShelfView.BOOK_SOURCE_RAW:
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
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ShelfHeaderCellView.identifier, for: indexPath) as! ShelfHeaderCellView
            
            reusableView.header.frame = CGRect(x: 0, y: 0, width: reusableView.frame.width, height: reusableView.frame.height)
            reusableView.headerLabel.frame = CGRect(x: 0, y: 0, width: reusableView.frame.width, height: reusableView.frame.height)
            reusableView.headerLabel.text = shelfModelSection[indexPath.section].sectionName
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return shelfModelSection.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shelfModelSection[section].sectionShelf.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let position = indexPath.row
        let sectionItem = shelfModelSection[section]
        let shelfItem = sectionItem.sectionShelf[position]
        if shelfItem.show {
            delegate.onBookClicked(self, section: section, index: position, sectionId: sectionItem.sectionId, sectionTitle: sectionItem.sectionName, bookId: shelfItem.bookId, bookTitle: shelfItem.bookTitle)
        }
    }
}

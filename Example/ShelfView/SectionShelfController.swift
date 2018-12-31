//
//  SectionShelfController.swift
//  ShelfView_Example
//
//  Created by Adeyinka Adediji on 26/12/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import ShelfView

class SectionShelfController: UIViewController, SectionShelfViewDelegate {
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var shelfView: SectionShelfView!
    @IBOutlet var motherView: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shelfView.translatesAutoresizingMaskIntoConstraints = false
        shelfView.leftAnchor.constraint(equalTo: motherView.leftAnchor, constant: 0).isActive = true
        shelfView.rightAnchor.constraint(equalTo: motherView.rightAnchor, constant: 0).isActive = true
        shelfView.topAnchor.constraint(equalTo: motherView.topAnchor, constant: 0).isActive = true
        shelfView.bottomAnchor.constraint(equalTo: motherView.bottomAnchor, constant: 0).isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let books = [
            BookModel(bookCoverSource: "https://files.kerching.raywenderlich.com/covers/d5693015-46b6-44f8-bf7b-7a222b28d9fe.png", bookId: "0", bookTitle: "Realm: Building Modern Swift Apps with Realm"),
            BookModel(bookCoverSource: "https://images-na.ssl-images-amazon.com/images/I/51R5htMRGTL._SX258_BO1,204,203,200_.jpg", bookId: "1", bookTitle: "iOS Animations by Tutorials Third Edition: iOS 10 and Swift 3 edition"),
            BookModel(bookCoverSource: "https://images-na.ssl-images-amazon.com/images/I/511HN-qmrWL._SX258_BO1,204,203,200_.jpg", bookId: "2", bookTitle: "RxSwift: Reactive Programming with Swift"),
            BookModel(bookCoverSource: "https://images-na.ssl-images-amazon.com/images/I/51%2Bc7iUzcsL._SX258_BO1,204,203,200_.jpg", bookId: "3", bookTitle: "iOS Games by Tutorials"),
            BookModel(bookCoverSource: "https://images-na.ssl-images-amazon.com/images/I/518idGjJQiL._SX404_BO1,204,203,200_.jpg", bookId: "4", bookTitle: "Advanced Apple Debugging & Reverse Engineering Second Edition: Exploring Apple code through LLDB, Python and DTrace 2nd Edition"),
            BookModel(bookCoverSource: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGjc98oOw7zHh2Twgj0QB84bq4y0uYEm8NVq3JlWXwEsxET4Tc", bookId: "5", bookTitle: "Data Structures and Algorithms in Swift"),
            BookModel(bookCoverSource: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYEkCQ_wu8HoGJzzs_gUH_FVusgI2RhntBKQ-WkmqnDJZnriwY6Q", bookId: "6", bookTitle: "iOS 10 by Tutorials: Learning the new iOS APIs with Swift 3")
        ]
        let bookModelSectionArray = [BookModelSection(sectionName: "RAYWENDERLICH", sectionId: "0", sectionBooks: books)]

        shelfView = SectionShelfView(frame: CGRect(x: 0, y: statusBarHeight, width: 350, height: 500), bookModelSection: bookModelSectionArray, bookSource: SectionShelfView.BOOK_SOURCE_URL)

        delay(3) {
            let books = [
                BookModel(bookCoverSource: "https://www.packtpub.com/sites/default/files/cover_1.png", bookId: "7", bookTitle: "Swift iOS Programming for Kids"),
                BookModel(bookCoverSource: "https://www.oreilly.com/library/view/learn-ios-11/9781788390750/assets/d8e98fbc-9bdf-4d9a-ade9-e15e0b3d3265.png", bookId: "8", bookTitle: "Mastering Swift 4"),
                BookModel(bookCoverSource: "https://www.packtpub.com/sites/default/files/9781785288197.png", bookId: "9", bookTitle: "Learning iOS UI Development"),
                BookModel(bookCoverSource: "https://d1ldz4te4covpm.cloudfront.net/sites/default/files/imagecache/featured_book_block/9781784399801.png", bookId: "10", bookTitle: "Learning Unity iOS Game Development"),
                BookModel(bookCoverSource: "https://www.safaribooksonline.com/library/cover/9781788475709/360h/", bookId: "11", bookTitle: "Test-Driven iOS Development with Swift 4 - Third Edition [Book]"),
                BookModel(bookCoverSource: "https://www.packtpub.com/sites/default/files/B04036_iOS%20Game%20Development%20Essentials_.jpg", bookId: "12", bookTitle: "iOS 9 Game Development Essentials"),
                BookModel(bookCoverSource: "https://www.packtpub.com/sites/default/files/B05768.png", bookId: "13", bookTitle: "Swift 4 Programming Cookbook"),
                BookModel(bookCoverSource: "https://www.packtpub.com/sites/default/files/9781785886386.png", bookId: "14", bookTitle: "Apple Pay Essentials")
            ]
            let bookModelSection = [BookModelSection(sectionName: "PACKT", sectionId: "1", sectionBooks: books)]
            self.shelfView.addBooks(bookModelSection: bookModelSection)
        }

        shelfView.delegate = self
        motherView.addSubview(shelfView)
    }

    func onBookClicked(_ shelfView: SectionShelfView, section: Int, index: Int, sectionId: String, sectionTitle: String, bookId: String, bookTitle: String) {
        print("I just clicked \"\(bookTitle)\" with bookId \(bookId), at index \(index). Section details --> section \(section), sectionId \(sectionId), sectionTitle \(sectionTitle)")
    }

    func delay(_ delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
}

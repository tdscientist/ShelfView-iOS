//
//  BookModel.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation

public struct BookModel {
    var bookCoverSource: String
    var bookId: String
    var bookTitle: String

    public init(bookCoverSource: String, bookId: String, bookTitle: String) {
        self.bookCoverSource = bookCoverSource
        self.bookId = bookId
        self.bookTitle = bookTitle
        if bookCoverSource.isEmpty {
            fatalError("bookCoverSource must not be empty")
        }
        if bookId.isEmpty {
            fatalError("bookId must not be empty")
        }
        if bookTitle.isEmpty {
            fatalError("bookTitle must not be empty")
        }
    }
}

public struct BookModelSection {
    var sectionName: String
    var sectionId: String
    var sectionBooks: [BookModel]

    public init(sectionName: String, sectionId: String, sectionBooks: [BookModel]) {
        self.sectionName = sectionName
        self.sectionId = sectionId
        self.sectionBooks = sectionBooks
    }
}

struct ShelfModel {
    var bookCoverSource: String
    var bookId: String
    var bookTitle: String
    var show: Bool
    var type: String

    public init(bookCoverSource: String, bookId: String, bookTitle: String, show: Bool, type: String) {
        self.bookCoverSource = bookCoverSource
        self.bookId = bookId
        self.bookTitle = bookTitle
        self.show = show
        self.type = type
    }
}

struct ShelfModelSection {
    var sectionName: String
    var sectionId: String
    var sectionShelf: [ShelfModel]

    public init(sectionName: String, sectionId: String, sectionShelf: [ShelfModel]) {
        self.sectionName = sectionName
        self.sectionId = sectionId
        self.sectionShelf = sectionShelf
    }
}

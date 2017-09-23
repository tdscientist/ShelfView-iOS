//
//  BookModel.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation

public class BookModel {
    
    private var _bookCoverSource: String!
    private var _bookId: String!
    private var _bookTitle: String!
    
    public var bookCoverSource: String {
        get {
            return self._bookCoverSource
        } set {
            self._bookCoverSource = newValue
        }
    }
    
    public var bookId : String {
        get {
            return self._bookId
        } set {
            self._bookId = newValue
        }
    }
    
    public var bookTitle : String {
        get {
            return self._bookTitle
        } set {
            self._bookTitle = newValue
        }
    }
    
    public init(bookCoverSource: String, bookId: String, bookTitle: String) {
        self._bookCoverSource = bookCoverSource
        self._bookId = bookId
        self._bookTitle = bookTitle
        if bookCoverSource.isEmpty || bookId.isEmpty || bookTitle.isEmpty {
            fatalError("bookCoverSource/bookId/bookTitle must not be empty")
        }
    }
    
}

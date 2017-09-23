//
//  ShelfModel.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 11/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation

class ShelfModel {
    
    private var _bookCoverSource: String!
    private var _bookId: String!
    private var _bookTitle: String!
    private var _show: Bool!
    private var _type: String!
    
    var bookCoverSource: String {
        get {
            return self._bookCoverSource
        } set {
            self._bookCoverSource = newValue
        }
    }
    
    var bookId : String {
        get {
            return self._bookId
        } set {
            self._bookId = newValue
        }
    }
    
    var bookTitle : String {
        get {
            return self._bookTitle
        } set {
            self._bookTitle = newValue
        }
    }
    
    var show : Bool {
        get {
            return self._show
        } set {
            self._show = newValue
        }
    }
    
    var type : String {
        get {
            return self._type
        } set {
            self._type = newValue
        }
    }
    
    init(bookCoverSource: String, bookId: String, bookTitle: String, show: Bool, type: String) {
        self._bookCoverSource = bookCoverSource
        self._bookId = bookId
        self._bookTitle = bookTitle
        self._show = show
        self._type = type
    }
    
}

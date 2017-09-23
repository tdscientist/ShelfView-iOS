//
//  ShelfViewDelegate.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 14/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation

public protocol ShelfViewDelegate: class {
    func  onBookClicked(_ shelfView: ShelfView, position: Int, bookId: String, bookTitle: String)
}

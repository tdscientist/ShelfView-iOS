//
//  ShelfViewDelegate.swift
//  ShelfView
//
//  Created by Adeyinka Adediji on 14/09/2017.
//  Copyright © 2017 Adeyinka Adediji. All rights reserved.
//

import Foundation

public protocol PlainShelfViewDelegate: class {
    func onBookClicked(_ shelfView: PlainShelfView, index: Int, bookId: String, bookTitle: String)
}

public protocol SectionShelfViewDelegate: class {
    func onBookClicked(_ shelfView: SectionShelfView, section: Int, index: Int, sectionId: String, sectionTitle: String, bookId: String, bookTitle: String)
}

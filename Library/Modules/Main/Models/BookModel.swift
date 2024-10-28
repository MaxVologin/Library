//
//  BookModel.swift
//  Library
//
//  Created by Maxim on 22.10.2024.
//

import Foundation

struct BookModel: Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
    var author: String = ""
    var date: String = ""
}

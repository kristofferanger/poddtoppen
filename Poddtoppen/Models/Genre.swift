//
//  Genre.swift
//  iOSTechTask
//
//  Created by Kristoffer Anger on 2023-07-04.
//

import Foundation

/*
 {"id": 144, "name": "Personal Finance", "parent_id": 67},
 */

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct GenreResult: Codable {
    let genres: [Genre]
}

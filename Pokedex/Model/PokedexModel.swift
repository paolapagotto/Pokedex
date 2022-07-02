//
//  PokedexModel.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation

struct PokedexModel {
    var count: Int
    var next: String
    var previous: String
    var results: Int
    
    
    // use of this init to return empty values
    init() {
        self.count = 0
        self.next = ""
        self.previous = ""
        self.results = 0
    }
}

extension PokedexModel {
    init (count: Int, next: String, previous: String, results: Int) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

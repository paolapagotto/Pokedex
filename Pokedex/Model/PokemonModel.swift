//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation

struct PokemonModel {
    
    var id: Int
    var name: String
    var urlImage: String
    
    var weight: Int
    var height: Int
    
    var type: [String]
}

extension PokemonModel {
    
    // use of this init to return empty values
    init() {
        self.id = 0
        self.name = ""
        self.urlImage = ""
        
        self.weight = 0
        self.height = 0
        self.type = []
        
    }
}

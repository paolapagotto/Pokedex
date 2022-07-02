//
//  ParsePokedex.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation

typealias ParseReponseDict = [String: Any]?
typealias PokemonSpriteDict = [String: Any]

class ParsePokedex {
    
    func parsePokedex(response: ParseReponseDict) -> PokedexModel {
        
        guard let response = response else { return PokedexModel() }
        
        let count = response["count"] as? Int ?? 0
        let next = response["next"] as? String ?? ""
        let previous = response["previous"] as? String ?? ""
        let resultList = response["results"] as? [ParseReponseDict] ?? []
        let results = resultList.count
        
        let responseModel = PokedexModel(count: count,
                                         next: next,
                                         previous: previous,
                                         results: results)
        
        return responseModel
    }
    
    func parsePokemon(response: ParseReponseDict) -> PokemonModel {
        
        guard let response = response else { return PokemonModel() }
        
        let id = response["id"] as? Int ?? 0
        let name = response["name"] as? String ?? ""
        var urlImage: String = ""
        if let sprites = response["sprites"] as? PokemonSpriteDict {
            urlImage = sprites["front_default"] as? String ?? ""
        }
        let height = response["height"] as? Int ?? 0
        let weight = response["weight"] as? Int ?? 0
        
        return PokemonModel(id: id, name: name, urlImage: urlImage,
                            weight: weight, height: height, type: [])
    }
}

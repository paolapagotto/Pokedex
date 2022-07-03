//
//  ParsePokedex.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import CoreData

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
        let pokemon = Pokemon(context: self.container.viewContext)
        
        let id = response["id"] as? Int ?? 0
        let name = response["name"] as? String ?? ""
        var urlImage: String = ""
        if let sprites = response["sprites"] as? PokemonSpriteDict {
            urlImage = sprites["front_default"] as? String ?? ""
        }
        let height = response["height"] as? Int ?? 0
        let weight = response["weight"] as? Int ?? 0
        
        var type: PokemonType = .unknown
        if let types = (response["types"] as AnyObject)[0] as? [String: Any] {
            let typeString = ((types["type"] as AnyObject)["name"] as? String ?? "")
            type = PokemonType(rawValue: typeString) ?? .unknown
        }
        
        var attack: Int = 0
        if let attacks = (response["stats"] as AnyObject)[1] as? [String: Any] {
            attack = attacks["base_stat"] as? Int ?? 0
        }
        
        var defense: Int = 0
        if let defenses = (response["stats"] as AnyObject)[2] as? [String: Any] {
            defense = defenses["base_stat"] as? Int ?? 0
        }
        
        var specialAttack: Int = 0
        if let specials = (response["stats"] as AnyObject)[3] as? [String: Any] {
            specialAttack = specials["base_stat"] as? Int ?? 0
        }
        
        
        
        
        return PokemonModel(id: id, name: name, urlImage: urlImage,
                            weight: weight, height: height, type: type,
                            attack: attack, defense: defense,
                            specialAttack: specialAttack)
    }
}

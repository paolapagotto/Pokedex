//
//  PokemonType.swift
//  Pokedex
//
//  Created by Paola Pagotto on 02/07/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import UIKit

enum PokemonType: String {
    
    case normal = "normal"
    case fighting = "fighting"
    case flying = "flying"
    case poison = "poison"
    case ground = "ground"
    case rock = "rock"
    case bug = "bug"
    case ghost = "ghost"
    case steel = "steel"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
    case dark = "dark"
    case fairy = "fairy"
    case unknown = "unknown"
    case shadow = "shadow"
    
    func getPokemonTypeColor() -> UIColor {
        switch self {
        case .water:
            return UIColor.blue
        case .normal:
            return UIColor.lightGray
        case .fighting:
            return UIColor.red
        case .flying:
            return UIColor.cyan
        case .poison:
            return UIColor.purple
        case .ground:
            return UIColor.brown
        case .rock:
            return UIColor.darkGray
        case .bug:
            return UIColor.init(red: 0.0, green: 0.8, blue: 0.4, alpha: 1)
        case .ghost:
            return UIColor.magenta
        case .steel:
            return UIColor.lightGray
        case .fire:
            return UIColor.orange
        case .grass:
            return UIColor.init(red: 0.0, green: 0.8, blue: 0.8, alpha: 1)
        case .electric:
            return UIColor.init(red: 0.9, green: 0.9, blue: 0.0, alpha: 1)
        case .psychic:
            return UIColor.init(red: 0.7, green: 0.7, blue: 0.0, alpha: 1)
        case .ice:
            return UIColor.blue
        case .dragon:
            return UIColor.init(red: 0.9, green: 0.6, blue: 0.0, alpha: 1)
        case .dark:
            return UIColor.black
        case .fairy:
            return UIColor.init(red: 0.6, green: 0.0, blue: 0.5, alpha: 1)
        case .unknown:
            return UIColor.lightGray
        case .shadow:
            return UIColor.init(red: 0.8, green: 0.0, blue: 0.8, alpha: 1)
        }
    }
    
}



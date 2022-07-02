//
//  PokedexResponse.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation

enum PokedexResponse {
    case success(model: PokedexModel)
    case serverError(message: ServerErrorModel)
    case timeout(message: ServerErrorModel)
    case noConnection(message: ServerErrorModel)
}

enum PokemonResponse {
    case success(model: PokemonModel)
    case serverError(message: ServerErrorModel)
    case timeout(message: ServerErrorModel)
    case noConnection(message: ServerErrorModel)
}

enum ImageResponse {
    case success(model: Data)
    case serverError(message: ServerErrorModel)
    case timeout(message: ServerErrorModel)
    case noConnection(message: ServerErrorModel)
}

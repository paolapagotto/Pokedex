//
//  PokedexRequest.swift
//  Pokedex
//
//  Created by Paola Pagotto on 25/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

enum StatusCode: Int {
    case success = 200
    case serverError = 404
    case timeout = -1001
    case noConnection = -1009
}

struct PokemonAPIUrl {
    static let main: String = "http://pokeapi.co/api/v2/pokemon/"
}

class PokedexRequest {
    
    var container: NSPersistentContainer!
    
    let alamofireManager: SessionManager = {
        let timeIntervalRange: TimeInterval = 10000
        let config = URLSessionConfiguration.default
        
        config.timeoutIntervalForRequest = timeIntervalRange
        config.timeoutIntervalForResource = timeIntervalRange
        
        return SessionManager(configuration: config)
    }()
    
    let parse: ParsePokedex = ParsePokedex()
    
    
    func gottaCatchEmAll(url: String?, completion: @escaping (_ response: PokedexResponse) -> Void) {
        
        let page = url == "" || url == nil ? PokemonAPIUrl.main : url ?? ""
        
        alamofireManager.request(page, method: .get,
                                 parameters: nil,
                                 encoding: JSONEncoding.default).responseJSON { (response) in
            
            let status = response.response?.statusCode
            
            switch response.result {
            
            case .success(let data):
                let responseData = data as? [String: Any]
                if status == StatusCode.serverError.rawValue {
                    if let message = responseData?["detail"] as? String {
                        let error = ServerErrorModel(errorMessage: message,
                                                     statusCode: status ?? 0)
                        completion(.serverError(message: error))
                    }
                } else if status == StatusCode.success.rawValue {
                    let model = self.parse.parsePokedex(response: responseData)
                    completion(.success(model: model))
                }
                
            case .failure(let error):
                let errorCode = error._code
                if errorCode == StatusCode.noConnection.rawValue {
                    let error = ServerErrorModel(errorMessage: error.localizedDescription,
                                                 statusCode: errorCode)
                    completion(.noConnection(message: error))
                } else if errorCode == StatusCode.timeout.rawValue {
                    let error = ServerErrorModel(errorMessage: error.localizedDescription,
                                                 statusCode: errorCode)
                    completion(.timeout(message: error))
                }
            }
        }
    }
    
    func catchPokemon(id: Int, completion: @escaping (_ response: PokemonResponse) -> Void) {
        
        let url = "\(PokemonAPIUrl.main)\(id)"
        let pokemon = Pokemon(context: self.container.viewContext)
        
        alamofireManager.request(url, method: .get,
                                 parameters: nil,
                                 encoding: JSONEncoding.default).responseJSON { (response) in
            
            let status = response.response?.statusCode
            
            switch response.result {
            case .success(let data):
                let responseData = data as? [String: Any]
                if status == StatusCode.serverError.rawValue {
                    if let message = responseData?["detail"] as? String {
                        let error = ServerErrorModel(errorMessage: message,
                                                     statusCode: status ?? 0)
                        completion(.serverError(message: error))
                    }
                } else if status == StatusCode.success.rawValue {
                    let model = self.parse.parsePokemon(response: responseData)
                    
                    // Save data into CoreData
                    pokemon.id = Int32(model.id)
                    pokemon.name = model.name
                    pokemon.type = model.type.rawValue
                    pokemon.attack = Int32(model.attack)
                    pokemon.defense = Int32(model.defense)
                    pokemon.specialAttack = Int32(model.specialAttack)
                    pokemon.weight = Int32(model.weight)
                    pokemon.height = Int32(model.height)
                    pokemon.imageUrl = model.urlImage
                    
                    completion(.success(model: model))
                }
                
            case .failure(let error):
                let errorCode = error._code
                if errorCode == StatusCode.noConnection.rawValue {
                    let error = ServerErrorModel(errorMessage: error.localizedDescription,
                                                 statusCode: errorCode)
                    completion(.noConnection(message: error))
                } else if errorCode == StatusCode.timeout.rawValue {
                    let error = ServerErrorModel(errorMessage: error.localizedDescription,
                                                 statusCode: errorCode)
                    completion(.timeout(message: error))
                }
            }
        }
    }
    
    func getPokemonImage(url: String, completion: @escaping (_ response: ImageResponse) -> Void) {
        
        alamofireManager.request(url, method: .get).responseData { (response) in
                                    
            if response.response?.statusCode == StatusCode.success.rawValue {
                guard let data = response.data else {
                    let error = ServerErrorModel(errorMessage: "Image download failure",
                                                 statusCode: StatusCode.serverError.rawValue)
                    completion(.serverError(message: error))
                    return
                }
                
                completion(.success(model: data))
            
            } else {
                let error = ServerErrorModel(errorMessage: "Image download failure",
                                             statusCode: StatusCode.serverError.rawValue)
                completion(.serverError(message: error))
            }
        }
    }
    
}

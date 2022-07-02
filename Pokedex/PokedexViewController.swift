//
//  PokedexViewController.swift
//  Pokedex
//
//  Created by Paola Pagotto on 26/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import UIKit

class PokedexViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var pokedexCollectionView: UICollectionView!
    @IBOutlet weak var pokedexSearchBar: UISearchBar!
    
    var request = PokedexRequest()
    var responseModel: PokedexModel?
    var resultCounter = 0
    var pokemonList = [PokemonModel]()
    var pokemonImages = [Data]()
    var lastId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        self.loadPokedexData(url: PokemonAPIUrl.main)
//        self.setupCollectionView()

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.title = "Pokedex"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadPokedexData(url: PokemonAPIUrl.main)
        self.setupCollectionView()
    }
    
    // Mark: Methods
    
    private func loadPokedexData(url: String?) {
        
        request.gottaCatchEmAll(url: url) { (response) in
            
            switch response {
            case .success(let model):
                print("X GOTTA CATCH'EM ALL \(model) \n")
                
                DispatchQueue.main.async {
                    self.responseModel = model
                    
                    self.loadPokemonData(id: self.resultCounter+1)
                    self.resultCounter += model.results
                }
                
            case .serverError(let message):
                print("ServerError \(message)")
            case .noConnection(let message):
                print("No connection \(message)")
            case .timeout(let message):
                print("Timeout \(message)")
            }
        }
    }
    
    private func loadPokemonData(id: Int) {
        
        request.catchPokemon(id: id) {(response) in
            
            switch response {
            case .success(let model):
                print("Y CATCH A POKEMON \(model) \n")
                
                DispatchQueue.main.async {
                    if model.id == (self.lastId + 1) {
                        self.lastId = model.id
                        self.pokemonList.append(model)
                        self.loadImageData(url: model.urlImage)
                    }
                }
                
            case .serverError(let message):
                print("ServerError \(message)")
            case .noConnection(let message):
                print("No connection \(message)")
            case .timeout(let message):
                print("Timeout \(message)")
            }
        }
    }
    
    private func loadImageData(url: String) {
        
        request.getPokemonImage(url: url) { (response) in
            
            switch response {
            case .success(let model):
                print("Z POKEMON IMAGE \(model)")
                
                DispatchQueue.main.async {
                    self.pokemonImages.append(model)
                }
                let isToLoadNext: Bool = self.pokemonList.last!.id < self.resultCounter
                
                isToLoadNext ? self.loadPokemonData(id: self.pokemonList.last!.id + 1) :
                    self.pokedexCollectionView.reloadData()

            case .serverError(let message):
                print("ServerError \(message)")
            case .noConnection(let message):
                print("No connection \(message)")
            case .timeout(let message):
                print("Timeout \(message)")
            }
        }
    }
}

// MARK: Collection View Delegate and Data Source
extension PokedexViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func setupCollectionView() {
        
        self.pokedexCollectionView.delegate = self
        self.pokedexCollectionView.dataSource = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return responseModel?.next == "" ? resultCounter : resultCounter + 1
    }
    
    // Load more results from pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == resultCounter {
            loadPokedexData(url: responseModel?.next)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCollectionViewCell",
                                                         for: indexPath) as? PokemonCollectionViewCell {
            if indexPath.row != resultCounter {
                cell.configCell(withModel: pokemonList[indexPath.row],
                                spriteData: pokemonImages[indexPath.row])
            }
            return cell
                
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    // TODO: Action after clicking 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 124, height: 164)
    }
}

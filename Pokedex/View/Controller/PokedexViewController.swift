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
    
    // Mark: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pokedexCollectionView: UICollectionView!
    
    // Mark: Properties
    var request = PokedexRequest()
    var responseModel: PokedexModel?
    
    var pokemonList = [PokemonModel]()
    var pokemonImages = [Data]()
    
    var resultCounter = 0
    var lastId = 0
    
    // Mark: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.startLoading()
        self.loadPokedexData(url: PokemonAPIUrl.main)
        self.setupCollectionView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pokemonDetailViewController" {
            if let destination = segue.destination as? PokemonDetailViewController {
                destination.pokemon = sender as? PokemonModel
            }
        }
    }
    
    // Mark: Helper Methods
    private func startLoading() {
        self.view.bringSubviewToFront(self.activityIndicator)
        self.pokedexCollectionView.alpha = 0.4
        self.activityIndicator.startAnimating()
    }
    
    private func stopLoading() {
        self.activityIndicator.stopAnimating()
        self.pokedexCollectionView.alpha = 1
        self.pokedexCollectionView.isHidden = false
    }
    
    // Mark: Fetch Data
    private func loadPokedexData(url: String?) {
        
        request.gottaCatchEmAll(url: url) { (response) in
            
            switch response {
            case .success(let model):
                
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
                
                DispatchQueue.main.async {
                    self.pokemonImages.append(model)
                }
                
                let isToLoadNext: Bool = self.pokemonList.last!.id < self.resultCounter
                
                isToLoadNext ? self.startLoading() : self.stopLoading()
                
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
    
    private func setupCollectionView() {
        
        self.pokedexCollectionView.delegate = self
        self.pokedexCollectionView.dataSource = self
        self.pokedexCollectionView.isHidden = true
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
            self.startLoading()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pokemonSelected = pokemonList[indexPath.row]
        performSegue(withIdentifier: "pokemonDetailViewController",
                     sender: pokemonSelected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.width/3 - 24), height: 124)
    }
}

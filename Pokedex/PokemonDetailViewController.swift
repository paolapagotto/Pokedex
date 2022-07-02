//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Paola Pagotto on 02/07/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var infoContainer: UIView!
    @IBAction func dismissPokemonButton(_ sender: Any) {
        
    }
    
    var pokemon: PokemonModel?
    var request = PokedexRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideUI()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func hideUI() {
        infoContainer.isHidden = true
        imageContainer.isHidden = true
    }
    
    func updateUI(){
        guard let pokemon = self.pokemon else { return }
        activityIndicator.startAnimating()
        
        getPokemonImage(url: pokemon.urlImage)
        
        infoContainer.layer.cornerRadius = 5.0
        imageContainer.layer.cornerRadius = 5.0
        
        infoContainer.isHidden = false
        imageContainer.isHidden = false
        imageContainer.backgroundColor = pokemon.type.getPokemonTypeColor()
        
        imageContainer.bringSubviewToFront(pokemonImage)
        
        idLabel.text = "# \(pokemon.id)"
        nameLabel.text = "\(pokemon.name.capitalized)"
        weightLabel.text = "Weight: \(pokemon.weight)"
        heightLabel.text = "Height: \(pokemon.height)"
        typeLabel.text = "Type: \(pokemon.type)"
        attackLabel.text = "Attack: \(pokemon.attack)"
        defenseLabel.text = "Defense: \(pokemon.defense)"
        specialAttackLabel.text = "Special-attack: \(pokemon.specialAttack)"

        
    }
    
    private func getPokemonImage(url: String) {
        request.getPokemonImage(url: url) { (response) in
            
            switch response {
            case .success(let data):
                DispatchQueue.main.async {
                    self.pokemonImage.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
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
}

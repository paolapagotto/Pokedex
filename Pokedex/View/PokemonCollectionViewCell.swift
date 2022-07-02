//
//  PokemonCollectionViewCell.swift
//  Pokedex
//
//  Created by Paola Pagotto on 26/06/2022.
//  Copyright © 2022 Paola Pagotto. All rights reserved.
//

import Foundation
import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configCell(withModel model: PokemonModel,
                    spriteData data: Data) {
        
        nameLabel.text = model.name.capitalized
        idLabel.text = "#\(model.id)"
        pokemonImageView.image = UIImage(data: data)
    }
    
}



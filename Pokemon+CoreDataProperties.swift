//
//  Pokemon+CoreDataProperties.swift
//  
//
//  Created by Paola Pagotto on 03/07/2022.
//
//

import Foundation
import CoreData


extension Pokemon {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Pokemon> {
        return NSFetchRequest<Pokemon>(entityName: "Pokemon")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: Int32
    @NSManaged public var type: String?
    @NSManaged public var weight: Int32
    @NSManaged public var height: Int32
    @NSManaged public var attack: Int32
    @NSManaged public var defense: Int32
    @NSManaged public var specialAttack: Int32
    @NSManaged public var imageUrl: String?

}

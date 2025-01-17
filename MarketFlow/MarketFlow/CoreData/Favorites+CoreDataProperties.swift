//
//  Favorites+CoreDataProperties.swift
//  MarketFlow
//
//  Created by İrem Onart on 17.01.2025.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var image: String?

}

extension Favorites : Identifiable {

}

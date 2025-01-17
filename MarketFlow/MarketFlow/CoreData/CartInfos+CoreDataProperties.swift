//
//  CartInfos+CoreDataProperties.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//
//

import Foundation
import CoreData


extension CartInfos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartInfos> {
        return NSFetchRequest<CartInfos>(entityName: "CartInfos")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var quantity: Int16

}

extension CartInfos : Identifiable {

}

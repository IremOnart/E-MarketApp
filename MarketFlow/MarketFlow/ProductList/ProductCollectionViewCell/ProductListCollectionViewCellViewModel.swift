//
//  ProductListCollectionViewCellViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 17.01.2025.
//

import Foundation

class ProductListCollectionViewCellViewModel {
    
    var favItems: [Favorites] = []
    func updateFavoriteStatus(productID: String, name: String?, price: String?, image: String?, isFavorite: Bool) {
        CoreDataManager.shared.updateFavoriteStatus(for: productID, name: name, price: price, image: image, isFavorite: isFavorite)
    }
    
}

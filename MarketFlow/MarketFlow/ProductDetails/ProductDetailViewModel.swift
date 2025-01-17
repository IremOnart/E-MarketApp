//
//  ProductDetailViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import Foundation

class ProductDetailViewModel: ProductDetailViewModelProtocol {
    var changeHandler: ((ProductDetailViewModelChange) -> Void)?
    var productImage: String = ""
    var productTitle: String = ""
    var productDiscription: String = ""
    var price: String = ""
    var id: String = ""
    
    init(productImage: String, productTitle: String, productDiscription: String, price: String, id: String) {
        self.productImage = productImage
        self.productTitle = productTitle
        self.productDiscription = productDiscription
        self.price = price
        self.id = id
    }
    
    private func emit(change: ProductDetailViewModelChange) {
        changeHandler?(change)
    }
    
}

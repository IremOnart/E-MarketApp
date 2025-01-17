//
//  ProductDetailViewModelProtocol.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import Foundation

enum ProductDetailViewModelChange {
    case didError(String)
    case success
}

protocol ProductDetailViewModelProtocol {
    var changeHandler: ((ProductDetailViewModelChange) -> Void)? {get set}
   
    var productImage: String { get set }
    var productTitle: String { get set }
    var productDiscription: String { get set }
    var price: String { get set }
    var id: String { get set }
}

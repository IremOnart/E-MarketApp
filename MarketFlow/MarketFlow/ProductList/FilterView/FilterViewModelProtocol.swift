//
//  FilterViewModelProtocol.swift
//  MarketFlow
//
//  Created by İrem Onart on 15.01.2025.
//

import Foundation

enum FilterViewModelChange {
    case didError(String)
    case success
}

protocol FilterViewModelProtocol {
    var changeHandler: ((FilterViewModelChange) -> Void)? {get set}
    var products: [MarketProductElement] {get set}
    var filteredProducts: [MarketProductElement] {get set}
    
}

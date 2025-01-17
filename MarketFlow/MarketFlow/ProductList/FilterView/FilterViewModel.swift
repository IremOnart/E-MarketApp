//
//  FilterViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 15.01.2025.
//

import Foundation

class FilterViewModel: FilterViewModelProtocol {
    var products: [MarketProductElement] = []
    var filteredProducts: [MarketProductElement] = []
    var changeHandler: ((FilterViewModelChange) -> Void)?
    
    private func emit(change: FilterViewModelChange) {
        changeHandler?(change)
    }
}

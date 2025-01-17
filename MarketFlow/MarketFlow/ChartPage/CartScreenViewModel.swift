//
//  CartScreenViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import Foundation

class CartScreenViewModel: CartScreenViewModelProtocol {
    var changeHandler: ((CartScreenViewModelChange) -> Void)?
    
    
    var cartItems: [CartInfos] = []
    
    func fetchCartItems() {
        cartItems = CoreDataManager.shared.fetchCartItems()
        print(cartItems)
        if cartItems.isEmpty {
            self.emit(change: .emptyPage)
        } else {
            self.emit(change: .success)
        }
    }
    
    func addCartItem(id: String) {
        CoreDataManager.shared.addCartItem(id: id, name: "", price: 0.0)
    }
    
    func decreaseCartItemQuantity(id: String) {
        CoreDataManager.shared.decreaseCartItemQuantity(id: id)
    }
    
    
    private func emit(change: CartScreenViewModelChange) {
        changeHandler?(change)
    }
}

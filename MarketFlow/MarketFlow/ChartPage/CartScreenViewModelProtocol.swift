//
//  CartScreenViewModelProtocol.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import Foundation

enum CartScreenViewModelChange {
    case didError(String)
    case success
    case emptyPage
}

protocol CartScreenViewModelProtocol {
    var changeHandler: ((CartScreenViewModelChange) -> Void)? {get set}
    var cartItems: [CartInfos] { get set }
    
    func fetchCartItems()
    func addCartItem(id: String)
    func decreaseCartItemQuantity(id: String)
}

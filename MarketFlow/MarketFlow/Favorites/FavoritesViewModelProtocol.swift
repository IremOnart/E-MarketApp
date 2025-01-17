//
//  FavoritesViewModelProtocol.swift
//  MarketFlow
//
//  Created by İrem Onart on 17.01.2025.
//

import Foundation

enum FavoritesViewModelChange {
    case didError(String)
    case success
    case emptyPage
}

protocol FavoritesViewModelProtocol {
    var changeHandler: ((FavoritesViewModelChange) -> Void)? {get set}
    var favItems: [Favorites] { get set }
    var numOfFavItems: Int? { get }
    
    func fetchFavItems()
    func indexOfUsers(for indexPath: IndexPath) -> Favorites
}

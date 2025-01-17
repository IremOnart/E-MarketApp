//
//  FavoritesViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 17.01.2025.
//

import Foundation

class FavoritesViewModel: FavoritesViewModelProtocol {

    var changeHandler: ((FavoritesViewModelChange) -> Void)?
    var favItems: [Favorites] = []
    var numOfFavItems: Int? {
        favItems.count
    }
    
    func fetchFavItems() {
        // Core Data'dan favori ürünleri yükle
        favItems = CoreDataManager.shared.fetchFavoriteItems()
        print(favItems.first?.name)
        if favItems.isEmpty {
            self.emit(change: .emptyPage)
            print("erorrr")
        } else {
            self.emit(change: .success)
            print("favItem: \(favItems)")
        }
    }
    
    func indexOfUsers(for indexPath: IndexPath) -> Favorites {
        return favItems[indexPath.row]
    }
    
    private func emit(change: FavoritesViewModelChange) {
        changeHandler?(change)
    }
}

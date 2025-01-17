//
//  ProductListViewModelProtocol.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation

enum ProductListViewModelChange {
    case didError(String)
    case success
}

protocol ProductListViewModelProtocol {
    var changeHandler: ((ProductListViewModelChange) -> Void)? {get set}
    var productList: [MarketProductElement] {get set}
    var numOfProducts: Int? { get }
    var filteredProductList: [MarketProductElement] { get set }
    var isFetchingData: Bool { get set }
    var currentPage: Int { get set }
    var productsPerPage: Int { get set }
    var isLastPage: Bool { get set }
    
    func fetchProducts() 
    func productListItem(for indexPath: IndexPath) -> MarketProductElement
    func searchProducts(by searchText: String)
    func resetFilter()
    func filterProducts(name: String, price: Double, brand: String, model: String) 
}

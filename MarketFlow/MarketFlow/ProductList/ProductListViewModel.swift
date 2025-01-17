//
//  ProductListViewModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation

class ProductListViewModel: ProductListViewModelProtocol {
    
    var changeHandler: ((ProductListViewModelChange) -> Void)?
    var productList: [MarketProductElement] = []
    var filteredProductList: [MarketProductElement] = []
    var numOfProducts: Int? { filteredProductList.count }
    var isFetchingData: Bool = false
    var currentPage: Int = 1
    var productsPerPage: Int = 4
    var isLastPage: Bool = false

    
    func fetchProducts() {
           guard !isFetchingData, !isLastPage else { return }
           isFetchingData = true
            currentPage += 1
           let urlString = "https://5fc9346b2af77700165ae514.mockapi.io/products?page=\(currentPage)&limit=\(productsPerPage)"
           if let url = URL(string: urlString) {
               NetworkManager.shared.get(url) { [weak self] (result: Result<MarketProduct, Error>) in
                   guard let self = self else { return }
                   self.isFetchingData = false
                   
                   switch result {
                   case .success(let products):
                       if products.isEmpty {
                           self.isLastPage = true
                           print(self.filteredProductList.count)
                       } else {
                           self.productList.append(contentsOf: products)
                           self.filteredProductList.append(contentsOf: products)
                           SingletonModel.shared.productsInfos = self.productList
                           self.emit(change: .success)
                           print(self.filteredProductList.count)
                       }
                   case .failure(let error):
                       print("Error: \(error.localizedDescription)")
                       emit(change: .didError("An error occurred while fetching products"))
                   }
               }
           }
       }
    
    func productListItem(for indexPath: IndexPath) -> MarketProductElement {
        return filteredProductList[indexPath.row]
    }
    
    // Search İşlemi
    func searchProducts(by searchText: String) {
        // Arama metni boş değilse ürünleri filtrele
        filteredProductList = productList.filter { product in
            return product.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
    }
    
    func resetFilter() {
        // Filtreyi sıfırlayarak tüm ürünleri göster
        filteredProductList = productList
    }
    
    func filterProducts(name: String, price: Double, brand: String, model: String) {
        filteredProductList = productList.filter { product in
            guard let productPriceString = product.price, let productPrice = Double(productPriceString) else {
                return false
            }
            
            let matchesPrice = productPrice <= price
            let matchesName = name.isEmpty || product.name?.lowercased().contains(name.lowercased()) == true
            let matchesBrand = brand.isEmpty || product.brand?.lowercased().contains(brand.lowercased()) == true
            let matchesModel = model.isEmpty || product.model?.lowercased().contains(model.lowercased()) == true
            
            print(matchesName)
            print(matchesBrand)
            print(matchesModel)
            emit(change: .success)
            return matchesName && matchesPrice && matchesBrand && matchesModel
        }
    }
    
    private func emit(change: ProductListViewModelChange) {
        changeHandler?(change)
    }
    
}

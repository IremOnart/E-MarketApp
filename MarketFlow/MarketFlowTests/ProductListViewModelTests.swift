//
//  ProductListViewModelTests.swift
//  MarketFlowUITests
//
//  Created by İrem Onart on 17.01.2025.
//

import XCTest
@testable import MarketFlow

class ProductListViewModelTests: XCTestCase {
    
    var viewModel: ProductListViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        viewModel = ProductListViewModel() // Or real network manager
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFilterByName() {
        // Arrange: Mock data
        viewModel.productList = [
            MarketProductElement(createdAt: "", name: "Apple iPhone", image: "", price: "1000", description: nil, model: "12 Pro", brand: "Apple", id: "1"),
            MarketProductElement(createdAt: "", name: "Samsung Galaxy", image: "", price: "900", description: nil, model: "S21", brand: "Samsung", id: "2"),
            MarketProductElement(createdAt: "",name: "Apple Watch", image: "", price: "500", description: nil, model: "Series 7", brand: "Apple", id: "3")
        ]
        
        // Act: Filter by "Apple"
        viewModel.filterProducts(name: "Apple", price: 2000, brand: "", model: "")
        
        // Assert: The filtered list should only contain products with "Apple" in the name
        XCTAssertEqual(viewModel.filteredProductList.count, 2)
        XCTAssertTrue(viewModel.filteredProductList.allSatisfy { $0.name?.contains("Apple") == true })
    }
    
    func testFilterByPrice() {
        // Arrange: Mock data
        viewModel.productList = [
            MarketProductElement(createdAt: "",name: "Apple iPhone", image: "", price: "1000", description: nil, model: "12 Pro", brand: "Apple", id: "1"),
            MarketProductElement(createdAt: "",name: "Samsung Galaxy", image: "", price: "900", description: nil, model: "S21", brand: "Samsung", id: "2"),
            MarketProductElement(createdAt: "",name: "Apple Watch", image: "", price: "500", description: nil, model: "Series 7", brand: "Apple", id: "3")
        ]
        
        // Act: Filter by price <= 900
        viewModel.filterProducts(name: "", price: 900, brand: "", model: "")
        
        // Assert: Only the products with price <= 900 should be in the filtered list
        XCTAssertEqual(viewModel.filteredProductList.count, 2)
        XCTAssertTrue(viewModel.filteredProductList.allSatisfy { Double($0.price!) ?? 0 <= 900 })
    }
    
    func testFilterByBrand() {
        // Arrange: Mock data
        viewModel.productList = [
            MarketProductElement(createdAt: "",name: "Apple iPhone", image: "", price: "1000", description: nil, model: "12 Pro", brand: "Apple", id: "1"),
            MarketProductElement(createdAt: "",name: "Samsung Galaxy", image: "", price: "900", description: nil, model: "S21", brand: "Samsung", id: "2"),
            MarketProductElement(createdAt: "",name: "Apple Watch", image: "", price: "500", description: nil, model: "Series 7", brand: "Apple", id: "3")
        ]
        
        // Act: Filter by brand "Apple"
        viewModel.filterProducts(name: "", price: 2000, brand: "Apple", model: "")
        
        // Assert: Only products with brand "Apple" should be in the filtered list
        XCTAssertEqual(viewModel.filteredProductList.count, 2)
        XCTAssertTrue(viewModel.filteredProductList.allSatisfy { $0.brand?.lowercased() == "apple" })
    }
    
    func testFilterByModel() {
        // Arrange: Mock data
        viewModel.productList = [
            MarketProductElement(createdAt: "",name: "Apple iPhone", image: "", price: "1000", description: nil, model: "12 Pro", brand: "Apple", id: "1"),
            MarketProductElement(createdAt: "",name: "Samsung Galaxy", image: "", price: "900", description: nil, model: "S21", brand: "Samsung", id: "2"),
            MarketProductElement(createdAt: "",name: "Apple Watch", image: "", price: "500", description: nil, model: "Series 7", brand: "Apple", id: "3")
        ]
        
        // Act: Filter by model "12 Pro"
        viewModel.filterProducts(name: "", price: 2000, brand: "", model: "12 Pro")
        
        // Assert: Only the products with model "12 Pro" should be in the filtered list
        XCTAssertEqual(viewModel.filteredProductList.count, 1)
        XCTAssertTrue(viewModel.filteredProductList.allSatisfy { $0.model == "12 Pro" })
    }
    
    func testFilterNoMatches() {
        // Arrange: Mock data
        viewModel.productList = [
            MarketProductElement(createdAt: "",name: "Apple iPhone", image: "", price: "1000", description: nil, model: "12 Pro", brand: "Apple", id: "1"),
            MarketProductElement(createdAt: "",name: "Samsung Galaxy", image: "", price: "900", description: nil, model: "S21", brand: "Samsung", id: "2"),
            MarketProductElement(createdAt: "",name: "Apple Watch", image: "", price: "500", description: nil, model: "Series 7", brand: "Apple", id: "3")
        ]
        
        // Act: Filter by non-existing product (brand "Nokia")
        viewModel.filterProducts(name: "", price: 2000, brand: "Nokia", model: "")
        
        // Assert: No products should match
        XCTAssertEqual(viewModel.filteredProductList.count, 0)
    }
    
    func testFetchProductsSuccess() {
        // Arrange: Mock data for successful network response
        let mockProducts: [MarketProductElement] = [
            MarketProductElement(createdAt: "2023-07-17T07:21:02.529Z",name: "Bentley Focus", image: "https://loremflickr.com/640/480/food", price: "51.00", description: "Quasi adipisci sint veniam delectus. Illum laboriosam minima dignissimos natus earum facere consequuntur eius vero. Itaque facilis at tempore ipsa. Accusamus nihil fugit velit possimus expedita error porro aliquid. Optio magni mollitia veritatis repudiandae tenetur nemo. Id consectetur fuga ipsam quidem voluptatibus sed magni dolore.\nFacilis commodi dolores sapiente delectus nihil ex a perferendis. Totam deserunt assumenda inventore. Incidunt nesciunt adipisci natus porro deleniti nisi incidunt laudantium soluta. Nostrum optio ab facilis quisquam.\nSoluta laudantium ipsa ut accusantium possimus rem. Illo voluptatibus culpa incidunt repudiandae placeat animi. Delectus id in animi incidunt autem. Ipsum provident beatae nisi cumque nulla iure.", model: "CTS", brand: "Lamborghini", id: "1"),
            MarketProductElement(createdAt: "2023-07-17T02:49:46.692Z",name: "Aston Martin Durango", image: "https://loremflickr.com/640/480/food", price: "374.00", description: "Odio et voluptates velit omnis incidunt dolor. Illo sint quisquam tenetur dolore nemo molestiae. Dolorum odio dicta placeat. Commodi rerum molestias quibusdam labore. Odio libero doloribus. Architecto repellendus aperiam nulla at at voluptatibus ipsum.\nFugit expedita a quo totam quaerat amet eveniet laboriosam. Ad assumenda atque porro neque iusto. Inventore repudiandae esse non sit veritatis ab reprehenderit quas. Sit qui natus exercitationem quis commodi vero.\nIure reiciendis quas corrupti incidunt repellat voluptatem esse eveniet. Aliquid illo cum doloremque similique. Blanditiis corporis repellendus cumque totam quod iusto dolorum. Incidunt a eos eum voluptas tempora voluptas reiciendis autem", model: "Roadster", brand: "Smart", id: "2")
        ]
        
        mockNetworkManager.mockResult = .success(mockProducts)
        
        // Act: Call fetchProducts
        viewModel.fetchProducts()

        // Wait for asynchronous completion
        let expectation = self.expectation(description: "Products should be fetched")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 4, handler: nil)

        // Assert: Check if products are fetched correctly
        XCTAssertEqual(viewModel.productList.count, 4)
        XCTAssertEqual(viewModel.filteredProductList.count, 4)
    }

        func testFetchProductsFailure() {
            // Arrange: Mock data for network failure
            mockNetworkManager.mockResult = .failure(NSError(domain: "TestError", code: 1001, userInfo: nil))
            
            // Act: Call fetchProducts
            viewModel.fetchProducts()
            
            // Assert: Check if failure handling works
            XCTAssertEqual(viewModel.productList.count, 0)
            XCTAssertEqual(viewModel.filteredProductList.count, 0)
        }
    
}


class MockNetworkManager: NetworkManagerProtocol {
    
    var mockResult: Result<MarketProduct, Error>?
    
    // Ensure the method signature matches the required parameters
    func request<T: Decodable>(_ url: URL, method: String = "GET", body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        if let result = mockResult as? Result<T, Error> {
            completion(result) // Correctly passing the result
        }
    }
}

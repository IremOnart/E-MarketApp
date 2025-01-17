//
//  MarketProducts.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation

// MARK: - MarketProductElement
struct MarketProductElement: Codable {
    let createdAt, name: String?
    let image: String?
    let price, description, model, brand: String?
    let id: String?
}

typealias MarketProduct = [MarketProductElement]

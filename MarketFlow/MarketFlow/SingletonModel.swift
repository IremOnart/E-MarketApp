//
//  SingletonModel.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import Foundation

public class SingletonModel {
    static var shared = SingletonModel()
    
    var productsInfos: [MarketProductElement] = []
    var badgetInfo: Int = 0
    
}

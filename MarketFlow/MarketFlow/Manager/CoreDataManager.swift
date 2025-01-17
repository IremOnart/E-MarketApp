//
//  CoreDataManager.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CartItems") // Bu isim 'CartModel' Core Data model dosyanızla uyumlu olmalı
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
                print("it s saved")
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func addCartItem(id: String, name: String, price: Double, newQuantity: Int = 1) {
        let request: NSFetchRequest<CartInfos> = CartInfos.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let items = try context.fetch(request)
            
            if let item = items.first {
                // Eğer ürün varsa, miktarı artırıyoruz
                item.quantity += Int16(newQuantity)
            } else {
                // Eğer ürün yoksa, yeni bir ürün ekliyoruz
                let newItem = CartInfos(context: context)
                newItem.id = id
                newItem.quantity = Int16(newQuantity)
                newItem.name = name
                newItem.price = price
                
                // Yeni ürünü kaydediyoruz
                saveContext()
            }
            
            // Değişiklikleri kaydediyoruz
            saveContext()
            
        } catch {
            print("Failed to update or add item: \(error)")
        }
    }
    
    func decreaseCartItemQuantity(id: String) {
        let request: NSFetchRequest<CartInfos> = CartInfos.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let items = try context.fetch(request)
            
            if let item = items.first {
                // Eğer ürün varsa, miktarı -1 yapıyoruz
                if item.quantity > 1 {
                    item.quantity -= 1
                } else {
                    // Eğer ürünün miktarı 1 ise, ürünü siliyoruz
                    context.delete(item)
                }
                // Değişiklikleri kaydediyoruz
                saveContext()
            } else {
                print("Item not found.")
            }
        } catch {
            print("Failed to update or delete item: \(error)")
        }
    }


    
    func fetchCartItems() -> [CartInfos] {
        let request: NSFetchRequest<CartInfos> = CartInfos.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
            return []
        }
    }
    
    func updateCartItemQuantity(id: UUID, newQuantity: Int) {
        let request: NSFetchRequest<CartInfos> = CartInfos.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let items = try context.fetch(request)
            if let item = items.first {
                item.quantity = Int16(newQuantity)
                saveContext()
            }
        } catch {
            print("Failed to update item: \(error)")
        }
    }
}

extension Notification.Name {
    static let cartUpdated = Notification.Name("cartUpdated")
}

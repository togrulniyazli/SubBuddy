//
//  CartManager.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import Foundation

final class CartManager {
    
    static let shared = CartManager()
    
    private init() {
        load()
    }
    
    private let key = "savedCartItems"
    
    private(set) var items: [CartItem] = []
    
    var onUpdate: (() -> Void)?
    
    
    func contains(app: AppModel) -> Bool {
        return items.contains { $0.app.id == app.id }
    }
    
    
    func add(app: AppModel, plan: SubscriptionPlan, price: Double) -> Bool {
        if contains(app: app) {
            return false
        }
        
        let item = CartItem(
            app: app,
            plan: plan,
            price: price
        )
        
        items.append(item)
        save()
        onUpdate?()
        
        return true
    }
    
    
    func remove(at index: Int) {
        guard items.indices.contains(index) else { return }
        items.remove(at: index)
        save()
        onUpdate?()
    }
    
    
    func removeItems(_ removing: [CartItem]) {
        items.removeAll { item in
            removing.contains { $0.app.id == item.app.id }
        }
        
        save()
        onUpdate?()
    }
    
    
    func clear() {
        items.removeAll()
        save()
        onUpdate?()
    }
    
    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }
    
    var itemCount: Int {
        items.count
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        
        if let saved = try? JSONDecoder().decode([CartItem].self, from: data) {
            items = saved
        }
    }
}

//
//  CartManager.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import Foundation
import FirebaseAuth

final class CartManager {
    
    static let shared = CartManager()
    
    private init() {
        load()
    }
    
    private(set) var items: [CartItem] = []
    
    var onUpdate: (() -> Void)?
    
    private var key: String {
        guard let uid = Auth.auth().currentUser?.uid else {
            return "savedCartItems_guest"
        }
        return "savedCartItems_\(uid)"
    }
    
    func refreshForCurrentUser() {
        load()
        onUpdate?()
    }
    
    func contains(app: AppModel) -> Bool {
        items.contains { $0.app.id == app.id }
    }
    
    @discardableResult
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
        items = deduplicated(items)
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
        let removingIDs = Set(removing.map { $0.app.id })
        
        items.removeAll { item in
            removingIDs.contains(item.app.id)
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
        let uniqueItems = deduplicated(items)
        items = uniqueItems
        
        if let data = try? JSONEncoder().encode(uniqueItems) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            items = []
            return
        }
        
        if let saved = try? JSONDecoder().decode([CartItem].self, from: data) {
            items = deduplicated(saved)
            save()
        } else {
            items = []
        }
    }
    
    private func deduplicated(_ items: [CartItem]) -> [CartItem] {
        var seen = Set<String>()
        
        return items.filter { item in
            let inserted = seen.insert(item.app.id).inserted
            return inserted
        }
    }
}

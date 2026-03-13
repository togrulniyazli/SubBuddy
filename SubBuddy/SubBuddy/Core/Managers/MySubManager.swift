//
//  MySubManager.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import Foundation
import FirebaseAuth

final class MySubManager {
    
    static let shared = MySubManager()
    
    private init() {
        load()
    }
    
    private(set) var subscriptions: [Subscription] = []
    
    var onUpdate: (() -> Void)?
    
    private var key: String {
        guard let uid = Auth.auth().currentUser?.uid else {
            return "savedSubscriptions_guest"
        }
        return "savedSubscriptions_\(uid)"
    }
    
    func refreshForCurrentUser() {
        load()
        onUpdate?()
    }
    
    func contains(app: AppModel) -> Bool {
        subscriptions.contains { $0.app.id == app.id }
    }
    
    func addSubscriptions(_ items: [CartItem]) {
        let startDate = Date()
        
        let endDate = Calendar.current.date(
            byAdding: .day,
            value: 30,
            to: startDate
        )!
        
        for item in items {
            if contains(app: item.app) {
                continue
            }
            
            let sub = Subscription(
                app: item.app,
                plan: item.plan.rawValue,
                startDate: startDate,
                endDate: endDate,
                isEndingSoon: false
            )
            
            subscriptions.append(sub)
        }
        
        subscriptions = deduplicated(subscriptions)
        save()
        onUpdate?()
    }
    
    func stopSubscription(for app: AppModel) {
        guard let index = subscriptions.firstIndex(where: { $0.app.id == app.id }) else { return }
        
        var sub = subscriptions[index]
        sub.isEndingSoon = true
        subscriptions[index] = sub
        
        save()
        onUpdate?()
    }
    
    func update(_ sub: Subscription, at index: Int) {
        guard subscriptions.indices.contains(index) else { return }
        
        subscriptions[index] = sub
        subscriptions = deduplicated(subscriptions)
        save()
        onUpdate?()
    }
    
    func clear() {
        subscriptions.removeAll()
        save()
        onUpdate?()
    }
    
    private func save() {
        let uniqueSubscriptions = deduplicated(subscriptions)
        subscriptions = uniqueSubscriptions
        
        if let data = try? JSONEncoder().encode(uniqueSubscriptions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {

        subscriptions.removeAll()

        guard let data = UserDefaults.standard.data(forKey: key) else { return }

        if let saved = try? JSONDecoder().decode([Subscription].self, from: data) {
            subscriptions = saved
        }
    }
    
    private func deduplicated(_ items: [Subscription]) -> [Subscription] {
        var seen = Set<String>()
        
        return items.filter { item in
            let inserted = seen.insert(item.app.id).inserted
            return inserted
        }
    }
}

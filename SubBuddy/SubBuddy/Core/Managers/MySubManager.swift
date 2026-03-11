//
//  MySubManager.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import Foundation

final class MySubManager {
    
    static let shared = MySubManager()
    
    private init() {
        load()
    }
    
    private(set) var subscriptions: [Subscription] = []
    
    private let key = "savedSubscriptions"
    
    var onUpdate: (() -> Void)?
    
    
    func contains(app: AppModel) -> Bool {
        return subscriptions.contains {
            $0.app.id == app.id
        }
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
        
        save()
        
        onUpdate?()
    }
    
    
    func stopSubscription(for app: AppModel) {
        
        guard let index = subscriptions.firstIndex(where: {
            $0.app.id == app.id
        }) else { return }
        
        var sub = subscriptions[index]
        
        sub.isEndingSoon = true
        subscriptions[index] = sub
        save()
        onUpdate?()
    }
    
    
    private func save() {
        
        if let data = try? JSONEncoder().encode(subscriptions) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    
    private func load() {
        
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        
        if let saved = try? JSONDecoder().decode([Subscription].self, from: data) {
            subscriptions = saved
        }
    }
    
    
    func update(_ sub: Subscription, at index: Int) {
        
        guard subscriptions.indices.contains(index) else { return }
        
        subscriptions[index] = sub
        save()
        onUpdate?()
    }
}

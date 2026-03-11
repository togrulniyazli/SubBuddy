//
//  MySubViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import Foundation

final class MySubViewModel {
    
    
    private var allSubscriptions: [Subscription] = []
    private var subscriptions: [Subscription] = []
    
    var onUpdate: (() -> Void)?
    
    
    init() {
        reload()
    }
    
    
    func reload() {
        allSubscriptions = MySubManager.shared.subscriptions
        subscriptions = allSubscriptions
        
        onUpdate?()
    }
    
    
    var count: Int {
        subscriptions.count
    }
    
    
    var totalCount: Int {
        allSubscriptions.count
    }
    
    
    func item(at index: Int) -> Subscription {
        subscriptions[index]
    }
    
    
    func search(_ text: String) {
        if text.isEmpty {
            subscriptions = allSubscriptions
        } else {
            subscriptions = allSubscriptions.filter {
                $0.app.name.lowercased().contains(text.lowercased())
            }
        }
        onUpdate?()
    }
}

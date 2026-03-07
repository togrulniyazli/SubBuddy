//
//  Subscription.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import Foundation

struct Subscription: Codable {
    
    let app: AppModel
    let plan: String
    let startDate: Date
    let endDate: Date
    
    var isEndingSoon: Bool
    
    var status: String {
        if isEndingSoon {
            return "Subscription ending soon"
        }
        
        let daysLeft = Calendar.current.dateComponents(
            [.day],
            from: Date(),
            to: endDate
        ).day ?? 0
        
        if daysLeft <= 10 {
            return "Subscription ending soon"
        }
        return "Active"
    }
}

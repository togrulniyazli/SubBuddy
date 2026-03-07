//
//  CartItem.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import Foundation

struct CartItem: Codable {

    let app: AppModel
    let plan: SubscriptionPlan
    let price: Double
}

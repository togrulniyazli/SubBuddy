//
//  AppModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import Foundation

struct AppModel: Codable {

    let id: UUID
    let name: String
    let iconURL: String
    let price: Double
    let rating: Double
    let category: AppCategory
}

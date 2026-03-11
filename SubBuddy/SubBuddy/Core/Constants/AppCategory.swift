//
//  AppCategory.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import Foundation

enum AppCategory: String, CaseIterable, Codable {
    case all = "All"
    case entertainment = "Entertainment"
    case productivity = "Productivity"
    case education = "Education"
    case health = "Health"
    case finance = "Finance"
}

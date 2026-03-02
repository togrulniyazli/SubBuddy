//
//  MockApps.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import Foundation

struct MockApps {

    static let all: [AppModel] = [


        AppModel(
            id: UUID(),
            name: "YouTube Premium",
            iconName: "youtube",
            price: 4.76,
            rating: 4.9,
            category: .entertainment
        ),

        AppModel(
            id: UUID(),
            name: "Spotify",
            iconName: "spotify",
            price: 3.79,
            rating: 4.7,
            category: .entertainment
        ),

        AppModel(
            id: UUID(),
            name: "HBO Max",
            iconName: "hbo",
            price: 5.99,
            rating: 4.8,
            category: .entertainment
        ),


        AppModel(
            id: UUID(),
            name: "Notion Plus",
            iconName: "notion",
            price: 8.00,
            rating: 4.8,
            category: .productivity
        ),

        AppModel(
            id: UUID(),
            name: "ClickUp",
            iconName: "clickup",
            price: 7.00,
            rating: 4.6,
            category: .productivity
        ),

        AppModel(
            id: UUID(),
            name: "ChatGPT Plus",
            iconName: "chatgpt",
            price: 20.00,
            rating: 4.9,
            category: .productivity
        ),


        AppModel(
            id: UUID(),
            name: "Ruangguru",
            iconName: "ruangguru",
            price: 2.99,
            rating: 4.5,
            category: .education
        ),

        AppModel(
            id: UUID(),
            name: "Udemy Pro",
            iconName: "udemy",
            price: 9.99,
            rating: 4.7,
            category: .education
        ),


        AppModel(
            id: UUID(),
            name: "Headspace",
            iconName: "headspace",
            price: 6.99,
            rating: 4.6,
            category: .health
        ),

        AppModel(
            id: UUID(),
            name: "MyFitnessPal Premium",
            iconName: "myfitnesspal",
            price: 9.99,
            rating: 4.5,
            category: .health
        ),


        AppModel(
            id: UUID(),
            name: "Revolut Premium",
            iconName: "revolut",
            price: 7.99,
            rating: 4.8,
            category: .finance
        ),

        AppModel(
            id: UUID(),
            name: "PayPal Plus",
            iconName: "paypal",
            price: 4.99,
            rating: 4.6,
            category: .finance
        )
    ]
}

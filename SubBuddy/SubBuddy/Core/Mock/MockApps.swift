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
            iconURL: "https://upload.wikimedia.org/wikipedia/commons/e/ef/Youtube_logo.png",
            price: 4.76,
            rating: 4.9,
            category: .entertainment
        ),

        AppModel(
            id: UUID(),
            name: "Spotify",
            iconURL: "https://upload.wikimedia.org/wikipedia/commons/7/75/Spotify_icon.png",
            price: 3.79,
            rating: 4.7,
            category: .entertainment
        ),

        AppModel(
            id: UUID(),
            name: "Netflix",
            iconURL: "https://1000logos.net/wp-content/uploads/2017/05/Netflix-Logo.png",
            price: 9.99,
            rating: 4.8,
            category: .entertainment
        ),

        AppModel(
            id: UUID(),
            name: "Notion",
            iconURL: "https://upload.wikimedia.org/wikipedia/commons/4/45/Notion_app_logo.png",
            price: 8.00,
            rating: 4.8,
            category: .productivity
        ),

        AppModel(
            id: UUID(),
            name: "ChatGPT Plus",
            iconURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/512px-ChatGPT_logo.svg.png",
            price: 20.00,
            rating: 4.9,
            category: .productivity
        ),

        AppModel(
            id: UUID(),
            name: "Udemy",
            iconURL: "https://logos-world.net/wp-content/uploads/2021/11/Udemy-Logo.png",
            price: 9.99,
            rating: 4.7,
            category: .education
        ),

        AppModel(
            id: UUID(),
            name: "Headspace",
            iconURL: "https://upload.wikimedia.org/wikipedia/commons/f/f7/Headspace_text_logo.png",
            price: 6.99,
            rating: 4.6,
            category: .health
        ),

        AppModel(
            id: UUID(),
            name: "PayPal",
            iconURL: "https://www.citypng.com/public/uploads/preview/transparent-hd-paypal-logo-701751694777788ilpzr3lary.png",
            price: 4.99,
            rating: 4.6,
            category: .finance
        ),
        
        AppModel(
            id: UUID(),
            name: "Revolut",
            iconURL: "https://images.icon-icons.com/2699/PNG/512/revolut_logo_icon_168859.png",
            price: 8.75,
            rating: 4.7,
            category: .finance
        )
    ]
}

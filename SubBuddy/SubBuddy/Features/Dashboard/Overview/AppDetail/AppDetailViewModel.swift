//
//  AppDetailViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 05.03.26.
//

import Foundation

final class AppDetailViewModel {
    
    let app: AppModel
    
    private(set) var selectedPlan: SubscriptionPlan = .standard
    
    init(app: AppModel) {
        self.app = app
    }
    
    func selectPlan(_ plan: SubscriptionPlan) {
        selectedPlan = plan
    }
    
    var titleText: String {
        app.name
    }
    
    var ratingText: String {
        "⭐ \(String(format: "%.1f", app.rating))"
    }
    
    var reviewsText: String {
        "\(reviewsCount) reviews"
    }
    
    var descriptionText: String {
        descriptionForApp
    }
    
    
    func currentPrice() -> Double {
        switch selectedPlan {
        case .standard:
            return standardPrice
        case .family:
            return round2(standardPrice * 1.5)
        case .student:
            return round2(standardPrice * 0.8)
        }
    }
    
    func shouldShowOriginalPrice() -> Bool {
        selectedPlan == .student
    }
    
    func originalPrice() -> Double {
        standardPrice
    }
    
    
    private var standardPrice: Double {
        round2(app.price)
    }
    
    private var reviewsCount: Int {
        
        let map: [String: Int] = [
            "YouTube Premium": 1200,
            "YouTube": 1200,
            "Spotify": 980,
            "Notion": 640,
            "HBO": 730
        ]
        
        return map[app.name] ?? 1000
    }
    
    private var descriptionForApp: String {
        
        let map: [String: String] = [
            
            "YouTube Premium":
                "Enjoy YouTube without ads, download videos for offline, and play music in the background with a smoother experience.",
            
            "Spotify":
                "Listen to millions of songs and podcasts with personalized playlists, smart recommendations, and offline listening.",
            
            "Netflix":
                "Watch movies, TV series, and exclusive originals with high-quality streaming across all your devices.",
            
            "Notion":
                "Organize your notes, tasks, documents, and projects in one flexible workspace with powerful productivity tools.",
            
            "ChatGPT Plus":
                "Get faster responses and priority access to advanced AI models to boost productivity, learning, and creativity.",
            
            "Udemy":
                "Learn new skills from thousands of online courses in programming, design, business, and more.",
            
            "Headspace":
                "Improve your mental health with guided meditation, mindfulness exercises, and better sleep programs.",
            
            "PayPal":
                "Send and receive money securely online, manage payments, and shop globally with trusted protection.",
            
            "Revolut":
                "Manage your money, exchange currencies, send transfers, and track spending with a modern digital banking app."
        ]
        
        return map[app.name] ??
        "Premium subscription benefits: ad-free access, offline features, and an enhanced user experience."
    }
    
    private func round2(_ value: Double) -> Double {
        (value * 100).rounded() / 100
    }
}

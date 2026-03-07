//
//  OverviewViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import Foundation

final class OverviewViewModel {
    
    private let allApps: [AppModel] = MockApps.all
    private(set) var filteredApps: [AppModel] = []
    
    
    var selectedCategory: AppCategory = .all {
        didSet { applyFilters() }
    }
    
    private var searchText: String = "" {
        didSet { applyFilters() }
    }
    
    var onUpdate: (() -> Void)?
    
    init() {
        filteredApps = allApps
    }
    
    func numberOfItems() -> Int {
        return filteredApps.count
    }
    
    func app(at index: Int) -> AppModel {
        return filteredApps[index]
    }
    
    func selectCategory(_ category: AppCategory) {
        selectedCategory = category
    }
    
    func bestSellerApps() -> [AppModel] {
        return allApps.sorted {
            if $0.rating == $1.rating {
                return $0.price > $1.price
            }
            return $0.rating > $1.rating
        }
    }
    
    func updateSearch(text: String) {
        let query = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        searchText = query
        
        if query.isEmpty {
            selectedCategory = .all
            return
        }
        
        let searchResults = allApps.filter { app in
            app.name.lowercased().contains(query)
        }
        
        let categoriesInResults = Array(Set(searchResults.map { $0.category }))
        
        if categoriesInResults.count == 1, let onlyCategory = categoriesInResults.first {
            selectedCategory = onlyCategory
        } else {
            selectedCategory = .all
        }
    }
    
    private func applyFilters() {
        
        var result = allApps
        if selectedCategory != .all {
            result = result.filter { $0.category == selectedCategory }
        }
        
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.lowercased().contains(searchText)
            }
        }
        
        filteredApps = result
        onUpdate?()
    }
}

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

    func updateSearch(text: String) {
        searchText = text.lowercased()
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

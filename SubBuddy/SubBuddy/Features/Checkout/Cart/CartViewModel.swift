//
//  CartViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import Foundation

final class CartViewModel {

    static let shared = CartViewModel()

    private init() {
        CartManager.shared.onUpdate = { [weak self] in
            self?.onUpdate?()
        }
    }


    var onUpdate: (() -> Void)?

    private var selectedIndexes: Set<Int> = []


    var itemCount: Int {
        CartManager.shared.items.count
    }

    func item(at index: Int) -> CartItem {
        CartManager.shared.items[index]
    }

    func removeApp(at index: Int) {

        CartManager.shared.remove(at: index)

        selectedIndexes = selectedIndexes
            .filter { $0 != index }
            .map { $0 > index ? $0 - 1 : $0 }
            .reduce(into: Set<Int>()) { $0.insert($1) }

        onUpdate?()
    }


    func toggleSelect(at index: Int) {

        if selectedIndexes.contains(index) {
            selectedIndexes.remove(index)
        } else {
            selectedIndexes.insert(index)
        }

        onUpdate?()
    }

    func isSelected(at index: Int) -> Bool {
        selectedIndexes.contains(index)
    }

    func selectAll() {
        selectedIndexes = Set(0..<itemCount)
        onUpdate?()
    }

    func clearSelection() {
        selectedIndexes.removeAll()
        onUpdate?()
    }

    var allSelected: Bool {
        itemCount > 0 && selectedIndexes.count == itemCount
    }


    var selectedItems: [CartItem] {
        let items = CartManager.shared.items
        return selectedIndexes.compactMap { index in
            guard index < items.count else { return nil }
            return items[index]
        }
    }


    var totalPrice: Double {
        selectedItems.reduce(0) { $0 + $1.price }
    }
}

//
//  CheckoutViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

final class CheckoutViewModel {

    private(set) var items: [CartItem]

    init(items: [CartItem]) {
        self.items = items
    }

    var totalPrice: Double {
        items.reduce(0) { $0 + $1.price }
    }

    func removeItem(at index: Int) {
        items.remove(at: index)
    }
}

//
//  UIViewController+Keyboard.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit

extension UIViewController {

    func enableKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

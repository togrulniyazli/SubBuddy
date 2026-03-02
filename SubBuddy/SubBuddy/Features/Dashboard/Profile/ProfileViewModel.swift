//
//  ProfileViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 24.02.26.
//

import Foundation
import FirebaseAuth

final class ProfileViewModel {

    private(set) var fullName: String = ""
    private(set) var email: String = ""
    private(set) var profileImageURL: String = ""

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    func load() {
        UserService.shared.fetchUserProfile { [weak self] result in
            guard let self else { return }

            switch result {

            case .success(let data):

                let first = (data["firstName"] as? String) ?? ""
                let last  = (data["lastName"] as? String) ?? ""

                self.fullName = ([first, last]
                    .filter { !$0.isEmpty }
                    .joined(separator: " "))

                self.email = (data["email"] as? String) ?? ""
                self.profileImageURL = (data["profileImageURL"] as? String) ?? ""

                self.onUpdate?()

            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func logout() {
        do {
            try AuthService.shared.signOut()
            SceneDelegate.shared?.switchToSignIn()
        } catch {
            onError?(error.localizedDescription)
        }
    }
}

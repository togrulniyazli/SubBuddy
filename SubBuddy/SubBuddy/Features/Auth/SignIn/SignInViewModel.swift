//
//  SignInViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 15.02.26.
//

import Foundation
import FirebaseAuth

final class SignInViewModel {

    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard !email.isEmpty else {
            completion(.failure(NSError(
                domain: "SignIn",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Email cannot be empty"
                ]
            )))
            return
        }

        guard !password.isEmpty else {
            completion(.failure(NSError(
                domain: "SignIn",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Password cannot be empty"
                ]
            )))
            return
        }

        AuthService.shared.signIn(
            email: email,
            password: password
        ) { result in

            switch result {

            case .success:

                guard let user = Auth.auth().currentUser else {

                    completion(.failure(NSError(
                        domain: "SignIn",
                        code: 0,
                        userInfo: [
                            NSLocalizedDescriptionKey: "User not found"
                        ]
                    )))

                    return
                }

               
                user.reload { error in

                    if let error {

                        completion(.failure(error))
                        return
                    }

                    if !user.isEmailVerified {

                        do {
                            try Auth.auth().signOut()
                        } catch {
                        }

                        completion(.failure(NSError(
                            domain: "SignIn",
                            code: 0,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                "Please verify your email before signing in."
                            ]
                        )))

                        return
                    }

                    completion(.success(()))
                }

            case .failure(let error):

                completion(.failure(error))
            }
        }
    }
}

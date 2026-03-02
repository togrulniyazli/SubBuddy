//
//  AuthService.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 15.02.26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class AuthService {

    static let shared = AuthService()

    private let auth = Auth.auth()
    private let db = Firestore.firestore()

    private init() {}


    var currentUser: User? {
        return auth.currentUser
    }

    var isLoggedIn: Bool {
        return auth.currentUser != nil
    }


    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        auth.createUser(withEmail: email, password: password) { [weak self] result, error in

            DispatchQueue.main.async {

                if let error = error as NSError? {

                    let message: String

                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        message = "This email is already in use"
                    case AuthErrorCode.invalidEmail.rawValue:
                        message = "Invalid email address"
                    case AuthErrorCode.weakPassword.rawValue:
                        message = "Password is too weak"
                    default:
                        message = error.localizedDescription
                    }

                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: error.code,
                        userInfo: [NSLocalizedDescriptionKey: message]
                    )))
                    return
                }

                guard let uid = result?.user.uid else {
                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "User creation failed"]
                    )))
                    return
                }

                self?.db.collection("users").document(uid).setData([
                    "email": email,
                    "createdAt": Timestamp(date: Date())
                ]) { error in

                    DispatchQueue.main.async {

                        if let error = error {
                            completion(.failure(error))
                            return
                        }

                        completion(.success(()))
                    }
                }
            }
        }
    }


    func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        auth.signIn(withEmail: email, password: password) { result, error in

            DispatchQueue.main.async {

                if let error = error as NSError? {

                    let message: String

                    switch error.code {
                    case AuthErrorCode.userNotFound.rawValue:
                        message = "User not found"
                    case AuthErrorCode.wrongPassword.rawValue:
                        message = "Incorrect password"
                    case AuthErrorCode.invalidEmail.rawValue:
                        message = "Invalid email address"
                    default:
                        message = error.localizedDescription
                    }

                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: error.code,
                        userInfo: [NSLocalizedDescriptionKey: message]
                    )))
                    return
                }

                guard result?.user != nil else {
                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Login failed"]
                    )))
                    return
                }

                completion(.success(()))
            }
        }
    }


    func signOut() throws {
        try auth.signOut()
    }

    func resetPassword(
        email: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        auth.sendPasswordReset(withEmail: email) { error in

            DispatchQueue.main.async {

                if let error = error as NSError? {

                    let message: String

                    switch error.code {
                    case AuthErrorCode.userNotFound.rawValue:
                        message = "No account found with this email"
                    case AuthErrorCode.invalidEmail.rawValue:
                        message = "Invalid email address"
                    default:
                        message = error.localizedDescription
                    }

                    completion(.failure(NSError(
                        domain: "AuthService",
                        code: error.code,
                        userInfo: [NSLocalizedDescriptionKey: message]
                    )))
                    return
                }

                completion(.success(()))
            }
        }
    }
}

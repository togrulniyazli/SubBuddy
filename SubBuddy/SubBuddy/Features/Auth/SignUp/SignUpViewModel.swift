//
//  SignUpViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 15.02.26.
//

import Foundation

final class SignUpViewModel {

    func signUp(
        email: String,
        password: String,
        confirmPassword: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        if !isValidEmail(email) {
            completion(.failure(simpleError("Enter valid email")))
            return
        }

        if !isValidPassword(password) {
            completion(.failure(simpleError(
                "Password must be 8+ characters, include uppercase, number and special character"
            )))
            return
        }

        if password != confirmPassword {
            completion(.failure(simpleError("Passwords do not match")))
            return
        }

        AuthService.shared.signUp(
            email: email,
            password: password
        ) { result in
            completion(result)
        }
    }
}


extension SignUpViewModel {

    func isValidEmail(_ email: String) -> Bool {

        if email.contains("@") && email.contains(".") {
            return true
        }

        return false
    }

    func isValidPassword(_ password: String) -> Bool {

        if password.count < 8 {
            return false
        }

        var hasUppercase = false
        var hasNumber = false
        var hasSpecial = false

        for char in password {

            if char.isUppercase {
                hasUppercase = true
            }

            if char.isNumber {
                hasNumber = true
            }

            if "!@#$%^&*()_+-=[]{}|;:',.<>?/".contains(char) {
                hasSpecial = true
            }
        }

        return hasUppercase && hasNumber && hasSpecial
    }

    func simpleError(_ message: String) -> Error {

        return NSError(
            domain: "",
            code: 0,
            userInfo: [
                NSLocalizedDescriptionKey: message
            ]
        )
    }
}

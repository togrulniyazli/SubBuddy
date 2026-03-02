//
//  CompleteProfileViewModel.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 18.02.26.
//

import Foundation

final class CompleteProfileViewModel {

    func saveProfile(
        firstName: String,
        lastName: String,
        birthDate: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {

        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {

            completion(.failure(NSError(
                domain: "",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "First name cannot be empty"
                ]
            )))

            return
        }

        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {

            completion(.failure(NSError(
                domain: "",
                code: 0,
                userInfo: [
                    NSLocalizedDescriptionKey: "Last name cannot be empty"
                ]
            )))

            return
        }

        UserService.shared.createUserProfile(
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate
        ) { result in

            DispatchQueue.main.async {

                completion(result)

            }
        }

    }

}

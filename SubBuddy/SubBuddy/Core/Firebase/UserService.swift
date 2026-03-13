//
//  UserService.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 18.02.26.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserService {
    
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    func createUserProfile(
        firstName: String,
        lastName: String,
        birthDate: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(
                domain: "UserService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )))
            return
        }
        
        let data: [String: Any] = [
            "uid": user.uid,
            "email": user.email ?? "",
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": Timestamp(date: birthDate),
            "createdAt": Timestamp(date: Date())
        ]
        
        db.collection("users")
            .document(user.uid)
            .setData(data, merge: true) { error in
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
    }
    
    func checkUserProfileExists(
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "UserService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )))
            return
        }
        
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = snapshot?.data() else {
                        completion(.success(false))
                        return
                    }
                    
                    let hasFirstName = !(data["firstName"] as? String ?? "").isEmpty
                    completion(.success(hasFirstName))
                }
            }
    }
    
    func fetchUserProfile(
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "UserService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )))
            return
        }
        
        db.collection("users")
            .document(uid)
            .getDocument { snapshot, error in
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    
                    guard let data = snapshot?.data() else {
                        completion(.failure(NSError(
                            domain: "UserService",
                            code: -2,
                            userInfo: [NSLocalizedDescriptionKey: "User profile not found"]
                        )))
                        return
                    }
                    
                    completion(.success(data))
                }
            }
    }
    
    func updateProfileImageURL(
        _ url: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(
                domain: "UserService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "User not logged in"]
            )))
            return
        }
        
        db.collection("users")
            .document(uid)
            .setData([
                "profileImageURL": url,
                "updatedAt": Timestamp(date: Date())
            ], merge: true) { error in
                DispatchQueue.main.async {
                    if let error {
                        completion(.failure(error))
                        return
                    }
                    completion(.success(()))
                }
            }
    }
}

//
//  LocalUserStore.swift
//  Wishmart
//
//  Created by Ricky Vishwas on 27/02/26.
//

import Foundation

enum LocalUserStore {
    private static let emailKey = "user_email"

    static func saveEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: emailKey)
    }

    static func getEmail() -> String? {
        UserDefaults.standard.string(forKey: emailKey)
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: emailKey)
    }
}

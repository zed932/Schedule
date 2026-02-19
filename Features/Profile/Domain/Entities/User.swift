//
//  User.swift
//  Schedule
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let group: String
    let email: String?
    let avatarImageName: String?
}

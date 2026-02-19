//
//  ProfileRepositoryProtocol.swift
//  Schedule
//

import Foundation

protocol ProfileRepositoryProtocol {
    func loadProfile() async -> User?
}

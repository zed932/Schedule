//
//  ProfileLocalDataSource.swift
//  Schedule
//

import Foundation

protocol ProfileLocalDataSourceProtocol {
    func fetchProfile() async -> User?
}

final class ProfileLocalDataSource: ProfileLocalDataSourceProtocol {
    func fetchProfile() async -> User? {
        await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "user", withExtension: "json") else {
                return nil
            }
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode(User.self, from: data)
            } catch {
                return nil
            }
        }.value
    }
}

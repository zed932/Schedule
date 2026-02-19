//
//  ProfileRepository.swift
//  Schedule
//

import Foundation

final class ProfileRepository: ProfileRepositoryProtocol {
    private let dataSource: ProfileLocalDataSourceProtocol

    init(dataSource: ProfileLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func loadProfile() async -> User? {
        await dataSource.fetchProfile()
    }
}

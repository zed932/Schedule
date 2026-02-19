//
//  TeachersRepository.swift
//  Schedule
//

import Foundation

final class TeachersRepository: TeachersRepositoryProtocol {
    private let dataSource: TeachersLocalDataSourceProtocol

    init(dataSource: TeachersLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func loadTeachers() async -> [Teacher] {
        await dataSource.fetchTeachers()
    }
}

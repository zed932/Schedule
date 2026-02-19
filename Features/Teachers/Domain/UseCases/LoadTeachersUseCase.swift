//
//  LoadTeachersUseCase.swift
//  Schedule
//

import Foundation

protocol LoadTeachersUseCaseProtocol {
    func execute() async -> [Teacher]
}

final class LoadTeachersUseCase: LoadTeachersUseCaseProtocol {
    private let repository: TeachersRepositoryProtocol

    init(repository: TeachersRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> [Teacher] {
        await repository.loadTeachers()
    }
}

//
//  LoadProfileUseCase.swift
//  Schedule
//

import Foundation

protocol LoadProfileUseCaseProtocol {
    func execute() async -> User?
}

final class LoadProfileUseCase: LoadProfileUseCaseProtocol {
    private let repository: ProfileRepositoryProtocol

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> User? {
        await repository.loadProfile()
    }
}

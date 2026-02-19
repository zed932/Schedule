//
//  LoadScheduleUseCase.swift
//  Schedule
//

import Foundation

protocol LoadScheduleUseCaseProtocol {
    func execute() async -> Schedule
}

final class LoadScheduleUseCase: LoadScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol

    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> Schedule {
        await repository.loadSchedule()
    }
}

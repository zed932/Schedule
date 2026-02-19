//
//  ScheduleRepository.swift
//  Schedule
//

import Foundation

final class ScheduleRepository: ScheduleRepositoryProtocol {
    private let dataSource: ScheduleLocalDataSourceProtocol

    init(dataSource: ScheduleLocalDataSourceProtocol) {
        self.dataSource = dataSource
    }

    func loadSchedule() async -> Schedule {
        await dataSource.fetchSchedule()
    }
}

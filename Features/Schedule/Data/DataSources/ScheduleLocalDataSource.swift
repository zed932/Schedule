//
//  ScheduleLocalDataSource.swift
//  Schedule
//

import Foundation

protocol ScheduleLocalDataSourceProtocol {
    func fetchSchedule() async -> Schedule
}

final class ScheduleLocalDataSource: ScheduleLocalDataSourceProtocol {
    func fetchSchedule() async -> Schedule {
        let data: Data? = await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "schedule", withExtension: "json") else {
                return nil
            }
            return try? Data(contentsOf: url)
        }.value

        guard let data else { return MockSchedule.schedule }

        return await MainActor.run {
            (try? JSONDecoder().decode(Schedule.self, from: data)) ?? MockSchedule.schedule
        }
    }
}

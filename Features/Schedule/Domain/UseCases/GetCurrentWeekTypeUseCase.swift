//
//  GetCurrentWeekTypeUseCase.swift
//  Schedule
//

import Foundation

protocol GetCurrentWeekTypeUseCaseProtocol {
    func execute() -> WeekType
}

final class GetCurrentWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol {
    private let weekCounter: WeekCounter

    init(weekCounter: WeekCounter = WeekCounter()) {
        self.weekCounter = weekCounter
    }

    func execute() -> WeekType {
        weekCounter.getWeektype()
    }
}

//
//  WeekCounter.swift
//  Schedule
//

import Foundation

final class WeekCounter {
    func getCurrentWeek() -> Int {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2026
        components.month = 2
        components.day = 9
        components.hour = 12
        components.minute = 0

        guard let startDate = calendar.date(from: components) else { return 1 }
        let difference = calendar.dateComponents([.day], from: startDate, to: Date())
        return max(1, (difference.day ?? 0) / 7 + 1)
    }

    func getWeektype() -> WeekType {
        let week = getCurrentWeek()
        if week.isMultiple(of: 2) { return .even }
        if week.isMultiple(of: 8) || week.isMultiple(of: 14) { return .control }
        return .odd
    }
}

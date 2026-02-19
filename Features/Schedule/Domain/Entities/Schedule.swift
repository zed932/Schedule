//
//  Schedule.swift
//  Schedule
//
//  Entity: корневая модель расписания.
//

import Foundation

struct Schedule: Codable {
    let oddWeek: WeekSchedule
    let evenWeek: WeekSchedule
}

struct WeekSchedule: Codable {
    let days: [DaySchedule]
}

struct DaySchedule: Codable {
    let weekday: Int
    let date: String?
    let slots: [Slot]
}

struct Slot: Codable {
    let pairNumber: Int
    let startTime: String
    let endTime: String
    let lesson: Lesson?
    let windowMessage: String?
}

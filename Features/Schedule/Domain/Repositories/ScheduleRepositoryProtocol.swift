//
//  ScheduleRepositoryProtocol.swift
//  Schedule
//

import Foundation

protocol ScheduleRepositoryProtocol {
    func loadSchedule() async -> Schedule
}

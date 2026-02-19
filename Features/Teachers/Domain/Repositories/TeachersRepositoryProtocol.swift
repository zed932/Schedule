//
//  TeachersRepositoryProtocol.swift
//  Schedule
//

import Foundation

protocol TeachersRepositoryProtocol {
    func loadTeachers() async -> [Teacher]
}

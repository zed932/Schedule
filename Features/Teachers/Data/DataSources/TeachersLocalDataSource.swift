//
//  TeachersLocalDataSource.swift
//  Schedule
//

import Foundation

private struct TeachersResponse: Codable {
    let teachers: [Teacher]
}

protocol TeachersLocalDataSourceProtocol {
    func fetchTeachers() async -> [Teacher]
}

final class TeachersLocalDataSource: TeachersLocalDataSourceProtocol {
    func fetchTeachers() async -> [Teacher] {
        let data: Data? = await Task.detached(priority: .userInitiated) {
            guard let url = Bundle.main.url(forResource: "teachers", withExtension: "json") else {
                return nil
            }
            return try? Data(contentsOf: url)
        }.value

        guard let data else { return [] }

        // Декодируем на MainActor, чтобы строки были в правильном контексте памяти
        return await MainActor.run {
            (try? JSONDecoder().decode(TeachersResponse.self, from: data))?.teachers ?? []
        }
    }
}

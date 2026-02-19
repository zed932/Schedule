//
//  TeachersViewModel.swift
//  Schedule
//

import Foundation

final class TeachersViewModel {

    var onTeachersLoaded: (() -> Void)?

    private var teachers: [Teacher] = []
    private let loadTeachersUseCase: LoadTeachersUseCaseProtocol

    init(loadTeachersUseCase: LoadTeachersUseCaseProtocol) {
        self.loadTeachersUseCase = loadTeachersUseCase
    }

    var teachersCount: Int { teachers.count }

    func teacher(at index: Int) -> Teacher? {
        guard index >= 0, index < teachers.count else { return nil }
        return teachers[index]
    }

    func loadTeachers() {
        Task {
            let loaded = await loadTeachersUseCase.execute()
            await MainActor.run {
                self.teachers = loaded
                self.onTeachersLoaded?()
            }
        }
    }
}

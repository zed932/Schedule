//
//  DependencyContainer.swift
//  Schedule
//
//  DI-контейнер. Собирает зависимости для всего приложения.
//

import Foundation
import UIKit

final class DependencyContainer {

    static let shared = DependencyContainer()

    private init() {}

    // MARK: - Schedule

    lazy var scheduleDataSource: ScheduleLocalDataSourceProtocol = ScheduleLocalDataSource()
    lazy var scheduleRepository: ScheduleRepositoryProtocol = ScheduleRepository(dataSource: scheduleDataSource)
    lazy var loadScheduleUseCase: LoadScheduleUseCaseProtocol = LoadScheduleUseCase(repository: scheduleRepository)
    lazy var getWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol = GetCurrentWeekTypeUseCase()

    // MARK: - Notes

    lazy var notesRepository: NotesRepositoryProtocol = NotesUserDefaultsDataSource()
    lazy var getNoteUseCase: GetNoteUseCaseProtocol = GetNoteUseCase(repository: notesRepository)
    lazy var saveNoteUseCase: SaveNoteUseCaseProtocol = SaveNoteUseCase(repository: notesRepository)

    // MARK: - Teachers

    lazy var teachersDataSource: TeachersLocalDataSourceProtocol = TeachersLocalDataSource()
    lazy var teachersRepository: TeachersRepositoryProtocol = TeachersRepository(dataSource: teachersDataSource)
    lazy var loadTeachersUseCase: LoadTeachersUseCaseProtocol = LoadTeachersUseCase(repository: teachersRepository)

    // MARK: - Profile

    lazy var profileDataSource: ProfileLocalDataSourceProtocol = ProfileLocalDataSource()
    lazy var profileRepository: ProfileRepositoryProtocol = ProfileRepository(dataSource: profileDataSource)
    lazy var loadProfileUseCase: LoadProfileUseCaseProtocol = LoadProfileUseCase(repository: profileRepository)

    // MARK: - Factory

    func makeScheduleViewModel() -> ScheduleViewModel {
        ScheduleViewModel(
            loadScheduleUseCase: loadScheduleUseCase,
            getWeekTypeUseCase: getWeekTypeUseCase,
            getNoteUseCase: getNoteUseCase
        )
    }

    func makeScheduleCoordinator(viewController: UIViewController) -> ScheduleCoordinator {
        ScheduleCoordinator(viewController: viewController, saveNoteUseCase: saveNoteUseCase)
    }

    /// Создаёт полностью сконфигурированный ScheduleViewController.
    /// Гарантирует вызов configure до возврата.
    func makeScheduleViewController() -> ScheduleViewController {
        let scheduleVC = ScheduleViewController()
        scheduleVC.configure(
            viewModel: makeScheduleViewModel(),
            coordinator: makeScheduleCoordinator(viewController: scheduleVC)
        )
        return scheduleVC
    }

    func makeTeachersViewModel() -> TeachersViewModel {
        TeachersViewModel(loadTeachersUseCase: loadTeachersUseCase)
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(loadProfileUseCase: loadProfileUseCase)
    }
}

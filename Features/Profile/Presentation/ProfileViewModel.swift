//
//  ProfileViewModel.swift
//  Schedule
//

import Foundation

final class ProfileViewModel {

    var onProfileLoaded: (() -> Void)?

    private var user: User?
    private let loadProfileUseCase: LoadProfileUseCaseProtocol

    init(loadProfileUseCase: LoadProfileUseCaseProtocol) {
        self.loadProfileUseCase = loadProfileUseCase
    }

    var userName: String { user?.name ?? "Пользователь" }
    var userGroup: String { user?.group ?? "—" }
    var userEmail: String { user?.email ?? "—" }

    func loadProfile() {
        Task {
            let loaded = await loadProfileUseCase.execute()
            await MainActor.run {
                self.user = loaded
                self.onProfileLoaded?()
            }
        }
    }
}

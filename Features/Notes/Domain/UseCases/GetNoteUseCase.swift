//
//  GetNoteUseCase.swift
//  Schedule
//

import Foundation

protocol GetNoteUseCaseProtocol {
    func execute(for slotKey: String) -> String?
}

final class GetNoteUseCase: GetNoteUseCaseProtocol {
    private let repository: NotesRepositoryProtocol

    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(for slotKey: String) -> String? {
        repository.getNote(for: slotKey)
    }
}

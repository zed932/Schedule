//
//  SaveNoteUseCase.swift
//  Schedule
//

import Foundation

protocol SaveNoteUseCaseProtocol {
    func execute(text: String, for slotKey: String)
}

final class SaveNoteUseCase: SaveNoteUseCaseProtocol {
    private let repository: NotesRepositoryProtocol

    init(repository: NotesRepositoryProtocol) {
        self.repository = repository
    }

    func execute(text: String, for slotKey: String) {
        repository.saveNote(text, for: slotKey)
    }
}

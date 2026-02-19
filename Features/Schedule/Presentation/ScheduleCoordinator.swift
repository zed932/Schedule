//
//  ScheduleCoordinator.swift
//  Schedule
//

import UIKit

protocol ScheduleCoordinatorProtocol: AnyObject {
    func showNoteModal(slotKey: String, initialText: String, onSave: @escaping (String) -> Void)
}

final class ScheduleCoordinator: ScheduleCoordinatorProtocol {
    private weak var viewController: UIViewController?
    private let saveNoteUseCase: SaveNoteUseCaseProtocol

    init(viewController: UIViewController, saveNoteUseCase: SaveNoteUseCaseProtocol) {
        self.viewController = viewController
        self.saveNoteUseCase = saveNoteUseCase
    }

    func showNoteModal(slotKey: String, initialText: String, onSave: @escaping (String) -> Void) {
        let modal = NoteModalViewController(
            slotKey: slotKey,
            initialText: initialText,
            saveNoteUseCase: saveNoteUseCase,
            onSave: onSave
        )
        modal.modalPresentationStyle = .overFullScreen
        modal.modalTransitionStyle = .crossDissolve
        viewController?.present(modal, animated: true)
    }
}

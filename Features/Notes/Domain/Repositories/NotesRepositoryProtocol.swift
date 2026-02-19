//
//  NotesRepositoryProtocol.swift
//  Schedule
//

import Foundation

protocol NotesRepositoryProtocol {
    func getNote(for slotKey: String) -> String?
    func saveNote(_ text: String, for slotKey: String)
}

//
//  NotesUserDefaultsDataSource.swift
//  Schedule
//

import Foundation

final class NotesUserDefaultsDataSource: NotesRepositoryProtocol {
    private let key = "schedule_notes"

    func getNote(for slotKey: String) -> String? {
        loadFromUserDefaults()[slotKey]
    }

    func saveNote(_ text: String, for slotKey: String) {
        var dict = loadFromUserDefaults()
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            dict.removeValue(forKey: slotKey)
        } else {
            dict[slotKey] = text
        }
        saveToUserDefaults(dict)
    }

    private func loadFromUserDefaults() -> [String: String] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let dict = try? JSONDecoder().decode([String: String].self, from: data) else {
            return [:]
        }
        return dict
    }

    private func saveToUserDefaults(_ dict: [String: String]) {
        guard let data = try? JSONEncoder().encode(dict) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}

//
// JournalStorage.swift : StudyNotes
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.


import Foundation

final class JournalStorage {
    private let entriesKey = "journal_entries"

    func saveEntries(_ entries: [JournalEntry]) throws {
        let data = try JSONEncoder().encode(entries)
        UserDefaults.standard.set(data, forKey: entriesKey)
    }

    func loadEntries() throws -> [JournalEntry] {
        guard let data = UserDefaults.standard.data(forKey: entriesKey) else {
            return []
        }
        return try JSONDecoder().decode([JournalEntry].self, from: data)
            .sorted { $0.createdAt > $1.createdAt }
    }
}

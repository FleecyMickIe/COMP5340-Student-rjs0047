//
// JournalEntry.swift : StudyNotes
//
// Copyright © 2026 Auburn University.
// All Rights Reserved.


import Foundation

enum CourseCategory: String, Codable, CaseIterable, Identifiable {
    case computerScience = "Computer Science"
    case mathematics = "Mathematics"
    case general = "General"
    case other = "Other"

    var id: String { rawValue }
}

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    let title: String
    let course: CourseCategory
    let text: String
    let createdAt: Date

    init(id: UUID = UUID(), title: String, course: CourseCategory,
         text: String, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.course = course
        self.text = text
        self.createdAt = createdAt
    }

    // Older StudyNotes entries have no title or course. Keep them readable.
    private enum CodingKeys: String, CodingKey {
        case id, title, course, text, createdAt
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        text = try values.decode(String.self, forKey: .text)
        createdAt = try values.decode(Date.self, forKey: .createdAt)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? "Imported note"
        course = try values.decodeIfPresent(CourseCategory.self, forKey: .course) ?? .general
    }
}

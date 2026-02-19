//
//  Lesson.swift
//  Schedule
//
//  Entity: тип занятия и модель урока.
//

import Foundation

enum LessonType: String, Codable, CaseIterable {
    case lecture
    case practice
    case lab
}

struct Lesson: Codable {
    let name: String
    let type: LessonType
    let teacher: Teacher
    let room: String?
    var time: Date?
}

struct Teacher: Codable {

    let id: String
    let name: String
    let subject: String?
    let email: String?
    let imageName: String?
    /// Подробное описание от студентов (для карточки преподавателя)
    let description: String?
    /// Отмечает ли посещение: "yes", "no", "sometimes"
    let marksAttendance: String?
    /// Есть ли возможность получить автомат
    let hasAutomat: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, subject, email, imageName, description, marksAttendance, hasAutomat
    }

    init(
        id: String,
        name: String,
        subject: String? = nil,
        email: String? = nil,
        imageName: String? = nil,
        description: String? = nil,
        marksAttendance: String? = nil,
        hasAutomat: Bool? = nil
    ) {
        self.id = id
        self.name = name
        self.subject = subject
        self.email = email
        self.imageName = imageName
        self.description = description
        self.marksAttendance = marksAttendance
        self.hasAutomat = hasAutomat
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.init(
            id: Self.sanitize(try c.decode(String.self, forKey: .id)),
            name: Self.sanitize(try c.decode(String.self, forKey: .name)),
            subject: try c.decodeIfPresent(String.self, forKey: .subject).map(Self.sanitize),
            email: try c.decodeIfPresent(String.self, forKey: .email).map(Self.sanitize),
            imageName: try c.decodeIfPresent(String.self, forKey: .imageName).map(Self.sanitize),
            description: try c.decodeIfPresent(String.self, forKey: .description).map(Self.sanitize),
            marksAttendance: try c.decodeIfPresent(String.self, forKey: .marksAttendance).map(Self.sanitize),
            hasAutomat: try c.decodeIfPresent(Bool.self, forKey: .hasAutomat)
        )
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encodeIfPresent(subject, forKey: .subject)
        try c.encodeIfPresent(email, forKey: .email)
        try c.encodeIfPresent(imageName, forKey: .imageName)
        try c.encodeIfPresent(description, forKey: .description)
        try c.encodeIfPresent(marksAttendance, forKey: .marksAttendance)
        try c.encodeIfPresent(hasAutomat, forKey: .hasAutomat)
    }

    /// Удаляет управляющие символы (U+0000–U+001F, U+007F–U+009F), вызывающие EXC_BAD_ACCESS
    private nonisolated static func sanitize(_ s: String) -> String {
        String(s.unicodeScalars.filter { scalar in
            let v = scalar.value
            return v > 0x1F && (v < 0x7F || v > 0x9F)
        })
    }
}

//
//  MockSchedule.swift
//  Schedule
//

import Foundation

enum MockSchedule {
    private static let mockTeacher = Teacher(
        id: "mock",
        name: "Преподаватель",
        subject: nil,
        email: nil,
        imageName: nil,
        description: nil,
        marksAttendance: nil,
        hasAutomat: nil
    )

    static var schedule: Schedule {
        Schedule(
            oddWeek: WeekSchedule(days: makeDays(for: "нч")),
            evenWeek: WeekSchedule(days: makeDays(for: "чн"))
        )
    }

    private static func makeDays(for weekLabel: String) -> [DaySchedule] {
        (1...6).map { weekday in
            DaySchedule(
                weekday: weekday,
                date: nil,
                slots: makeSlots(for: weekday, label: weekLabel)
            )
        }
    }

    private static let slotTimes: [(String, String)] = [
        ("08:00", "09:35"),
        ("09:45", "11:20"),
        ("11:35", "13:10"),
        ("13:40", "15:15"),
        ("15:25", "17:00"),
        ("17:10", "18:45"),
        ("18:55", "20:30")
    ]

    private static func makeSlots(for weekday: Int, label: String) -> [Slot] {
        let names = [
            "Математика",
            "Программирование",
            "Физика",
            "Английский язык",
            "Физкультура",
            "Информатика"
        ]
        return (1...7).map { i in
            let (start, end) = slotTimes[i - 1]
            let hasLesson = (weekday + i) % 3 != 0
            return Slot(
                pairNumber: i,
                startTime: start,
                endTime: end,
                lesson: hasLesson ? Lesson(
                    name: names[(weekday + i) % names.count],
                    type: [LessonType.lecture, .practice, .lab][i % 3],
                    teacher: mockTeacher,
                    room: "\(3200 + weekday * 100 + i)",
                    time: nil
                ) : nil,
                windowMessage: hasLesson ? nil : "Окно"
            )
        }
    }
}

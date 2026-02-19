//
//  ScheduleViewModel.swift
//  Schedule
//

import Foundation

final class ScheduleViewModel {

    var onScheduleLoaded: (() -> Void)?

    private var schedule: Schedule?
    private var weekType: WeekType = .odd

    private let loadScheduleUseCase: LoadScheduleUseCaseProtocol
    private let getWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol
    private let getNoteUseCase: GetNoteUseCaseProtocol

    init(
        loadScheduleUseCase: LoadScheduleUseCaseProtocol,
        getWeekTypeUseCase: GetCurrentWeekTypeUseCaseProtocol,
        getNoteUseCase: GetNoteUseCaseProtocol
    ) {
        self.loadScheduleUseCase = loadScheduleUseCase
        self.getWeekTypeUseCase = getWeekTypeUseCase
        self.getNoteUseCase = getNoteUseCase
    }

    var currentDays: [DaySchedule] {
        guard let schedule = schedule else { return [] }
        return isOddWeek ? schedule.oddWeek.days : schedule.evenWeek.days
    }

    var isOddWeek: Bool {
        switch weekType {
        case .odd, .control: return true
        case .even: return false
        }
    }

    func loadSchedule() {
        Task {
            let loadedSchedule = await loadScheduleUseCase.execute()
            let loadedWeekType = getWeekTypeUseCase.execute()
            await MainActor.run {
                self.schedule = loadedSchedule
                self.weekType = loadedWeekType
                self.onScheduleLoaded?()
            }
        }
    }

    func visibleSlots(for day: DaySchedule) -> [Slot] {
        let slots = day.slots
        guard let first = slots.firstIndex(where: { $0.lesson != nil }),
              let last = slots.lastIndex(where: { $0.lesson != nil }) else {
            return []
        }
        return Array(slots[first...last])
    }

    func getNote(for slotKey: String) -> String? {
        getNoteUseCase.execute(for: slotKey)
    }
}

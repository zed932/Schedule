//
//  SlotKey.swift
//  Schedule
//
//  Утилита для формирования ключа слота.
//

import Foundation

func slotKey(isOddWeek: Bool, weekday: Int, pairNumber: Int) -> String {
    "\(isOddWeek ? "odd" : "even")_\(weekday)_\(pairNumber)"
}

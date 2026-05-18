//
//  Plant.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//
import Foundation

struct Plant {
    let id: UUID
    var name: String
    var species: String
    var startDate: Date
    var waterCycle: Int
    var diaries: [DiaryEntry]
    
    var dDay: Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let start = calendar.startOfDay(for: startDate)
        let components = calendar.dateComponents([.day], from: start, to: today)
        return (components.day ?? 0) + 1
    }
    
    init(name: String, species: String, startDate: Date, waterCycle: Int = 3) {
        self.id = UUID()
        self.name = name
        self.species = species
        self.startDate = startDate
        self.waterCycle = waterCycle
        self.diaries = []
    }
}

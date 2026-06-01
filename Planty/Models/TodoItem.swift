//
//  TodoItem.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import Foundation

struct TodoItem {
    let id: UUID
    var title: String
    var plantId: UUID?

    var isCompleted: Bool {
        get {
            guard let plantId = plantId else { return false }
            let key = "\(plantId.uuidString)_\(todayKey)"
            return UserDefaults.standard.bool(forKey: key)
        }
        set {
            guard let plantId = plantId else { return }
            let key = "\(plantId.uuidString)_\(todayKey)"
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
    
    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    init(title: String, plantId: UUID? = nil) {
        self.id = UUID()
        self.title = title
        self.plantId = plantId
    }
}

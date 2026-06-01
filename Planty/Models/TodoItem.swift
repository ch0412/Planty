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
    var isCompleted: Bool
    let plantId: UUID?
    
    init(title: String, isCompleted: Bool = false, plantId: UUID? = nil) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.plantId = plantId
    }
}

//
//  DiaryEntry.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import Foundation

struct DiaryEntry {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    
    init(title: String, content: String, date: Date) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
    }
}

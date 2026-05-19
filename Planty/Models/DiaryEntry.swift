//
//  DiaryEntry.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import Foundation
import UIKit

struct DiaryEntry {
    let id: UUID
    var title: String
    var content: String
    var date: Date
    var photoImages: [UIImage]
    
    init(title: String, content: String, date: Date, photoImages: [UIImage] = []) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.date = date
        self.photoImages = photoImages
    }
}

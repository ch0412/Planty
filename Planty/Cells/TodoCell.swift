//
//  TodoCell.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

class TodoCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with todo: TodoItem) {
        titleLabel.text = todo.title
        
        if todo.isCompleted {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill",
                                             withConfiguration: config)
            checkBoxImageView.tintColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0)
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
            checkBoxImageView.image = UIImage(systemName: "checkmark.square",
                                             withConfiguration: config)
            checkBoxImageView.tintColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0)
        }
    }
}

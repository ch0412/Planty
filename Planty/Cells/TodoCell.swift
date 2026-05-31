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
        titleLabel.textColor = .label
        checkBoxImageView.isHidden = false
        selectionStyle = .none
            
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        if todo.isCompleted {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill", withConfiguration: config)
        } else {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square", withConfiguration: config)
        }
        checkBoxImageView.tintColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0)
    }
    
    // 빈 상태 메시지
    func configureEmpty() {
        titleLabel.text = "오늘의 할 일이 없습니다."
        titleLabel.textColor = .systemGray
        checkBoxImageView.isHidden = true
        selectionStyle = .none
    }
}

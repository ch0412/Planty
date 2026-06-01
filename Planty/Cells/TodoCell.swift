//
//  TodoCell.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

// 오늘의 할 일 개별 셀 - 체크박스와 할 일 제목 표시
class TodoCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Configure
    // 외부에서 TodoItem 데이터를 받아 셀 UI에 반영
    func configure(with todo: TodoItem) {
        checkBoxImageView.isHidden = false
        
        // 완료 여부에 따라 체크박스 이미지 및 취소선 변경
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        if todo.isCompleted {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill", withConfiguration: config)
            // 취소선 추가
            let attributeString = NSAttributedString(
                string: todo.title,
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.attributedText = attributeString
            titleLabel.textColor = .systemGray
        } else {
            checkBoxImageView.image = UIImage(systemName: "checkmark.square", withConfiguration: config)
            // 취소선 제거
            titleLabel.attributedText = nil
            titleLabel.text = todo.title
            titleLabel.textColor = .label
        }
        checkBoxImageView.tintColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 1.0)
    }
    
    // MARK: - Empty State
    // 오늘의 할 일이 없을 때 빈 상태 메시지 표시
    func configureEmpty() {
        titleLabel.text = "오늘의 할 일이 없습니다."
        titleLabel.textColor = .systemGray
        checkBoxImageView.isHidden = true
    }
}

//
//  DiaryCell.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import UIKit

// 일지 목록 개별 셀 - 카드 형태로 표시(제목, 날짜, 내용, 사진)
class DiaryCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
    }
    
    // MARK: - Configure
    // 외부에서 DiaryEntry 데이터를 받아 셀 UI에 반영
    func configure(with diary: DiaryEntry) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yy.MM.dd."
        let dateString = formatter.string(from: diary.date)
        
        titleLabel.text = "\(diary.title) - \(dateString)"
        contentLabel.text = diary.content
        
        if let image = diary.photoImages.first {
            diaryImageView.image = image
            diaryImageView.isHidden = false
            imageHeightConstraint.constant = 150
        } else {
            diaryImageView.isHidden = true
            imageHeightConstraint.constant = 0
        }
    }
}

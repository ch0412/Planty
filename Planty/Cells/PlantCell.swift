//
//  PlantCell.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

// 정원 목록 개별 셀 - 카드 형태로 표시 (별명, 품종, D+day)
class PlantCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    // MARK: - Setup
    private func setupStyle() {
        cardView.layer.shadowColor = UIColor.black.cgColor
    }
    
    // MARK: - Configure
    // 외부에서 Plant 데이터를 받아 셀 UI에 반영
    func configure(with plant: Plant) {
        nameLabel.text = plant.name
        speciesLabel.text = "품종: \(plant.species)"
        dDayLabel.text = "D + \(plant.dDay)"
    }
}

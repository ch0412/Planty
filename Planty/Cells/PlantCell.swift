//
//  PlantCell.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

class PlantCell: UITableViewCell {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    private func setupStyle() {
        // 카드 스타일
        cardView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func configure(with plant: Plant) {
        nameLabel.text = plant.name
        speciesLabel.text = "품종: \(plant.species)"
        dDayLabel.text = "D + \(plant.dDay)"
    }
}

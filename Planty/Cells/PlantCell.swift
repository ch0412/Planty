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
    @IBOutlet weak var dDayContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }
    
    private func setupStyle() {
        // 카드 스타일
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 6
        cardView.layer.shadowOpacity = 0.08
        
        dDayContainer.layer.borderColor = UIColor(red: 0.6, green: 0.85, blue: 0.6, alpha: 1.0).cgColor
    }
    
    func configure(with plant: Plant) {
        nameLabel.text = plant.name
        speciesLabel.text = "품종: \(plant.species)"
        dDayLabel.text = "D + \(plant.dDay)"
        dDayLabel.textColor = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)
    }
}

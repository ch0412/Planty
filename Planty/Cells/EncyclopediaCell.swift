//
//  EncyclopediaCell.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

// 식물 도감 컬렉션뷰의 개별 셀
class EncyclopediaCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Configuration
    // 외부에서 EncyclopdiaPlant 데이터를 받아 셀 UI에 반영
    func configure(with plant: EncyclopediaPlant) {
        nameLabel.text = plant.name
        
        // 에셋에 이미지 존재 시 해당 이미지를, 없을 시 기본 아이콘 출력
        if let image = UIImage(named: plant.imageName) {
            plantImageView.image = image
        } else {
            plantImageView.image = UIImage(systemName: "leaf.fill")
            plantImageView.contentMode = .center
        }
    }
    
    // MARK: - Interaction
    // 셀 터치 시 살짝 축소되는 햅틱 피드백 효과
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.transform = self.isHighlighted
                    ? CGAffineTransform(scaleX: 0.96, y: 0.96)
                    : .identity
            }
        }
    }
}

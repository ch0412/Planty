//
//  EncyclopediaCell.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

class EncyclopediaCell: UICollectionViewCell {
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with plant: EncyclopediaPlant) {
        // 정중앙 정렬 상태이므로 텍스트만 정직하게 입력
        nameLabel.text = plant.name
        
        if let image = UIImage(named: plant.imageName) {
            plantImageView.image = image
        } else {
            // 에셋에 실제 이미지가 없을 때 들어오는 기본 잎새 아이콘 설정
            plantImageView.image = UIImage(systemName: "leaf.fill")
            plantImageView.contentMode = .center
            plantImageView.tintColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0)
            plantImageView.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.9, alpha: 1.0)
        }
    }
    
    // 클릭 시 살짝 작아지는 애니메이션 리액션 (상호작용 로직이므로 코드 유지)
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

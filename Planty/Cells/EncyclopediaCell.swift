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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 셀 자체의 클리핑을 활성화하여 모서리가 잘 깎이도록 합니다.
        self.clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 1. 셀 전체 모서리 둥글게 (Figma 시안 느낌)
        self.layer.cornerRadius = 24
        plantImageView.layer.cornerRadius = 24
        
        // 2. 식물 이름 텍스트 칩 스타일 디자인
        nameLabel.backgroundColor = .white
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textAlignment = .center
        
        // 텍스트 레이블의 모서리도 살짝 깎아줍니다.
        nameLabel.layer.cornerRadius = 4
        nameLabel.clipsToBounds = true
    }
    
    func configure(with plant: EncyclopediaPlant) {
        // 💡 꿀팁: 글자 앞뒤로 공백을 넣어주면 별도의 패딩 구현 없이
        // 흰색 칩 양옆에 예쁘게 여백이 생깁니다.
        nameLabel.text = "   \(plant.name)   "
        
        if let image = UIImage(named: plant.imageName) {
            plantImageView.image = image
            plantImageView.contentMode = .scaleAspectFill // 이미지가 꽉 차도록
        } else {
            // 에셋에 실제 이미지가 없을 때 들어오는 기본 아이콘 설정
            plantImageView.image = UIImage(systemName: "leaf.fill")
            plantImageView.contentMode = .center
            plantImageView.tintColor = UIColor(red: 0.3, green: 0.6, blue: 0.3, alpha: 1.0)
            plantImageView.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.9, alpha: 1.0)
        }
    }
    
    // 클릭 시 살짝 작아지는 애니메이션 리액션
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

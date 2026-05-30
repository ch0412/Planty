//
//  PlantEncycDetailViewController.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

class PlantEncycDetailViewController: UIViewController {
    
    // MARK: - @IBOutlet Connection
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    
    // 격자 칩 내부의 '실제 데이터' 레이블들
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var waterCycleLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    // 하단 설명 및 독성 레이블
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toxicityLabel: UILabel!
    
    // MARK: - Properties
    var plant: EncyclopediaPlant?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        guard let plant = plant else { return }
        
        // 1. 상단 기본 정보 매핑
        title = plant.name
        nameLabel.text = plant.name
        scientificNameLabel.text = plant.scientificName
        
        // 2. 2x2 격자 칩 내부 데이터 매핑 (이모지와 타이틀은 스토리보드에 적어두었으므로 순수 데이터만 주입!)
        difficultyLabel.text = plant.difficulty
        waterCycleLabel.text = plant.waterCycle
        lightLabel.text = plant.light
        temperatureLabel.text = plant.temperature
        
        // 3. 특징 설명 매핑
        
        descriptionLabel.text = plant.description
        // 4. 독성 여부 디자인 매핑 (시안의 세련된 컬러 칩 반영)
        if plant.toxicity {
            toxicityLabel.text = "⚠️ 독성 있음"
            toxicityLabel.textColor = UIColor.systemRed
            // 독성이 있을 때: 연한 핑크빛 빨간 배경색
            toxicityLabel.backgroundColor = UIColor(red: 1.0, green: 0.92, blue: 0.92, alpha: 1.0)
        } else {
            
            toxicityLabel.text = "✅ 독성 없음"
            toxicityLabel.textColor = UIColor.systemGreen
            // 독성이 없을 때: 연한 연두빛 초록 배경색
            toxicityLabel.backgroundColor = UIColor(red: 0.92, green: 0.97, blue: 0.92, alpha: 1.0)
        }
        
        // 5. 이미지 뷰 안전 매핑
        if let image = UIImage(named: plant.imageName) {
            plantImageView.image = image
        } else {
            plantImageView.image = UIImage(systemName: "leaf.fill")
            plantImageView.tintColor = .systemGreen
        }
    }
    
    // MARK: - Actions
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

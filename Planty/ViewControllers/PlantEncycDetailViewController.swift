//
//  PlantEncycDetailViewController.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

// 식물 도감 상세 화면 - 선택한 식물의 상세 정보 표시
class PlantEncycDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var waterCycleLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
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
    // 전달받은 식물 데이터를 각 UI 요소에 반영
    private func configureUI() {
        guard let plant = plant else { return }
        
        // 기본 정보
        title = plant.name
        nameLabel.text = plant.name
        scientificNameLabel.text = plant.scientificName
        
        // 2x2 격자 칩 데이터
        difficultyLabel.text = plant.difficulty
        waterCycleLabel.text = plant.waterCycle
        lightLabel.text = plant.light
        temperatureLabel.text = plant.temperature
        
        // 특징 설명
        descriptionLabel.text = plant.description
        
        // 독성 여부에 따라 다르게 분기
        if plant.toxicity {
            toxicityLabel.text = "⚠️ 독성 있음"
            toxicityLabel.textColor = UIColor.systemRed
            toxicityLabel.backgroundColor = UIColor(red: 1.0, green: 0.92, blue: 0.92, alpha: 1.0)
        } else {
            toxicityLabel.text = "✅ 독성 없음"
            toxicityLabel.textColor = UIColor.systemGreen
            toxicityLabel.backgroundColor = UIColor(red: 0.92, green: 0.97, blue: 0.92, alpha: 1.0)
        }
        
        // 에셋에 이미지 존재 시 해당 이미지를, 없을 시 기본 아이콘 출력
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

//
//  PlantEncycDetailViewController.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

class PlantEncycDetailViewController: UIViewController {
    
    var plant: EncyclopediaPlant?
    
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scientificNameLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var waterCycleLabel: UILabel!
    @IBOutlet weak var lightLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var toxicityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        guard let plant = plant else { return }
        
        title = plant.name
        nameLabel.text = plant.name
        scientificNameLabel.text = plant.scientificName
        difficultyLabel.text = "⭐ \(plant.difficulty)"
        waterCycleLabel.text = "💧 \(plant.waterCycle)"
        lightLabel.text = "☀️ \(plant.light)"
        temperatureLabel.text = "🌡️ \(plant.temperature)"
        descriptionLabel.text = plant.description
        toxicityLabel.text = plant.toxicity ? "⚠️ 독성 있음" : "✅ 독성 없음"
        toxicityLabel.textColor = plant.toxicity ? .systemRed : .systemGreen
        
        if let image = UIImage(named: plant.imageName) {
            plantImageView.image = image
        } else {
            plantImageView.image = UIImage(systemName: "leaf.fill")
            plantImageView.tintColor = .systemGreen
        }
    }
    
    // 스토리보드의 좌측 상단 '취소/닫기' 버튼과 꼭 연결해 주세요!
    @IBAction func closeButtonTapped(_ sender: UIBarButtonItem) {
        // 현재 모달로 올라온 내비게이션 통째로 아래로 스르륵 내립니다.
        self.dismiss(animated: true, completion: nil)
    }
}

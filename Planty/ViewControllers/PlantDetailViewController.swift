//
//  PlantDetailViewController.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var diaryTableView: UITableView!
    
    // MARK: - Properties
    var plant: Plant?
    
    // 목업 데이터
    var diaries: [DiaryEntry] = [
        DiaryEntry(
            title: "광합성 데이 - 26.04.30.",
            content: "오늘도 베리베리의 상태는 좋다.\n물은 저번 주말에 주어 아직 촉촉한 상태고, 어제 못한 광합성도 충분히 했다.",
            date: Date()
        ),
        DiaryEntry(
            title: "해가 없는 날 - 26.04.29.",
            content: "오늘 베리베리의 상태는 좋다.\n물은 충분하지만, 날이 흐려 광합성을 못한 점이 아쉽다. 내일은 해가 떴으면~",
            date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        )
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        configureData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
        
        // 이미지뷰
        plantImageView.contentMode = .scaleAspectFill
        plantImageView.clipsToBounds = true
        plantImageView.backgroundColor = .lightGray
        
        // 이름 레이블
        plantNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        // D+Day 레이블
        dDayLabel.font = UIFont.systemFont(ofSize: 16)
        dDayLabel.textColor = .darkGray
        
        // 품종 레이블
        speciesLabel.font = UIFont.systemFont(ofSize: 14)
        speciesLabel.textColor = .gray
        
        // 테이블뷰
        diaryTableView.backgroundColor = .clear
        diaryTableView.separatorStyle = .none
        
        // 뒤로가기 버튼
        let backButton = UIButton()
        backButton.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 0.9)
        backButton.layer.cornerRadius = 28
        backButton.setTitle("<", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 일기 추가 버튼
        let addButton = UIButton()
        addButton.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 0.9)
        addButton.layer.cornerRadius = 28
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
        addButton.addTarget(self, action: #selector(addDiaryButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        view.addSubview(addButton)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 뒤로가기 버튼
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 56),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            
            // 일기 추가 버튼
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupTableView() {
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DiaryCell")
    }
    
    private func configureData() {
        guard let plant = plant else { return }
        plantNameLabel.text = plant.name
        dDayLabel.text = "D + \(plant.dDay)"
        speciesLabel.text = "품종: \(plant.species)"
        
        // 식물 사진 표시 추가!
        if let image = plant.photoImage {
            plantImageView.image = image
        } else {
            plantImageView.backgroundColor = .lightGray // 사진 없으면 회색
        }
        
        // 식물 일기가 있으면 사용
        if !plant.diaries.isEmpty {
            diaries = plant.diaries
        }
        
        diaryTableView.reloadData()
    }
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @objc func addDiaryButtonTapped() {
        print("일기 추가")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath)
        let diary = diaries[indexPath.row]
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        // 셀 내용 구성
        var content = cell.defaultContentConfiguration()
        content.text = diary.title
        content.secondaryText = diary.content
        content.textProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14)
        content.secondaryTextProperties.numberOfLines = 0
        cell.contentConfiguration = content
        
        // 셀 배경
        cell.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

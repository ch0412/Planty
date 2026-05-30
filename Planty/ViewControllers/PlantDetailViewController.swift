//
//  PlantDetailViewController.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import UIKit

// 식물 상세 화면 - 식물 정보와 일지 목록 표시
class PlantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Properties
    var plant: Plant?
    var diaries: [DiaryEntry] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }
    
    // MARK: - Setup
    // 전달받은 식물 데이터를 UI에 반영
    private func configureData() {
        guard let plant = plant else { return }
        plantNameLabel.text = plant.name
        dDayLabel.text = "D + \(plant.dDay)"
        speciesLabel.text = "품종: \(plant.species)"
        
        if let image = plant.photoImage {
            plantImageView.image = image
        } else {
            plantImageView.image = nil
            plantImageView.backgroundColor = .lightGray
        }
        
        diaries = plant.diaries
        diaryTableView.reloadData()
    }
    
    // MARK: - Segue
    // 일지 작성&수정 화면으로 이동 시 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showAddDiary" else { return }
            
        // 목적지가 NavigationController로 감싸진 경우와 아닌 경우 모두 처리
        let addDiaryVC: AddDiaryViewController?
        if let nav = segue.destination as? UINavigationController {
            addDiaryVC = nav.topViewController as? AddDiaryViewController
        } else {
            addDiaryVC = segue.destination as? AddDiaryViewController
        }
            
        guard let vc = addDiaryVC else { return }
        vc.delegate = self
            
        // 기존 일지 선택 시 수정 모드로 데이터 전달
        if let indexPath = sender as? IndexPath {
            vc.diary = diaries[indexPath.row]
            vc.diaryIndex = indexPath.row
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 일지 수만큼 셀 표시
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    // 각 셀에 일지 데이터 주입
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        cell.configure(with: diaries[indexPath.row])
        return cell
    }
    
    // 셀 높이 자동 조절
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // 일지 셀 탭 시 수정 화면으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddDiary", sender: indexPath)
    }
}

// MARK: - AddDiaryDelegate
extension PlantDetailViewController: AddDiaryDelegate {
    func didAddDiary(_ diary: DiaryEntry, index: Int?) {
        guard let plant = plant else { return }
        
        if let index = index {
            diaries[index] = diary
            CoreDataManager.shared.updateDiary(diary, for: plant)
        } else {
            diaries.insert(diary, at: 0)
            CoreDataManager.shared.createDiary(diary, for: plant)
        }
        
        diaries.sort { $0.date > $1.date }
        
        self.plant?.diaries = diaries
        CoreDataManager.shared.updatePlant(self.plant!)
        
        diaryTableView.reloadData()
    }
}

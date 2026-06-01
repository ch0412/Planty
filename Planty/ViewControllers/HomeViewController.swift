//
//  HomeViewController.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

// 홈 화면 - 오늘의 할 일(물주기)과 정원 식물 목록을 표시하는 메인 화면
class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var todayTagLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoTableView: UITableView!
    @IBOutlet weak var gardenTitleLabel: UILabel!
    @IBOutlet weak var plantTableView: UITableView!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var todoTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plantTableHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var todoItems: [TodoItem] = []
    var plants: [Plant] = []
    // UserDefaults에서 저장된 닉네임 불러오기(없으면 "사용자")
    var userName: String {
        return UserDefaults.standard.string(forKey: "userName") ?? "사용자"
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
        configureData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면 진입 시마다 식물 데이터 갱신
        navigationController?.popToRootViewController(animated: false)
        loadPlants()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Data
    // 날짜 및 정원 타이틀 초기 설정
    private func configureData() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        dateLabel.text = formatter.string(from: Date())
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
    }
    
    // MARK: - CoreData
    // CoreData에서 식물 목록 불러와 UI 갱신
    private func loadPlants() {
        plants = CoreDataManager.shared.fetchPlants()
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
        plantTableHeightConstraint.constant = CGFloat(plants.count) * 106
        plantTableView.reloadData()
        loadTodoItems()
    }
    
    // MARK: - 오늘의 할 일 계산
    // 관수 주기를 기반으로 오늘 물줘야 할 식물 목록 계산
    private func loadTodoItems() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
            
        todoItems = plants.compactMap { plant in
            let start = calendar.startOfDay(for: plant.startDate)
            let daysPassed = calendar.dateComponents([.day], from: start, to: today).day ?? 0
                
            // 시작일 당일 또는 관수주기로 나누어 떨어지는 날
            guard daysPassed >= 0,
                  plant.waterCycle > 0,
                  daysPassed % plant.waterCycle == 0 else { return nil }
                
            return TodoItem(title: "\(plant.name) 물주기", plantId: plant.id)
        }
            
        // 빈 상태면 높이 50 (메시지 1줄), 아니면 항목 수 * 50
        todoTableHeightConstraint.constant = todoItems.isEmpty ? 50 : CGFloat(todoItems.count) * 50
        todoTableView.reloadData()
    }
    
    // MARK: - Segue
    // 화면 전환 시 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddPlant" {
            // 식물 추가 화면 - delegate 연결
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? AddPlantViewController {
                vc.delegate = self
            } else if let vc = segue.destination as? AddPlantViewController {
                vc.delegate = self
            }
        } else if segue.identifier == "showPlantDetail" {
            // 식물 상세 화면 - 선택된 셀로부터 indexPath를 가져와 식물 데이터 전달
            if let vc = segue.destination as? PlantDetailViewController,
                let cell = sender as? PlantCell,
                let indexPath = plantTableView.indexPath(for: cell) {
                    vc.plant = plants[indexPath.row]
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todoTableView {
            // 할 일 없으면 빈 상태 셀 1개 표시
            return todoItems.isEmpty ? 1 : todoItems.count
        }
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == todoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
            
            // 할 일 없으면 빈 상태 메시지, 있으면 할 일 표시
            if todoItems.isEmpty {
                cell.configureEmpty()
            } else {
                cell.configure(with: todoItems[indexPath.row])
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as! PlantCell
            cell.configure(with: plants[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == todoTableView {
            // 할 일 완료 여부 토글
            guard !todoItems.isEmpty else { return }
            todoItems[indexPath.row].isCompleted.toggle()
            todoTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            // 식물 상세 화면으로 이동
            print("\(plants[indexPath.row].name) 선택됨")
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // 식물 목록에서만 스와이프 삭제 허용
        guard tableView == plantTableView else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self else { return }
            
            // 삭제 확인 얼럿 표시
            let alert = UIAlertController(
                title: "식물 삭제",
                message: "\(self.plants[indexPath.row].name)을(를) 삭제하시겠습니까?",
                preferredStyle: .alert
            )
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completion(false)
            }
            
            let confirmAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                let plant = self.plants[indexPath.row]
                CoreDataManager.shared.deletePlant(plant)
                self.plants.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.gardenTitleLabel.text = "\(self.userName)님의 정원 (\(self.plants.count)개)"
                self.plantTableHeightConstraint.constant = CGFloat(self.plants.count) * 182
                self.loadTodoItems()
                completion(true)
            }
            
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - AddPlantDelegate
extension HomeViewController: AddPlantDelegate {
    func didAddPlant(_ plant: Plant) {
        CoreDataManager.shared.createPlant(plant)
        loadPlants()
    }
}

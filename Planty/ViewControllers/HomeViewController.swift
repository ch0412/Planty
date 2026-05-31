//
//  HomeViewController.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit

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
    
    // MARK: - 목업 데이터
    var todoItems: [TodoItem] = [
        TodoItem(title: "베리베리 물주기", isCompleted: true),
        TodoItem(title: "카스테라 창가로 옮기기", isCompleted: false)
    ]
    
    var plants: [Plant] = []
    let userName = "OO"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero

        
        configureData()
        view.bringSubviewToFront(plusButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.popToRootViewController(animated: false)
        loadPlants()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        todoTableHeightConstraint.constant = CGFloat(todoItems.count) * 50
        plantTableHeightConstraint.constant = CGFloat(plants.count) * 106
    }
    
    // MARK: - Data
    private func configureData() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        dateLabel.text = formatter.string(from: Date())
        
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
    }
    
    // MARK: - CoreData
    private func loadPlants() {
        plants = CoreDataManager.shared.fetchPlants()
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
        plantTableHeightConstraint.constant = CGFloat(plants.count) * 106
        plantTableView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        print("설정 버튼 탭")
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddPlant" {
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? AddPlantViewController {
                vc.delegate = self
            } else if let vc = segue.destination as? AddPlantViewController {
                vc.delegate = self
            }
        } else if segue.identifier == "showPlantDetail" {
            if let vc = segue.destination as? PlantDetailViewController,
               let indexPath = sender as? IndexPath {
                vc.plant = plants[indexPath.row]
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == todoTableView ? todoItems.count : plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == todoTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell",
                                                     for: indexPath) as! TodoCell
            cell.configure(with: todoItems[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell",
                                                     for: indexPath) as! PlantCell
            cell.configure(with: plants[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == todoTableView {
            todoItems[indexPath.row].isCompleted.toggle()
            todoTableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            print("\(plants[indexPath.row].name) 선택됨")
            performSegue(withIdentifier: "showPlantDetail", sender: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard tableView == plantTableView else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completion in
            guard let self = self else { return }
            
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
                CoreDataManager.shared.deletePlant(plant)  // ← 이미 있는 메서드 그대로 사용
                self.plants.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.gardenTitleLabel.text = "\(self.userName)님의 정원 (\(self.plants.count)개)"
                self.plantTableHeightConstraint.constant = CGFloat(self.plants.count) * 182
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

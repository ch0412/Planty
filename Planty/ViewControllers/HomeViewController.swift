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
    
    // 테이블뷰 높이 (동적으로 변경)
    @IBOutlet weak var todoTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plantTableHeightConstraint: NSLayoutConstraint!
    
    // MARK: - 목업 데이터
    var todoItems: [TodoItem] = [
        TodoItem(title: "베리베리 물주기", isCompleted: true),
        TodoItem(title: "카스테라 창가로 옮기기", isCompleted: false)
    ]
    
    var plants: [Plant] = [
        Plant(name: "베리베리", species: "산세베리아",
              startDate: Calendar.current.date(byAdding: .day, value: -155, to: Date())!),
        Plant(name: "카스테라", species: "몬스테라",
              startDate: Calendar.current.date(byAdding: .day, value: -32, to: Date())!)
    ]
    
    let userName = "OO"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        setupUI()
        setupTableViews()
        configureData()
        
        view.bringSubviewToFront(plusButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 테이블뷰 높이 동적 업데이트
        todoTableHeightConstraint.constant = CGFloat(todoItems.count) * 50
        plantTableHeightConstraint.constant = CGFloat(plants.count) * 106
        
        print("bannerView frame after layout: \(bannerView.frame)")
    }
    
    // MARK: - Setup
    private func setupUI() {
        // 배경색 (크림)
        view.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
        contentView.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
        
        // 배너 스타일
        bannerView.backgroundColor = .white
        
        // 플로팅 버튼 스타일
            plusButton.layer.cornerRadius = 28
            plusButton.backgroundColor = UIColor(red: 0.4, green: 0.7, blue: 0.4, alpha: 1.0)
            plusButton.setTitleColor(.white, for: .normal)
            plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
            plusButton.layer.shadowColor = UIColor.black.cgColor
            plusButton.layer.shadowOpacity = 0.3
            plusButton.layer.shadowOffset = CGSize(width: 0, height: 4)
            plusButton.layer.shadowRadius = 8
    }
    
    private func setupTableViews() {
        todoTableView.delegate = self
        todoTableView.dataSource = self
        //todoTableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
        
        plantTableView.delegate = self
        plantTableView.dataSource = self
        //plantTableView.register(UINib(nibName: "PlantCell", bundle: nil), forCellReuseIdentifier: "PlantCell")
    }
    
    private func configureData() {
        // 날짜
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        dateLabel.text = formatter.string(from: Date())
        
        // 정원 타이틀
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
    }
    
    // MARK: - IBActions
    @IBAction func settingButtonTapped(_ sender: UIButton) {
        print("설정 버튼 탭")
    }
    
    @IBAction func addPlantButtonTapped(_ sender: UIButton) {
        print("식물 추가 버튼 탭")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "AddPlantVC"
        ) as! AddPlantViewController
            
        vc.delegate = self  // delegate 연결
            
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == todoTableView {
            return todoItems.count
        } else {
            return plants.count
        }
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
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(
                withIdentifier: "PlantDetailVC"
            ) as! PlantDetailViewController
                    
            vc.plant = plants[indexPath.row]
                    
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == todoTableView {
            return 50
        } else {
            return 106
        }
    }
}

// MARK: - AddPlantDelegate
extension HomeViewController: AddPlantDelegate {
    func didAddPlant(_ plant: Plant) {
        // 배열에 추가
        plants.append(plant)
        
        // 타이틀 업데이트
        gardenTitleLabel.text = "\(userName)님의 정원 (\(plants.count)개)"
        
        // 테이블뷰 높이 업데이트
        plantTableHeightConstraint.constant = CGFloat(plants.count) * 106
        
        // 테이블뷰 리로드
        plantTableView.reloadData()
    }
}

//
//  SettingViewController.swift
//  Planty
//
//  Created by choeun on 6/1/26.
//

import UIKit

// 설정 화면 - 계정 관리(닉네임 변경, 로그아웃)와 식물 정보 수정 기능 제공
class SettingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    let sections = ["계정", "식물 관리"]
    let accountItems = ["닉네임 변경", "로그아웃"]
    var plants: [Plant] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        print("✅ viewDidLoad 호출됨")
        print("tableView: \(tableView!)")
        loadPlants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlants()
    }
    
    // MARK: - CoreData
    // CoreData에서 식물 목록 불러와 UI 갱신
    private func loadPlants() {
        plants = CoreDataManager.shared.fetchPlants()
        print("식물 수: \(plants.count)")
        tableView.reloadData()
    }
    
    // MARK: - Alert
    // 닉네임 변경 알림 팝업
    private func showChangeNameAlert() {
        let alert = UIAlertController(title: "닉네임 변경", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = UserDefaults.standard.string(forKey: "userName")
            textField.placeholder = "닉네임 입력"
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "변경", style: .default) { _ in
            guard let name = alert.textFields?.first?.text,
                  !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
            UserDefaults.standard.set(name, forKey: "userName")
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    // 로그아웃 확인 알림 팝업
    private func showLogoutAlert() {
        let alert = UIAlertController(title: "로그아웃", message: "온보딩 화면으로 이동합니다", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "로그아웃", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "userName")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = rootVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
    
    // MARK: - Segue
    // 식물 수정 화면으로 이동 시 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditPlant",
            let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? AddPlantViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            vc.plantToEdit = plants[indexPath.row]
            vc.editDelegate = self
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // 섹션 헤더 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? accountItems.count : plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        cell.textLabel?.font = .systemFont(ofSize: 16)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = accountItems[indexPath.row]
            cell.textLabel?.textColor = indexPath.row == 1 ? .systemRed : .label
            cell.accessoryType = indexPath.row == 0 ? .disclosureIndicator : .none
        } else {
            cell.textLabel?.text = plants[indexPath.row].name
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 계정 섹션 - 닉네임 변경 또는 로그아웃
        if indexPath.section == 0 {
            indexPath.row == 0 ? showChangeNameAlert() : showLogoutAlert()
        } 
    }
}

// MARK: - EditPlantDelegate
extension SettingViewController: EditPlantDelegate {
    func didEditPlant() {
        loadPlants()
    }
}

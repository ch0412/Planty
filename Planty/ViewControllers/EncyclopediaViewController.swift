//
//  EncyclopediaViewController.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

class EncyclopediaViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let allPlants: [EncyclopediaPlant] = EncyclopediaPlant.sampleData
    private var filteredPlants: [EncyclopediaPlant] = []
    private var isSearching = false
    
    private var displayedPlants: [EncyclopediaPlant] {
        return isSearching ? filteredPlants : allPlants
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        // UISearchController는 시스템 내장 방식이라 코드로 유지하는 것이 가장 안전합니다.
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "식물 이름을 입력하세요"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1. 세그웨이 식별자(Identifier)가 일치하는지 먼저 확인합니다.
        guard segue.identifier == "showEncycDetail" else { return }
            
            // 2. 목적지가 이제 'Navigation Controller'이므로 얘를 먼저 꺼냅니다.
        guard let navVC = segue.destination as? UINavigationController else {
            return
        }
            
            // 3. 내비게이션 컨트롤러가 품고 있는 첫 번째 화면(topViewController)을 상세 화면으로 꺼냅니다.
        guard let detailVC = navVC.topViewController as? PlantEncycDetailViewController else {
            return
        }
            
            // 4. 클릭한 셀의 인덱스패스(IndexPath)를 가져옵니다.
        guard let indexPath = sender as? IndexPath else { return }
            
            // 5. 드디어 찾아낸 상세 화면에 식물 데이터를 쏙 넣어줍니다!
        detailVC.plant = displayedPlants[indexPath.item]
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension EncyclopediaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPlants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EncyclopediaCell",
            for: indexPath
        ) as? EncyclopediaCell else { return UICollectionViewCell() }
        
        cell.configure(with: displayedPlants[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEncycDetail", sender: indexPath)
    }
}

// MARK: - UISearchBar Delegate
extension EncyclopediaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filteredPlants = allPlants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.scientificName.localizedCaseInsensitiveContains(searchText)
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        collectionView.reloadData()
    }
}

extension EncyclopediaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 16   // 화면 좌우 여백
        let spacing: CGFloat = 16   // 셀과 셀 사이의 가로 공백
        
        // 🌟 핵심: view.frame 대신 실시간으로 확정된 collectionView.bounds.width를 사용합니다!
        let collectionViewWidth = collectionView.bounds.width
        let width = (collectionViewWidth - (padding * 2) - spacing) / 2
        
        // 시안 기반의 가로세로 비율 (세로가 살짝 더 긴 카드 형태)
        return CGSize(width: width, height: width * 1.2)
    }
}

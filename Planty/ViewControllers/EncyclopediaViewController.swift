//
//  EncyclopediaViewController.swift
//  Planty
//
//  Created by choeun on 5/23/26.
//

import UIKit

// 식물 도감 화면 - 전체 식물 목록을 그리드 형태로 표시 & 검색 기능 제공
class EncyclopediaViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    private let allPlants: [EncyclopediaPlant] = EncyclopediaPlant.sampleData
    private var filteredPlants: [EncyclopediaPlant] = []
    private var isSearching = false
    
    // 검색 상태에 따라 표시할 데이터 동적으로 반환
    private var displayedPlants: [EncyclopediaPlant] {
        return isSearching ? filteredPlants : allPlants
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }
    
    // MARK: - Setup
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "식물 이름을 입력하세요"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "취소"
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showEncycDetail" else { return }
        guard let navVC = segue.destination as? UINavigationController else { return }
        guard let detailVC = navVC.topViewController as? PlantEncycDetailViewController else { return }
        guard let indexPath = sender as? IndexPath else { return }
        detailVC.plant = displayedPlants[indexPath.item]
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension EncyclopediaViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 표시할 셀 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedPlants.count
    }
    
    // 각 셀에 식물 데이터를 주입하여 반환
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EncyclopediaCell",
            for: indexPath
        ) as? EncyclopediaCell else { return UICollectionViewCell() }
        
        cell.configure(with: displayedPlants[indexPath.item])
        return cell
    }
    
    // 셀 선택 시 상세 화면으로 이동
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEncycDetail", sender: indexPath)
    }
}

// MARK: - UISearchBar Delegate
extension EncyclopediaViewController: UISearchBarDelegate {
    
    // 검색어 입력 시 실시간으로 필터링
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearching = !searchText.isEmpty
        filteredPlants = allPlants.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.scientificName.localizedCaseInsensitiveContains(searchText)
        }
        collectionView.reloadData()
    }
    
    // 검색 취소 시 전체 목록으로 복귀
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension EncyclopediaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let spacing: CGFloat = 16
        let collectionViewWidth = collectionView.bounds.width
        let width = (collectionViewWidth - (padding * 2) - spacing) / 2
        return CGSize(width: width, height: width * 1.2)
    }
}

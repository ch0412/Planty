import UIKit

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
        setupUI()
        setupTableView()
        configureData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // 버튼 cornerRadius만 코드로 처리
        addButton.layer.cornerRadius = 28
        addButton.layer.masksToBounds = true
    }
    
    private func setupTableView() {
        diaryTableView.delegate = self
        diaryTableView.dataSource = self
        diaryTableView.register(DiaryCell.self, forCellReuseIdentifier: "DiaryCell")
        diaryTableView.separatorStyle = .none
        diaryTableView.backgroundColor = .clear
    }
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddDiary" {
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? AddDiaryViewController {
                vc.delegate = self
                if let indexPath = sender as? IndexPath {
                    vc.diary = diaries[indexPath.row]
                    vc.diaryIndex = indexPath.row
                }
            } else if let vc = segue.destination as? AddDiaryViewController {
                vc.delegate = self
                if let indexPath = sender as? IndexPath {
                    vc.diary = diaries[indexPath.row]
                    vc.diaryIndex = indexPath.row
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PlantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryCell", for: indexPath) as! DiaryCell
        cell.configure(with: diaries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showAddDiary", sender: indexPath)
    }
}

// MARK: - AddDiaryDelegate
extension PlantDetailViewController: AddDiaryDelegate {
    func didAddDiary(_ diary: DiaryEntry, index: Int?) {
        guard let plant = plant else { return }
        
        if let index = index {
            // 일지 수정
            diaries[index] = diary
            CoreDataManager.shared.updateDiary(diary, for: plant)
        } else {
            // 일지 추가
            diaries.insert(diary, at: 0)
            CoreDataManager.shared.createDiary(diary, for: plant)
        }
        
        // plant 업데이트
        self.plant?.diaries = diaries
        
        // CoreData plant 업데이트
        CoreDataManager.shared.updatePlant(self.plant!)
        
        diaryTableView.reloadData()
    }
}

import UIKit

class PlantDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: UILabel!
    @IBOutlet weak var dDayLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var diaryTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!    // ✅ 추가
    
    // MARK: - Properties
    var plant: Plant?
    var diaries: [DiaryEntry] = [
        DiaryEntry(
            title: "광합성 데이",
            content: "오늘도 베리베리의 상태는 좋다.\n물은 저번 주말에 주어 아직 촉촉한 상태고, 어제 못한 광합성도 충분히 했다.",
            date: Date()
        ),
        DiaryEntry(
            title: "해가 없는 날",
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
        
        if !plant.diaries.isEmpty {
            diaries = plant.diaries
        }
        
        diaryTableView.reloadData()
    }
    
    @IBAction func addDiaryButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showAddDiary", sender: nil)
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddDiary" {
            if let nav = segue.destination as? UINavigationController,
               let vc = nav.topViewController as? AddDiaryViewController {
                vc.delegate = self
                // 수정 모드인 경우
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
        if let index = index {
            diaries[index] = diary
        } else {
            diaries.insert(diary, at: 0)
        }
        plant?.diaries = diaries
        diaryTableView.reloadData()
    }
}

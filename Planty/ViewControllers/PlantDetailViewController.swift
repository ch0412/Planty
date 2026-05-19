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
        view.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.93, alpha: 1.0)
        
        plantImageView.contentMode = .scaleAspectFill
        plantImageView.clipsToBounds = true
        plantImageView.backgroundColor = .lightGray
        
        plantNameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        dDayLabel.font = UIFont.systemFont(ofSize: 16)
        dDayLabel.textColor = .darkGray
        speciesLabel.font = UIFont.systemFont(ofSize: 14)
        speciesLabel.textColor = .gray
        
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
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            backButton.widthAnchor.constraint(equalToConstant: 56),
            backButton.heightAnchor.constraint(equalToConstant: 56),
            
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
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
    
    // MARK: - Actions
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
    }
    
    @objc func addDiaryButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "AddDiaryVC"
        ) as! AddDiaryViewController
        
        vc.delegate = self
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
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
    
    // 일지 클릭시 수정 화면으로
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(
            withIdentifier: "AddDiaryVC"
        ) as! AddDiaryViewController
        
        vc.delegate = self
        vc.diary = diaries[indexPath.row]
        vc.diaryIndex = indexPath.row
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}

// MARK: - AddDiaryDelegate
extension PlantDetailViewController: AddDiaryDelegate {
    func didAddDiary(_ diary: DiaryEntry, index: Int?) {
        if let index = index {
            // 수정
            diaries[index] = diary
        } else {
            // 새로 추가
            diaries.insert(diary, at: 0)
        }
        diaryTableView.reloadData()
    }
}

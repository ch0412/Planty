import UIKit

// MARK: - Delegate 프로토콜
protocol AddDiaryDelegate: AnyObject {
    func didAddDiary(_ diary: DiaryEntry, index: Int?)
}

class AddDiaryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    // MARK: - Properties
    weak var delegate: AddDiaryDelegate?
    var selectedImages: [UIImage] = [] // ← 배열로 변경
    var diary: DiaryEntry?
    var diaryIndex: Int?
    
    // 사진 컬렉션뷰
    private lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupPhotoCollectionView()
        loadExistingDiary()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        title = diary == nil ? "일지 작성" : "일지 수정"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 제목 TextField
        titleTextField.placeholder = "제목"
        titleTextField.borderStyle = .none
        titleTextField.font = UIFont.systemFont(ofSize: 18)
        
        // 구분선
        let titleLine = UIView()
        titleLine.backgroundColor = .lightGray
        titleLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLine)
        NSLayoutConstraint.activate([
            titleLine.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 4),
            titleLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        // 내용 TextView
        contentTextView.font = UIFont.systemFont(ofSize: 16)
        contentTextView.backgroundColor = .clear
        contentTextView.delegate = self
        contentTextView.text = "오늘의 일지 작성..."
        contentTextView.textColor = .lightGray
        
        // 사진 추가 버튼
        let photoButton = UIButton()
        photoButton.setImage(UIImage(systemName: "photo.badge.plus"), for: .normal)
        photoButton.tintColor = .gray
        photoButton.contentVerticalAlignment = .fill
        photoButton.contentHorizontalAlignment = .fill
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        view.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            photoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            photoButton.widthAnchor.constraint(equalToConstant: 36),
            photoButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupPhotoCollectionView() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        view.addSubview(photoCollectionView)
        NSLayoutConstraint.activate([
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            photoCollectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    // 기존 일지 불러오기
    private func loadExistingDiary() {
        guard let diary = diary else { return }
        titleTextField.text = diary.title
        contentTextView.text = diary.content
        contentTextView.textColor = .black
        selectedImages = diary.photoImages
        photoCollectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc func photoButtonTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty else {
            showAlert(message: "제목을 입력해주세요")
            return
        }
        
        let content = contentTextView.textColor == .lightGray ? "" : contentTextView.text ?? ""
        
        let newDiary = DiaryEntry(
            title: title,
            content: content,
            date: diary?.date ?? Date(),
            photoImages: selectedImages
        )
        
        delegate?.didAddDiary(newDiary, index: diaryIndex)
        dismiss(animated: true)
    }
    
    // MARK: - Helper
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "입력 오류",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextViewDelegate
extension AddDiaryViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "오늘의 일지 작성..."
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectedImages.append(image) // ← 배열에 추가
            photoCollectionView.reloadData()
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AddDiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(with: selectedImages[indexPath.item])
        cell.deleteHandler = { [weak self] in
            self?.selectedImages.remove(at: indexPath.item)
            self?.photoCollectionView.reloadData()
        }
        return cell
    }
}

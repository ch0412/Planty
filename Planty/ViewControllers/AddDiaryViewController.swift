import UIKit
import Photos

// MARK: - Delegate 프로토콜
protocol AddDiaryDelegate: AnyObject {
    func didAddDiary(_ diary: DiaryEntry, index: Int?)
}

class AddDiaryViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    // MARK: - Properties
    weak var delegate: AddDiaryDelegate?
    var selectedImages: [UIImage] = []
    var diary: DiaryEntry?
    var diaryIndex: Int?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTitleLine()
        
        // 스토리보드에서 가져온 컬렉션뷰의 대리자 임명
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        contentTextView.delegate = self
        
        loadExistingDiary()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        // diary 있으면 수정, 없으면 작성
        title = diary == nil ? "일지 작성" : "일지 수정"
    }
    
    private func setupTitleLine() {
        // 텍스트 필드 밑 언더라인 가이드 주입
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
    }
    
    private func loadExistingDiary() {
        guard let diary = diary else { return }
        titleTextField.text = diary.title
        contentTextView.text = diary.content
        contentTextView.textColor = .black
        selectedImages = diary.photoImages
        photoCollectionView.reloadData()
    }
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces),
              !title.isEmpty else {
            showAlert(message: "제목을 입력해주세요.")
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
    
    @IBAction func photoButtonTapped(_ sender: UIButton) { // 🌟 스토리보드 photoButton과 Touch Up Inside 재연결 필요!
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            presentPicker()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self?.presentPicker()
                    }
                }
            }
        case .denied, .restricted:
            showAlert(message: "설정에서 사진 접근 권한을 허용해주세요.")
        default:
            break
        }
    }
    
    // MARK: - Helper
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
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
        if textView.text == "오늘의 일지 작성..." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘의 일지 작성..."
            textView.textColor = .lightGray
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        
        guard let image = image else {
            picker.dismiss(animated: true)
            return
        }
        selectedImages.append(image)
        photoCollectionView.reloadData()
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
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

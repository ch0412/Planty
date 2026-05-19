import UIKit

// MARK: - Delegate 프로토콜
protocol AddPlantDelegate: AnyObject {
    func didAddPlant(_ plant: Plant)
}

class AddPlantViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var waterCycleTextField: UITextField!
    
    // MARK: - Properties
    weak var delegate: AddPlantDelegate?
    var selectedDate: Date = Date()
    var selectedWaterCycle: Int = 3
    let waterCycleOptions = [1, 2, 3, 5, 7, 10, 14, 21, 30]
    var selectedImage: UIImage?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupDatePicker()
        setupWaterCyclePicker()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // 사진 영역
        photoView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        photoView.layer.cornerRadius = 8
        
        // 점선 테두리
        let dashBorder = CAShapeLayer()
        dashBorder.strokeColor = UIColor.lightGray.cgColor
        dashBorder.lineDashPattern = [6, 3]
        dashBorder.frame = photoView.bounds
        dashBorder.fillColor = nil
        dashBorder.path = UIBezierPath(
            roundedRect: photoView.bounds,
            cornerRadius: 8
        ).cgPath
        photoView.layer.addSublayer(dashBorder)
        
        // 코드로 버튼 생성
        let photoButton = UIButton()
        photoButton.layer.cornerRadius = 20
        photoButton.backgroundColor = UIColor(red: 0.6, green: 0.8, blue: 0.6, alpha: 0.7)
        photoButton.setTitle("+", for: .normal)
        photoButton.setTitleColor(.white, for: .normal)
        photoButton.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
        photoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
        
        photoView.addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoButton.centerXAnchor.constraint(equalTo: photoView.centerXAnchor),
            photoButton.centerYAnchor.constraint(equalTo: photoView.centerYAnchor),
            photoButton.widthAnchor.constraint(equalToConstant: 40),
            photoButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // TextField 스타일
        [speciesTextField, nicknameTextField,
         startDateTextField, waterCycleTextField].forEach {
            $0?.borderStyle = .roundedRect
        }
        
        speciesTextField.placeholder = "품종"
        nicknameTextField.placeholder = "별명"
        startDateTextField.placeholder = "시작 날짜"
        waterCycleTextField.placeholder = "관수 주기"
    }
    
    private func setupNavigationBar() {
        title = "새 식물 등록"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "저장",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self,
                            action: #selector(dateChanged),
                            for: .valueChanged)
        startDateTextField.inputView = datePicker
    }
    
    private func setupWaterCyclePicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        waterCycleTextField.inputView = picker
        waterCycleTextField.text = "3일마다"
    }
    
    // MARK: - Actions
    @objc func photoButtonTapped() {
        print("사진 추가")
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        startDateTextField.text = formatter.string(from: sender.date)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func saveButtonTapped() {
        guard let species = speciesTextField.text, !species.isEmpty else {
            showAlert(message: "품종을 입력해주세요")
            return
        }
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "별명을 입력해주세요")
            return
        }
        
        var newPlant = Plant(
            name: nickname,
            species: species,
            startDate: selectedDate,
            waterCycle: selectedWaterCycle
        )
        newPlant.photoImage = selectedImage
        
        delegate?.didAddPlant(newPlant)
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

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddPlantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waterCycleOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(waterCycleOptions[row])일마다"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWaterCycle = waterCycleOptions[row]
        waterCycleTextField.text = "\(waterCycleOptions[row])일마다"
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            selectedImage = image
            
            // photoView에 이미지 표시
            let imageView = UIImageView(frame: photoView.bounds)
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            photoView.addSubview(imageView)
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

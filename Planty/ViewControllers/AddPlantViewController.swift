//
//  AddPlantViewController.swift
//  Planty
//
//  Created by choeun on 5/17/26.
//

import UIKit
import Photos

// MARK: - Delegate 프로토콜
protocol AddPlantDelegate: AnyObject {
    func didAddPlant(_ plant: Plant)
}

class AddPlantViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var photoButton: UIButton!
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
    private var dashBorderAdded = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupWaterCyclePicker()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !dashBorderAdded {
            setupDashBorder()
            dashBorderAdded = true
        }
    }
    
    // MARK: - Setup
    private func setupDashBorder() {
        // 점선 테두리만 코드로 처리 (스토리보드에서 불가능)
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
    
    // MARK: - IBActions
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
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
    
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }
        
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
    
    // MARK: - Actions
    @objc func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        startDateTextField.text = formatter.string(from: sender.date)
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
    
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddPlantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let image = image else { return }
        selectedImage = image
        
        photoView.subviews.forEach { $0.removeFromSuperview() }
        
        let imageView = UIImageView(frame: photoView.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        photoView.addSubview(imageView)
        
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

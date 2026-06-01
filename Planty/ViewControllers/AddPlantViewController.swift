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

protocol EditPlantDelegate: AnyObject {
    func didEditPlant()
}

// 식물 등록 & 수정 화면 - 식물 정보(품종, 별명, 시작일, 관수주기, 사진)를 입력받아 저장
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
    weak var editDelegate: EditPlantDelegate?
    var plantToEdit: Plant? = nil
    var selectedDate: Date = Date()
    var selectedWaterCycle: Int = 3
    let waterCycleOptions = [1, 2, 3, 4, 5, 6, 7, 10, 14, 21, 30, 45, 60]
    var selectedImage: UIImage?
    private var dashBorderAdded = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        setupWaterCyclePicker()
        setupTapGesture()
        configureMode()
    }
    
    // 레이아웃 완료 후 점선 테두리 추가
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !dashBorderAdded {
            setupDashBorder()
            dashBorderAdded = true
        }
        
        if let image = selectedImage, dashBorderAdded {
            showImage(image)
        }
    }
    
    // MARK: - 모드 설정
    // 등록 or 수정 여부에 따라 타이틀 및 기존 데이터 설정
    private func configureMode() {
        if let plant = plantToEdit {
            // 수정 모드
            title = "식물 정보 수정"
                
            // 기존 데이터 채우기
            nicknameTextField.text = plant.name
            speciesTextField.text = plant.species
            selectedDate = plant.startDate
            selectedWaterCycle = plant.waterCycle
            selectedImage = plant.photoImage
                
            // 날짜 텍스트 표시
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일"
            startDateTextField.text = formatter.string(from: plant.startDate)
                
            // 관수 주기 텍스트 표시
            waterCycleTextField.text = "\(plant.waterCycle)일마다"
                
            // DatePicker 날짜 설정
            if let datePicker = startDateTextField.inputView as? UIDatePicker {
                datePicker.date = plant.startDate
            }
                
            // PickerView 관수 주기 설정
            if let picker = waterCycleTextField.inputView as? UIPickerView,
                let index = waterCycleOptions.firstIndex(of: plant.waterCycle) {
                picker.selectRow(index, inComponent: 0, animated: false)
            }
                
        } else {
            // 등록 모드
            title = "새 식물 등록"
        }
    }
    
    // MARK: - Setup
    private func setupDashBorder() {
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
    
    // 시작 날짜 TextField -> DatePicker 연결
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        startDateTextField.inputView = datePicker
    }
    
    // 관수 주기 TextField -> PickerView 연결
    private func setupWaterCyclePicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        waterCycleTextField.inputView = picker
    }
    
    // 빈 공간 탭 -> 피커 & 키보드 닫기
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissPicker))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - IBActions
    // 취소 버튼 - 화면 닫기
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // 저장 버튼 - 유효성 검사 후 등록 & 수정 처리
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let species = speciesTextField.text, !species.isEmpty else {
            showAlert(message: "품종을 입력해주세요")
            return
        }
        guard let nickname = nicknameTextField.text, !nickname.isEmpty else {
            showAlert(message: "별명을 입력해주세요")
            return
        }
        
        if var plant = plantToEdit {
            // 수정 모드 - 기존 식물 데이터 업데이트
            plant.name = nickname
            plant.species = species
            plant.startDate = selectedDate
            plant.waterCycle = selectedWaterCycle
            plant.photoImage = selectedImage
            CoreDataManager.shared.updatePlant(plant)
            editDelegate?.didEditPlant()
            dismiss(animated: true)
        } else {
            // 등록 모드 - 새 식물 생성 후 delegate로 전달
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
    }
    
    // 사진 추가 버튼 - 권한 확인 후 사진 라이브러리 실행
    @IBAction func photoButtonTapped(_ sender: UIButton) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            presentPicker()
        case .notDetermined:
            // 권한 요청
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
    // 날짜 피커 값 변경 시 TextField 업데이트
    @objc func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        startDateTextField.text = formatter.string(from: sender.date)
    }
    
    // 빈 공간 탭 -> 피커 닫기 및 미선택 항목 자동 설정
    @objc func dismissPicker() {
        // 날짜 미선택 시 오늘 날짜로 자동 설정
        if startDateTextField.isFirstResponder && startDateTextField.text?.isEmpty == true {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일"
            startDateTextField.text = formatter.string(from: Date())
            selectedDate = Date()
        }
        
        // 관수 주기 미선택 시 첫번째 항목으로 자동 설정
        if waterCycleTextField.isFirstResponder {
            if waterCycleTextField.text?.isEmpty == true {
                selectedWaterCycle = waterCycleOptions[0]
                waterCycleTextField.text = "\(waterCycleOptions[0])일마다"
            }
        }
        
        view.endEditing(true)
    }
    
    // MARK: - Helper
    // 입력 오류 알림 팝업
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "입력 오류",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    // 사진 라이브러리 열기
    private func presentPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    // 이미지 표시
    private func showImage(_ image: UIImage) {
        photoView.subviews.forEach {
            if !($0 is UIButton) { $0.removeFromSuperview() }
        }
        let imageView = UIImageView(frame: photoView.bounds)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        photoView.addSubview(imageView)
        photoView.sendSubviewToBack(imageView)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension AddPlantViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { return 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return waterCycleOptions.count
    }
    
    // 피커 각 행에 관수 주기 텍스트 표시
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(waterCycleOptions[row])일마다"
    }
    
    // 관수 주기 선택 시 TextField 업데이트
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedWaterCycle = waterCycleOptions[row]
        waterCycleTextField.text = "\(waterCycleOptions[row])일마다"
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddPlantViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진 선택 완료 시 이미지 표시
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        guard let image = image else {
            dismiss(animated: true)
            return
        }
        selectedImage = image
        showImage(image)
        dismiss(animated: true)
    }

    // 사진 선택 취소 시 화면 닫기
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

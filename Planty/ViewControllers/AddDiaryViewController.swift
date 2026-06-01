//
//  AddDiaryViewController.swift
//  Planty
//
//  Created by choeun on 5/18/26.
//

import UIKit
import Photos
import PhotosUI

// MARK: - Delegate 프로토콜
protocol AddDiaryDelegate: AnyObject {
    func didAddDiary(_ diary: DiaryEntry, index: Int?)
}

// 일지 작성 & 수정 화면 - 제목, 내용, 사진을 입력받아 일지 작성
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
        loadExistingDiary()
    }
    
    // MARK: - Setup
    // 작성 & 수정 여부에 따라 네비게이션 타이틀 설정
    private func setupNavigationBar() {
        title = diary == nil ? "일지 작성" : "일지 수정"
    }
    
    // 수정 모드일 때 기존 일지 데이터를 UI에 반영
    private func loadExistingDiary() {
        guard let diary = diary else { return }
        titleTextField.text = diary.title
        contentTextView.text = diary.content
        contentTextView.textColor = .black
        selectedImages = diary.photoImages
        photoCollectionView.reloadData()
    }
    
    // MARK: - IBActions
    // 취소 버튼 - 화면 닫기
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // 저장 버튼 - 유효성 검사 후 delegate로 데이터 전달
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespaces), !title.isEmpty else {
            showAlert(message: "제목을 입력해주세요.")
            return
        }
        
        let content = contentTextView.textColor == .lightGray ? "" : contentTextView.text ?? ""
        
        var newDiary = DiaryEntry(
            title: title,
            content: content,
            date: diary?.date ?? Date(),
            photoImages: selectedImages
        )
        
        if let existingDiary = diary {
            newDiary.id = existingDiary.id
        }
        
        delegate?.didAddDiary(newDiary, index: diaryIndex)
        dismiss(animated: true)
    }
    
    // 사진 추가 버튼 - 권한 확인 후 PHPicker 실행
    @IBAction func photoButtonTapped(_ sender: UIButton) {
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
    // PHPickerViewController 설정 및 표시
    private func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 0
        configuration.filter = .images
                
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
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
}

// MARK: - UITextViewDelegate
extension AddDiaryViewController: UITextViewDelegate {
    
    // 작성 시작 시 플레이스홀더 텍스트 제거
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "오늘의 일지 작성..." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집 종료 시 내용 없으면 플레이스홀더 복원
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "오늘의 일지 작성..."
            textView.textColor = .lightGray
        }
    }
}

// MARK: - PHPickerViewControllerDelegate
extension AddDiaryViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard !results.isEmpty else { return }
        let group = DispatchGroup()
        
        for result in results {
            let itemProvider = result.itemProvider
            
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self?.selectedImages.append(image)
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.photoCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AddDiaryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 선택한 사진 수만큼 셀 표시
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    // 각 셀에 사진 주입 및 삭제 핸들러 연결
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

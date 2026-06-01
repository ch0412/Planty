//
//  OnboardingViewController.swift
//  Planty
//
//  Created by choeun on 6/1/26.
//

import UIKit

// 온보딩 화면 - 앱 첫 실행 시 닉네임 입력 후 홈으로 이동
class OnboardingViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "userName") != nil {
            goToHome()
        }
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Navigation
    // 홈 화면(TabBarController)을 루트 뷰 컨트롤러로 전환
    private func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first {
            window.rootViewController = rootVC
            UIView.transition(with: window, duration: 0, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    // MARK: - Actions
    // 텍스트 필드 입력 시 확인 버튼 활성화 여부 업데이트
    @objc private func textFieldDidChange() {
        let text = nameTextField.text ?? ""
        confirmButton.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // 확인 버튼 탭 - 닉네임 저장 후 홈으로 이동
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        UserDefaults.standard.set(name, forKey: "userName")
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
}

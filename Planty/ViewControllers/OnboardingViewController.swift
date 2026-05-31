//
//  OnboardingViewController.swift
//  Planty
//
//  Created by choeun on 6/1/26.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "userName") != nil {
            goToHome()
        }
        
        nameTextField.addTarget(self,
                                action: #selector(textFieldDidChange),
                                for: .editingChanged)
    }
    
    private func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = rootVC
            UIView.transition(with: window,
                              duration: 0,  // 애니메이션 없이 바로 전환
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
    
    @objc private func textFieldDidChange() {
        let text = nameTextField.text ?? ""
        confirmButton.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
              !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        UserDefaults.standard.set(name, forKey: "userName")
        
        performSegue(withIdentifier: "goToHome", sender: nil)
    }
}

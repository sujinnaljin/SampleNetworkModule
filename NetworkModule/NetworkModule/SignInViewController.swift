//
//  SignInViewController.swift
//  NetworkModule
//
//  Created by Kang, Su Jin (강수진) on 2022/01/08.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    private let havitService: HavitServiceable = HavitService(apiService: APIService(),
                                                              environment: .development)
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNextButton()
        setTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTextFieldEmpty()
    }
    
    // MARK: - Methods
    // MARK: Custom Method
    
    func setNextButton() {
        nextButton.isEnabled = false
    }
    
    func setTextField() {
        [nameTextField, emailTextField, passwordTextField].forEach {
            $0?.delegate = self
        }
    }
    
    func setTextFieldEmpty() {
        [nameTextField, emailTextField, passwordTextField].forEach {
            $0?.text = ""
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func createAccountButtonDidTap(_ sender: UIButton) {
        guard let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") else {return}
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @IBAction func nextButtonDidTap(_ sender: UIButton) {
        requestLogin()
    }
}

// MARK: - Extensions

extension SignInViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if nameTextField.hasText && emailTextField.hasText && passwordTextField.hasText {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField: emailTextField.becomeFirstResponder()
        case emailTextField: passwordTextField.becomeFirstResponder()
        case passwordTextField: passwordTextField.resignFirstResponder()
        default: break
        }
        return true
    }
}

extension SignInViewController {

    func requestLogin() {
        Task {
            do {
                let user = User(email: "email@naver.com", password: "password", address: "address")
                let token = try await havitService.login(user:user)
                // 성공
                print(token)
            } catch APIServiceError.serverError {
                // 에러 처리
                print("serverError")
            } catch APIServiceError.clientError(let message) {
                // 에러 처리
                print("clientError: \(message)")
                print(message)
            } catch let error {
                // 디코딩 에러
                if error is DecodingError {
                    print("decoding error")
                }
            }
        }
    }
}

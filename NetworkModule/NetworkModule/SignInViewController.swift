//
//  SignInViewController.swift
//  NetworkModule
//
//  Created by Kang, Su Jin (강수진) on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    private let havitService: HavitServiceable = HavitService(apiService: APIService(),
                                                              environment: .development)
    let viewModel = SignInViewControllerModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }
    
    // MARK: - Methods
    // MARK: Custom Method
    private func bindInput() {
        nameTextField.rx.text
            .orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)
        
        //TODO: coordinator 로 빼면 VM 쪽에 있어야할 듯
        createAccountButton.rx.tap
            .bind(onNext: { _ in
                let signUpViewController = UIViewController()
                signUpViewController.view.backgroundColor = .red
                self.navigationController?.pushViewController(signUpViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.isValid
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - IBActions
    @IBAction func nextButtonDidTap(_ sender: UIButton) {
        requestLogin()
    }
}

// MARK: - Extensions

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

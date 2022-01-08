//
//  ViewController.swift
//  NetworkModule
//
//  Created by Kang, Su Jin (강수진) on 2022/01/08.
//

import UIKit

class ViewController: UIViewController {

    private let havitService: HavitServiceable = HavitService(apiService: APIService(),
                                                              environment: .development)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getPosts() //get
        login() //post
    }
    
    func getPosts() {
        Task {
            do {
                let result = try await havitService.getPosts()
                // 성공
                print(result?.first?.title)
            } catch APIServiceError.serverError {
                // 에러 처리
            } catch APIServiceError.clientError(let message) {
                // 에러 처리
                print(message)
            } catch let error {
                // 디코딩 에러
                if error is DecodingError {
                    print("decoding error")
                }
            }
        }
    }
    
    func login() {
        Task {
            do {
                let user = User(email: "email@naver.com", password: "password", address: "address")
                let token = try await havitService.login(user:user)
                // 성공
                print(token)
            } catch APIServiceError.serverError {
                // 에러 처리
            } catch APIServiceError.clientError(let message) {
                // 에러 처리
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

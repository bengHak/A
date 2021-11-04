//
//  SignInViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/04.
//

import Foundation
import RxSwift
import RxRelay
import SwiftKeychainWrapper

protocol SignInDependency {
    var isLoading: BehaviorRelay<Bool> { get }
    var isSignedIn: BehaviorRelay<Bool> { get }
}

protocol SignInInput {
    var email: BehaviorRelay<String> { get }
    var password: BehaviorRelay<String> { get }
}

protocol SignInOutput {
    var errorMessage: PublishRelay<String> { get }
}

class SignInViewModel {
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var dependency = Dependency()
    var input = Input()
    var output = Output()

    struct Dependency: SignInDependency {
        let isLoading = BehaviorRelay<Bool>(value: false)
        let isSignedIn = BehaviorRelay<Bool>(value: false)
    }

    struct Input: SignInInput {
        let email = BehaviorRelay<String>(value: "")
        let password = BehaviorRelay<String>(value: "")
    }

    struct Output: SignInOutput {
        let errorMessage = PublishRelay<String>()
    }
    
}

// - MARK: - SignInService
extension SignInViewModel: SignInService {
    
    func signIn() {
        signIn(body: ModelSignInRequest(email: input.email.value, password: input.password.value))
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                
                guard let response = result.response,
                      let data = response.data else {
                          print("🔴 sign in failed")
                          self.output.errorMessage.accept("이메일이나 비밀번호를 확인해주세요.")
                          return
                      }
                
                KeychainWrapper.standard[.authToken] = data.token
                UserDefaults.standard.set(data.id, forKey: "userId")
                self.dependency.isSignedIn.accept(true)
            })
            .disposed(by: bag)
    }
}

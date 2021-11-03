//
//  SplashViewModel.swift
//  sdc
//
//  Created by byunghak on 2021/11/02.
//

import Foundation
import RxSwift
import RxRelay
import SwiftKeychainWrapper
import Alamofire

protocol SplashDependency {
    var isLoading: BehaviorRelay<Bool> { get }
}

protocol SplashOutput {
    var isAuthenticated: PublishRelay<Bool> { get }
}

class SplashViewModel {
    
    var apiSession: APIService = APISession()
    var bag = DisposeBag()
    var dependency = Dependency()
    var output = Output()
    
    struct Dependency: SplashDependency {
        var isLoading = BehaviorRelay<Bool>(value: true)
    }
    
    struct Output: SplashOutput {
        var isAuthenticated = PublishRelay<Bool>()
    }
}

extension SplashViewModel: AuthService {
    
    /// Token verification
    func verifyToken() {
        verify(body: ModelVerifyRequest.init())
            .subscribe(
                onNext: { [weak self] result in
                    guard let self = self else {
                        self?.output.isAuthenticated.accept(false)
                        return
                    }
                    
                    let response = result.response
                    
                    guard result.error == nil else {
                        self.output.isAuthenticated.accept(false)
                        self.dependency.isLoading.accept(false)
                        return
                    }
                    
                    if response?.success == true {
                        self.output.isAuthenticated.accept(true)
                    } else {
                        self.output.isAuthenticated.accept(false)
                    }
                    
                    self.dependency.isLoading.accept(false)
                },
                onError: { [weak self] _ in
                    self?.output.isAuthenticated.accept(false)
                })
            .disposed(by: bag)
        
    }
}

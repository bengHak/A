//
//  AuthService.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import RxSwift

protocol AuthService: BaseService {
    
    func signup(body: ModelSignUpRequest) -> Observable<APIResult<ModelSignUpResponse>>
    
    func signin(body: ModelSignInRequest) -> Observable<APIResult<ModelSignInResponse>>
    
    func verify(body: ModelVerifyRequest) -> Observable<APIResult<ModelVerifyResponse>>
    
}

extension AuthService {
    
    func signup(body: ModelSignUpRequest) -> Observable<APIResult<ModelSignUpResponse>> {
        let url = AuthEndpoint.signup.url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body)
        
        return apiSession.request(with: request)
    }
    
    func signin(body: ModelSignInRequest) -> Observable<APIResult<ModelSignInResponse>> {
        let url = AuthEndpoint.signin.url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body)
        
        return apiSession.request(with: request)
    }
    
    func verify(body: ModelVerifyRequest) -> Observable<APIResult<ModelVerifyResponse>> {
        let url = AuthEndpoint.verify.url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body,
                                       headers: tokenHeader)
        
        return apiSession.request(with: request)
    }
}

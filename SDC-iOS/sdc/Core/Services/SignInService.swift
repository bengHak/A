//
//  SignInService.swift
//  sdc
//
//  Created by byunghak on 2021/11/05.
//

import Foundation
import RxSwift

protocol SignInService: BaseService {
    
    func signIn(body: ModelSignInRequest) -> Observable<APIResult<ModelSignInResponse>>
    
}

extension SignInService {
    
    func signIn(body: ModelSignInRequest) -> Observable<APIResult<ModelSignInResponse>> {
        let url = AuthEndpoint.signin.url
        
        let request = URLRequest.build(url: url,
                                       method: .post,
                                       body: body)
        
        return apiSession.request(with: request)
    }
    
}

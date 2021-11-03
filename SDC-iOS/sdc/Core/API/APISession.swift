//
//  APISession.swift
//  sdc
//
//  Created by byunghak on 2021/11/03.
//

import Foundation
import Alamofire
import RxSwift

struct APISession: APIService {
    
    func request<T: Decodable> (with request: URLRequest) -> Observable<APIResult<T>> {
        return Observable<APIResult<T>>.create { observer in
            
            let request = AF.request(request)
            let task = request
                .responseJSON { response in
                    
                    self.handleResponse(request: request,
                                        response: response,
                                        observer: observer)
                }
            
            return Disposables.create{
                task.cancel()
            }
        }
    }
    
    
    /// 응답 핸들러
    private func handleResponse<T: Decodable> (request: DataRequest,
                                              response:  AFDataResponse<Any>,
                                              observer: AnyObserver<APIResult<T>>) {
        
        guard let statusCode = response.response?.statusCode else {
            // 알 수 없는 오류
            let result = APIResult<T>(error: .unknownError, response: nil)
            observer.onNext(result)
            return
        }
        
        guard let data = response.data else {
            // 통신 오류
            let result = APIResult<T>(error: .httpError(statusCode), response: nil)
            observer.onNext(result)
            return
        }
        
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            // 디코딩 오류
            let result = APIResult<T>(error: .decodingError, response: nil)
            observer.onNext(result)
            return
        }
        
        // 성공
        let result = APIResult<T>(error: nil, response: decodedData)
        
        observer.onNext(result)
    }
}

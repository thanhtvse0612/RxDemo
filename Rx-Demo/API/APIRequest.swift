//
//  APIRequest.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 2/25/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class WrapperAPI<T: Mappable> : Mappable {
    var dictionary : [String:Any]!
    var classInstance : T!
    
    required init(map: Map) {}
    
    func mapping(map: Map) {
        dictionary = map.JSON
        self.classInstance =  Mapper<T>().map(JSONObject: dictionary)!
    }
}

func apiError(_ error: String) -> NSError {
    return NSError(domain: "WikipediaAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
}

class APIRequest : ServerAPI {
    let session: URLSession
    
//    let baseUrl = "http://192.168.1.154:3000"
//    let baseUrl = "http://172.20.10.5:3000"
    let baseUrl = "http://192.168.2.75:3000"
    
    static let sharedAPI = APIRequest(session: URLSession.shared)
    
    init(session: URLSession) {
        self.session = session
    }
    
    func login(username: String, password: String) -> Observable<LoginResponse> {
        let urlString = "\(baseUrl)/api/login/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        let bodyStr  = "{\"username\":\"\(username)\", \"password\":\"\(password)\"}"
        let bodyStr = generateBodyString(param: ["username": username, "password":password]);
        print(bodyStr)
        let data = bodyStr.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return getAPIResponse(request: request)
    }
    
    func register(username: String, password: String, confirmedPassword: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.session.rx.response(request: request)
            .map { (response, _) in
                return response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    func getListProduct() -> Observable<ProductsResponse> {
        let urlString = "\(baseUrl)/api/listProduct/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        return getAPIResponse(request: request)
    }
    
    func getProductDetail(productId:Int) -> Observable<Product> {
        let urlString = "\(baseUrl)/api/productDetail/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        let bodyStr  = "{\"productId\":\"\(productId)\"}"
        let data = bodyStr.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        
        return getAPIResponse(request: request)
    }
    
    func checkout(productId:Int) -> Observable<Product> {
        let urlString = "\(baseUrl)/api/productDetail/"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        let bodyStr  = "{\"productId\":\"\(productId)\"}"
        let data = bodyStr.data(using: .utf8, allowLossyConversion: true)
        request.httpBody = data
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        request.httpMethod = "POST"
        
        return getAPIResponse(request: request)
    }
    
    // MARK - private function
    
    private func gererateRequest(param:[String:Any], method:HTTPMethod) -> URLRequest {
        
    }
    
    private func generateBodyString(param:[String:Any]) -> String {
        var resultString = "{"
        var count  = param.count
        
        param.forEach {dict in
            resultString += "\"\(dict.key)\" : \"\(dict.value)\""
            count-=1
            if count > 0 {
                resultString += ","
            }
        }
        
        return resultString + "}"
    }
    
    
    //Generic call API function for all type model implement Mappable protocol
    //This function will map response from server to object by ObjectMapper
    private func getAPIResponse<T:Mappable>(request:URLRequest) -> Observable<T> {
        return APIRequest
            .sharedAPI
            .session
            .rx
            .response(request: request)
            .debug()
            .flatMapLatest { (response:URLResponse, data:Data) -> Observable<T> in
                guard let response = response as? HTTPURLResponse else {
                    return Observable<T>.error(HTTPError.ResponseUndefined)
                }
                
                guard 200..<300 ~= response.statusCode else {
                    return Observable<T>.error(HTTPError.RequestError(statusCode: response.statusCode))
                }
                
                let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let wrapper = Mapper<WrapperAPI<T>>().map(JSONObject: jsonData)
                
                guard let unwrapper = wrapper else {
                    return Observable<T>.error(HTTPError.ResponseUndefined)
                }
                
                return Observable<T>.just(unwrapper.classInstance)
        }
    }
}

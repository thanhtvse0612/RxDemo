//
//  APIProvider.swift
//  Rx-Demo
//
//  Created by Tran Van Thanh on 4/15/17.
//  Copyright © 2017 Tran Van Thanh. All rights reserved.
//

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
    return NSError(domain: "ImageAPI", code: -1, userInfo: [NSLocalizedDescriptionKey: error])
}

class APIProvider <Element:RequestType> {
    var reqType : Element
    var req : URLRequest
    
    init(_ requestType : Element) {
        self.reqType = requestType
        let urlString = self.reqType.baseURL + self.reqType.path
        self.req = URLRequest(url: URL(string: urlString)!)
        self.req.httpMethod = self.reqType.method.rawValue
        self.req.allHTTPHeaderFields = self.reqType.headers
        if let params = self.reqType.parameters {
            let strBody = self.generateBodyString(param: params)
            self.req.httpBody = strBody.data(using: .utf8, allowLossyConversion: false)
        }
    }
    
    public func request<T:Mappable>() -> Observable<T> {
        return getAPIResponse(request: self.req)
    }
    
    // MARK: private function
    private func gemerateGETUrlString(param:[String:Any]) -> String {
        var resultString = "?"
        var count = param.count
        
        param.forEach { dict in
            let value = "\(dict.value)"
            resultString += "\(dict.key)=\(value)"
            count -= 1
            if count > 0 {
                resultString += "&"
            }
        }
        
        return resultString
    }
    
    // for application/json header
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
    
    // generic get api response from server and parse to object
    private func getAPIResponse<T:Mappable>(request:URLRequest) -> Observable<T> {
        return URLSession
            .shared
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

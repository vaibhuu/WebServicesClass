


import Foundation
import Alamofire


struct  APIRequest: EndPointProtocol {
    var path: String
    var method: HTTPMethod
    var parameter: JsonDictionary?
    var resultCompletion: APIResultBlock?
    var authorizedToken: String?
    
    var multipartItems: [MultipartFormData]?
    
    init(path: String,
         method: HTTPMethod = .get,
         parameter: JsonDictionary? = nil,
         authToken: String? = nil,
         images: [MultipartFormData]? = nil,
         completion: @escaping APIResultBlock) {
        
        self.path = path
        self.method = method
        self.parameter = parameter
        self.authorizedToken = authToken
        self.resultCompletion = completion
    }
    
    func execute() {
        print("\n============================\nAPI Name: \(path) \n Parameters: \(parameter ?? [:])\n===========================")
        APIClient.shared.performTask(with: self)
    }
    
    func executeMultiPart() {
        print("\n============================\nAPI Name: \(path) \n Parameters: \(parameter ?? [:])\n===========================")
        APIClient.shared.performMultipartTask(with: self)
    }
    
}






protocol RequestExecuter {
    var apiName: String { get }
    var method: HTTPMethod { get }
    
    func requestWith(parameter: JsonDictionary, completion: @escaping APIResultBlock)
    func requestWith(multipart items: [MultipartFormData], parameter: JsonDictionary, completion: @escaping APIResultBlock)
}

extension RequestExecuter {
    
    func requestWith(parameter: JsonDictionary, completion: @escaping APIResultBlock) {
        let url = Webservice.baseUrl + self.apiName
        let token = ""//Authorisation.accessToken
        let request = APIRequest(path: url, method: self.method, parameter: parameter, authToken: token ,completion: completion)
        
        request.execute()
    }
    
    func requestWith(multipart items: [MultipartFormData], parameter: JsonDictionary, completion: @escaping APIResultBlock) {
        
        let url = Webservice.baseUrl + self.apiName
        let token = ""//Authorisation.accessToken
        var request = APIRequest(path: url, method: self.method, parameter: parameter, authToken: token , completion: completion)
        
        request.multipartItems = items
        request.executeMultiPart()
    }
    
}

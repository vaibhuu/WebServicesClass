


import Foundation
import Alamofire


enum Webservice {
    
    static let server = APIServer.live
    static let baseUrl = server.apiBaseUrl
    static let imageBaseUrl = server.imageBaseUrl
    
    enum User: RequestExecuter {
        
        case login
        
        var method: HTTPMethod {
            switch self {
            case .login:
                return .post
            }
        }
        
        var apiName: String {
            switch self {
            case .login:
                return "user/login"
            
            }
        }
    }
    
    
}













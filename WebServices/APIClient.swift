

import Foundation
import Alamofire

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}

class APIClient: NSObject {
    
    static let shared = APIClient()
    
    let session = Alamofire.SessionManager.default
    
    func performTask(with request: APIRequest) {
        
        
        let headers = APIClient.httpsHeaders(with: request.authorizedToken)
        
        session.request(request.path, method: request.method,
                        parameters: request.parameter,
                        encoding: URLEncoding.default,
                        headers: headers)
            .responseJSON { (response) in
                switch response.result {
                case .failure(let error):
                    request.resultCompletion?(.fail(error.localizedDescription))
                    
                case .success(let value):
                    if let json = value as? ResponseBody {
                        print(json)
                        let responseObj = APIResponse(json)
                        
                        // handle your status code base response
                        
                        if responseObj.statusCode == 200 {

                            request.resultCompletion?(.success(responseObj))
                        } else if responseObj.statusCode == 401 {
                            if let loginVc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                                appDelObj.appRootViewController = loginVc
                                mySceneDelegate!.appRootViewController = loginVc
                            }
                            
                            request.resultCompletion?(.fail(responseObj.message))
                        } else {
                            request.resultCompletion?(.fail(responseObj.message))
                        }
                    } else {
                        request.resultCompletion?(.fail(ResponseParseErrorMessage))
                    }
                }
        }
    }
    
    
    
    func performMultipartTask(with request: APIRequest) {
        
//        if !Connectivity.isConnectedToInternet {
//            Alert.showError(message: "No Internet")
//            return
//        }
        
        let headers = APIClient.httpsHeaders(with: request.authorizedToken)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            for item in request.multipartItems! {
//                multipartFormData.append(item.data!,
//                                         withName: item.name,
//                                         fileName: item.filename,
//                                         mimeType: item.mimeType.rawValue)
            }
            
            if let params = request.parameter {
                for (key, value) in params {
                    if value is String {
                    multipartFormData.append((value as! String).data(using: .utf8)!, withName: key)
                    } else {
                        multipartFormData.append(("\(value)").data(using: .utf8)!, withName: key)
                    }
                }
            }
            
        }, to: request.path, method: .post, headers: headers) { (result) in
            
            switch result {
            case .failure(let error):
                request.resultCompletion?(.fail(error.localizedDescription))
                
            case .success(let upload, _, _) :
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                upload.responseJSON { (response) in
                    switch response.result {
                    case .failure(let error ):
                        request.resultCompletion?(.fail(error.localizedDescription))
                        
                    case .success(let value):
                        if let json = value as? ResponseBody {
                            let response = APIResponse(json)
                            
                            if response.statusCode == 200 {
                                print(response.body ?? "")
                                request.resultCompletion?(.success(response))
                            } else if response.statusCode == 401 {
                                if let loginVc = mainStoryboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                                    appDelObj.appRootViewController = loginVc
                                    mySceneDelegate!.appRootViewController = loginVc
                                }
                                request.resultCompletion?(.fail(response.message))

                            } else {
                                request.resultCompletion?(.fail(response.message))
                            }
                        } else {
                            request.resultCompletion?(.fail(ResponseParseErrorMessage))
                        }
                    }
                }
            }
        }
    }
    
    
    func performDownloadTask(with request: APIRequest) {
        
    }
    
    func performUploadTask(with endpoint: APIRequest) {
        
    }
    
    
    
    // class methods
    class func httpsHeaders(with token: String?) -> HTTPHeaders {
        var defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        if let token = Authorisation.user.data?.vAuthToken as? String {
            defaultHeaders["Vauthtoken"] = "Bearer \(token)"
        }
        return defaultHeaders
    }
    
}


// MARK: - Helper Classes

struct APIResponse {
    var statusCode: Int = -1
    var body: ResponseBody?
    var message: String = ""
    
    init() {
        //
    }
    
    init(_ json: ResponseBody) {
        // handle response code and message
        // it may be different as per API development.
       
        var code = json["status"] as? Int
        
//        var code = json["status"] as? Int
        // custom status can be handle here as per server response.
        //example
        if code == nil {
            code = Int(json["status"] as! String)
        }
        
        // handle response message
        let msg = json["message"] as? String
        
        statusCode = code!
        body =  json
        message = msg ?? ""
    }
    
}

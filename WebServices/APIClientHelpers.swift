


import Foundation
import Alamofire


enum ApiError: Error {
    case networkNotAvailable
    case serverError
    
    var localizedDescription: String {
        switch self {
        case .networkNotAvailable:
            return "networkNotAvailable"
        case .serverError:
            return "serverError"
        }
    }
}


typealias JsonDictionary = [String : Any]
typealias JsonArray = [JsonDictionary]

typealias APIResultBlock = (APIClientResult) -> Void

typealias ResponseBody = [String : Any]

let ResponseParseErrorMessage = "Sorry! we couldn't parse the server response."



// Result : will be returned to API caller
enum APIClientResult {
    case fail(String)
    case success(APIResponse)
}

// not using in current version
enum APIClientUploadDownloadResult {
    case fail(String)
    case success(Any)
    case progress(Float)
}

protocol EndPointProtocol {
    var path: String { get set }
    var method: HTTPMethod  { get set }
    var parameter: JsonDictionary?  { get set }
    var resultCompletion: APIResultBlock?  { get set }
}



class MultipartFormData {
    var name = ""
    var data: Data?
    var mimeType = MIMEType.image_png
    var filename = ""
    
    init(data: Data, fileName: String = "file", name: String = "name", mimeType: MIMEType = .image_png) {
        self.name = name
        self.data = data
        self.filename = fileName
        self.mimeType = mimeType
    }
    
    enum MIMEType: String {
        case text_plain = "text/plain"
        case text_html = "text/html"
        case text_javascript = "text/javascript"
        case text_css = "text/css"
        case image_jpeg = "image/jpeg"
        case image_png = "image/png"
        case audio_mepg = "audio/mpeg"
        case audio_ogg = "audio/ogg"
        case video_mp4 = "video/mp4"
    }
}

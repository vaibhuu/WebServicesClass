

import Foundation


enum APIServer {
    
    case live, development
    
    var domainUrl: String {
        switch self {
      
        case .live:
            return "" //LiveBaseUrl

        case .development:
            return "" //DevelopmentBaseUrl
        }
    }
    
    var apiBaseUrl: String {
        switch self {
        case .live:
            return "\(self.domainUrl)"

        case .development:
            return "\(self.domainUrl)"
        }
    }
    
    var imageBaseUrl: String {
        switch self {
        case .live:
            return ""
        case .development:
            return ""
        }
    }
}

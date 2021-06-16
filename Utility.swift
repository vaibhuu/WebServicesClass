import Foundation
import NVActivityIndicatorView
import AVFoundation
import Alamofire
import Toast_Swift

//MARK:- Debouncer Class
class Debouncer {
    var pendingRequestItem: DispatchWorkItem?
    
    func debounce(after delay: Double = 0.5, _ block: @escaping ()->Void) {
        self.cancel()
        
        let requestWorkItem = DispatchWorkItem(block: block)
        pendingRequestItem = requestWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: requestWorkItem)
    }
    
    func cancel() {
        pendingRequestItem?.cancel()
    }
}



//MARK:- Extension UIViewController
extension UIViewController {
    
    //MARK:- Loader
    func showLoader() {
        
        if isReachable() == false
        {
            showToastMessage(message: "Please check connectivity")
            return
        }
        
        let x = ActivityData(size: CGSize(width: 100, height: 100), message: "", messageFont: nil, type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.white, padding: 0.0, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3), textColor: nil)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(x)
    }
    
    func hideLoader() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
        })
        
    }
    
    
    //MARK:- Toast
    func showToastMessage(message:String) {
        self.view.makeToast(message, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: (UIApplication.shared.keyWindow?.safeAreaInsets.top)! + 80), title: nil, image: nil, completion: nil)
    }
    
    //MARK:- Reachability
    func isReachable() -> Bool
    {
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        return (reachabilityManager?.isReachable)!
    }
}


//MARK:- Extension view
extension UIView {
    
    //MARK: - IBInspectable
    @IBInspectable var cornerRadiusView:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }
    
    
    //Set Border Color
    @IBInspectable var borderColor:UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
    }
    
    //Set Border Width
    @IBInspectable var borderWidth:CGFloat {
        set {
            self.layer.borderWidth = newValue
        }
        get {
            return self.layer.borderWidth
        }
    }
    
}

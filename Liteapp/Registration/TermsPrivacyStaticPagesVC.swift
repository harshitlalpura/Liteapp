//
//  TermsPrivacyStaticPagesVC.swift
//  Liteapp
//
//  Created by Apurv Soni on 21/08/22.
//

import UIKit
import WebKit


class TermsPrivacyStaticPagesVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    // MARK: - Variables
    var webView : WKWebView?
    var isForTerms : Bool = true
    var docURL : URL?
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if isForTerms{
            lblTitle.text = "End User License Agreement"
        }
        else{
            lblTitle.text = "Privacy Policy"
        }
        self.setupWebview()
        self.fetchStaticContentAPI()
    }
    
    func setupWebview(){
        DispatchQueue.main.async { [self] in

            self.webView = WKWebView(frame: self.viewContainer.bounds)
            self.webView?.backgroundColor = UIColor.clear
            self.viewContainer.addSubview(self.webView!)
            self.webView?.navigationDelegate = self
        }
    }
    
    // MARK: - Button actions
    @IBAction func btnBackTapped(_ sender: Any) {
        self.popVC()
    }
    
    // MARK: - API Call
    func fetchStaticContentAPI(){
        ProgressHUD.show()
        var strEndpoint = ""
        if isForTerms{
            strEndpoint = APIEndPoints.termsOfService()
        }
        else{
            strEndpoint = APIEndPoints.privacyPolicy()
        }
        NetworkLayer.sharedNetworkLayer.getWebApiCall(apiEndPoints: strEndpoint, param: nil) { success, response, error in
            if let res = response{
                print(res)
                if let status = res["status"] as? Int{
                    if status == 0{
                        ProgressHUD.hide()
                        if let messagae  = res["message"] as? String{
                            self.showAlert(alertType:.validation, message: messagae)
                            
                        }
                    }else{
                        //Load Data
                        if let htmlData  = res["data"] as? String{
                            self.webView?.loadHTMLString(htmlData, baseURL: nil)
                        }
                        else{
                            ProgressHUD.hide()
                            self.showAlert(alertType:.validation, message: "Something went wrong, Please try again later.")
                        }
                        
                    }
                }
                
            }else if let err = error{
                ProgressHUD.hide()
                print(err)
            }

        }
    }
}

extension TermsPrivacyStaticPagesVC : WKNavigationDelegate{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        ProgressHUD.hide()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        ProgressHUD.hide()
    }
}

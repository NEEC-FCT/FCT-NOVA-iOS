//
//  Mapa.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import WebKit

class Noticias: UIViewController  , WKNavigationDelegate {
    
    @IBOutlet weak var webview: WKWebView!
    var back:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.back = false
        webview.isHidden = true
        let url = URL (string: "https://www.fct.unl.pt/noticias")
        let requestObj = URLRequest(url: url!)
        webview.load(requestObj)
        webview.navigationDelegate = self


        
    }
    
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
         webview.isHidden = true
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print(urlStr)
            if(urlStr.hasPrefix("https://www.fct.unl.pt/noticias/")){
                
                self.back = true
                guard let url = URL(string: urlStr) else { return }
                UIApplication.shared.open(url)
             
    
            }
            
            
        }
        decisionHandler(.allow)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        
        
        if(self.back){
            self.back = false
            webview.goBack()
        }
        webview.evaluateJavaScript("document.getElementById(\"sliding-popup\").style.display=\"none\";"
            + "document.getElementById('header3').style.display='none';"
            + "document.getElementById('content_top').style.display='none';"
            + "document.getElementById('header2').style.display='none';"
            + "document.getElementById('header1').style.display='none';"
            + "document.getElementById('breadcrumb').style.display='none';"
            + "document.getElementById('footer').style.display='none';", completionHandler: nil)
        
        
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.webview.isHidden = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


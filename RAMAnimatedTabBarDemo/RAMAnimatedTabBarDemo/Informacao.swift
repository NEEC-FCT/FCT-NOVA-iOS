//
//  Informacao.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 04/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class Informacao: UIViewController  , WKNavigationDelegate {
    
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.navigationDelegate = self
        
        let url = URL (string: "https://fctapp.neec-fct.com/Informacao/")
        let requestObj = URLRequest(url: url!)
        webview.load(requestObj)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //abre os links externamente
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print(urlStr)
            //mudar para o safari ou calendario
            /*
            if( !urlStr.hasPrefix("https://fctapp.neec-fct.com/equipa/") && !urlStr.hasPrefix("https://fctapp.neec-fct.com/SobreNEEC/") ){
                guard let url = URL(string: urlStr) else { return }
                UIApplication.shared.open(url)
                //Go back
                if( separator == 0){
                    
                    let url = URL (string: "https://fctapp.neec-fct.com/SobreNEEC/")
                    let requestObj = URLRequest(url: url!)
                    webview.load(requestObj)
                }
                if( separator == 1){
                    let url = URL (string: "https://fctapp.neec-fct.com/equipa/about.html")
                    let requestObj = URLRequest(url: url!)
                    webview.load(requestObj)
                }
            }*/
        }
        decisionHandler(.allow)
    }
    
}

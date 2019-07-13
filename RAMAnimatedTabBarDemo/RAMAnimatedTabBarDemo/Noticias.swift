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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.isHidden = true
        let url = URL (string: "https://www.fct.unl.pt/noticias")
        let requestObj = URLRequest(url: url!)
        webview.load(requestObj)
        webview.navigationDelegate = self


        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        webview.evaluateJavaScript("document.getElementById(\"sliding-popup\").style.display=\"none\";"
            + "document.getElementById('header3').style.display='none';"
            + "document.getElementById('content_top').style.display='none';"
            + "document.getElementById('header2').style.display='none';"
            + "document.getElementById('header1').style.display='none';"
            + "document.getElementById('breadcrumb').style.display='none';"
            + "document.getElementById('footer').style.display='none';", completionHandler: nil)
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.webview.isHidden = false
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


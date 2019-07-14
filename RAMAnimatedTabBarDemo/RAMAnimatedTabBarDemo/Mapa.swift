//
//  Mapa.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import WebKit

class Mapa: UIViewController , WKNavigationDelegate {
    

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.isHidden = true
        let url = URL (string: "https://www.google.com/maps/d/viewer?mid=1puDPKCs1qt4eyU1fK2EfzPCHyQzkfm6n&ll=38.661303032631146%2C-9.205898544352294&z=16")
        let requestObj = URLRequest(url: url!)
        webview.load(requestObj)
        webview.navigationDelegate = self
        

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webview.evaluateJavaScript("document.getElementById('gbr').style.display='none';", completionHandler: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.webview.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


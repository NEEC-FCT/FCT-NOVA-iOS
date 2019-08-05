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
    var currentURL:String = "https://www.fct.unl.pt/noticias"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (UserDefaults.standard.string(forKey: "intro") == nil) {
            // show intro
            OperationQueue.main.addOperation {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Intro")
                self.present(newViewController, animated: true, completion: nil)
            }
        }
        else{
        
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))

        webview.navigationDelegate = self
        
        let url = URL (string: "https://www.fct.unl.pt/noticias")
        let requestObj = URLRequest(url: url!)
        webview.isHidden = true
        webview.load(requestObj)
          }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.webview.isHidden = true
        webview.evaluateJavaScript( "document.getElementById(\"sliding-popup\").style.display=\"none\";" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('header3').style.display='none';" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('content_top').style.display='none';" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('header2').style.display='none';" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('header1').style.display='none';" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('breadcrumb').style.display='none';" , completionHandler: nil)
        webview.evaluateJavaScript( "document.getElementById('footer').style.display='none';" , completionHandler: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50) {
            self.webview.isHidden = false
        }
    }
    
    //abre os links externamente
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            webview.isHidden = true
            if( urlStr.hasPrefix("https://www.fct.unl.pt/noticias/20") ){
                guard let url = URL(string: urlStr) else { return }
                UIApplication.shared.open(url)
                //Go back
                    let home = URL (string: self.currentURL)
                    let requestObj = URLRequest(url: home!)
                    webview.load(requestObj)
                
            }
            else if( urlStr.hasPrefix("https://www.fct.unl.pt/noticias?page=")){
                self.currentURL = urlStr
            }
            
        }
        decisionHandler(.allow)
    }
    
    

    
    
    func myHandler(alert: UIAlertAction){
        if( CheckInternet.Connection() == false)
        {
            let controller = UIAlertController(title: "Sem internet" , message: "Esta aplicação necessita de internet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: myHandler)
            
            controller.addAction(ok)
            present(controller, animated: true, completion: nil)
        }
        else{
            let url = URL (string: "https://www.fct.unl.pt/noticias")
            let requestObj = URLRequest(url: url!)
            webview.isHidden = true
            webview.load(requestObj)
            
        }
    }
    
    
}


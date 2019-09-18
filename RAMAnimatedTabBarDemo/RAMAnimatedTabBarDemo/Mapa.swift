//
//  Mapa.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 J.Veloso . All rights reserved.
//
import UIKit
import WebKit

class Mapa: UIViewController , WKNavigationDelegate {
    
    @IBOutlet weak var webview: WKWebView!
    var separator:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))
        
        webview.navigationDelegate = self

        let url = URL (string: "https://www.google.com/maps/d/viewer?mid=1puDPKCs1qt4eyU1fK2EfzPCHyQzkfm6n&ll=38.661303032631146%2C-9.205898544352294&z=16")
        let requestObj = URLRequest(url: url!)
        webview.isHidden = true
        webview.load(requestObj)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        webview.evaluateJavaScript("javascript:(function() { " +
            "document.getElementById('gbr').style.display='none';})()"
            , completionHandler: nil)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.webview.isHidden = false
        }
    }
    
    //abre os links externamente
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print(urlStr)
            if( urlStr.hasPrefix("https://accounts.google.com/") ){
                guard let url = URL(string: urlStr) else { return }
                UIApplication.shared.open(url)
                //Go back
                if( separator == 0){
                    
                    let url = URL (string: "https://www.google.com/maps/d/viewer?mid=1puDPKCs1qt4eyU1fK2EfzPCHyQzkfm6n&ll=38.661303032631146%2C-9.205898544352294&z=16")
                    let requestObj = URLRequest(url: url!)
                    webview.isHidden = true
                    webview.load(requestObj)
                }
                 if( separator == 1){
                    let url = URL (string: "https://www.google.com/maps/d/u/0/viewer?mid=1TdpAcDgdncinIqJLrr504ZMAJe6zQ2il&ll=38.661303032631146%2C-9.205898544352294&z=16")
                    let requestObj = URLRequest(url: url!)
                    webview.isHidden = true
                    webview.load(requestObj)
                }
                
                 if(separator == 2){
                    let url = URL (string: "https://www.google.com/maps/d/u/0/viewer?mid=1pDVA9v49vnMkY9QF49Bxvxi08m39VSLq&ll=38.661303032631146%2C-9.205898544352294&z=16")
                    let requestObj = URLRequest(url: url!)
                    webview.isHidden = true
                    webview.load(requestObj)
                }
            }
        }
        decisionHandler(.allow)
    }
   
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
        
        
        if( sender.selectedSegmentIndex == 0){
            separator = 0
            let url = URL (string: "https://www.google.com/maps/d/viewer?mid=1puDPKCs1qt4eyU1fK2EfzPCHyQzkfm6n&ll=38.661303032631146%2C-9.205898544352294&z=16")
            let requestObj = URLRequest(url: url!)
            webview.isHidden = true
            webview.load(requestObj)
        }
        if( sender.selectedSegmentIndex == 1){
            separator = 1
            let url = URL (string: "https://www.google.com/maps/d/u/0/viewer?mid=1TdpAcDgdncinIqJLrr504ZMAJe6zQ2il&ll=38.661303032631146%2C-9.205898544352294&z=16")
            let requestObj = URLRequest(url: url!)
            webview.isHidden = true
            webview.load(requestObj)
        }
        if( sender.selectedSegmentIndex == 2){
            separator = 1
            let url = URL (string: "https://www.google.com/maps/d/u/0/viewer?mid=1pDVA9v49vnMkY9QF49Bxvxi08m39VSLq&ll=38.661303032631146%2C-9.205898544352294&z=16")
            let requestObj = URLRequest(url: url!)
            webview.isHidden = true
            webview.load(requestObj)
        }
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
            let url = URL (string: "https://www.google.com/maps/d/viewer?mid=1puDPKCs1qt4eyU1fK2EfzPCHyQzkfm6n&ll=38.661303032631146%2C-9.205898544352294&z=16")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
    }
}

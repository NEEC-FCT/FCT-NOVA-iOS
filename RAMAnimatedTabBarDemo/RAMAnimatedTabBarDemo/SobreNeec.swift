//
//  SobreNeec.swift
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 J.Veloso All rights reserved.
//

import UIKit
import WebKit

class SobreNeec: UIViewController  , WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    var separator:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         webview.navigationDelegate = self

          if (UserDefaults.standard.string(forKey: "intro") == nil) {
            // show intro
            OperationQueue.main.addOperation {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "Intro")
                self.present(newViewController, animated: true, completion: nil)
            }
        }
        
          else{
            let url = URL (string: "https://fctapp.neec-fct.com/SobreNEEC/")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
                
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
            }
        }
        decisionHandler(.allow)
    }
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
   
        
        if( sender.selectedSegmentIndex == 0){
            separator = 0
            let url = URL (string: "https://fctapp.neec-fct.com/SobreNEEC/")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
        if( sender.selectedSegmentIndex == 1){
            separator = 1
            let url = URL (string: "https://fctapp.neec-fct.com/equipa/about.html")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
    }
    }

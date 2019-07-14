//
//  SobreNeec.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import WebKit

class SobreNeec: UIViewController  , WKNavigationDelegate {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
   
        
        if( sender.selectedSegmentIndex == 0){
            
            //TODO colocar algo sobre o NEEC
            /*let url = URL (string: "https://fctapp.neec-fct.com/equipa/about.html")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)*/
        }
        if( sender.selectedSegmentIndex == 1){
            let url = URL (string: "https://fctapp.neec-fct.com/equipa/about.html")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
    
    }
    
    
    }

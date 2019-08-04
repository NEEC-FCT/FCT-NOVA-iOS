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
import JJFloatingActionButton


class Informacao: UIViewController  , WKNavigationDelegate {
    
    
    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview.navigationDelegate = self
        
        //FAB
        let actionButton = JJFloatingActionButton()
        actionButton.buttonImage = UIImage(named: "security")
        actionButton.addItem(title: "Alarme de evacuação", image: UIImage(named: "firealarm")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        actionButton.addItem(title: "Doença súbita/acidente", image: UIImage(named: "disease")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        actionButton.addItem(title: "Fogo", image: UIImage(named: "fire")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        actionButton.addItem(title: "Ligar segurança", image: UIImage(named: "call")?.withRenderingMode(.alwaysTemplate)) { item in
            // liga seguranca
         
            let alert = UIAlertController(title: "Contactar Segurança", message: "Não te esqueças:\n" +
                "o Localização\n" +
                "o Número de vítimas e idade\n" +
                "o Sintomas ou informações importantes\n" +
                "o Outros perigos (gases perigosos, incêndio)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Não é grave", style: .default, handler: { action in
                guard let number = URL(string: "tel://+351916025546" ) else { return }
                UIApplication.shared.open(number)
                }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Grave", style: .default, handler: { action in
                guard let number = URL(string: "tel://112" ) else { return }
                UIApplication.shared.open(number)
            }))
            
            self.present(alert, animated: true)
            
        }
        actionButton.addItem(title: "Sismo", image: UIImage(named: "earthquakes")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }

        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        
        //Load Webview
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

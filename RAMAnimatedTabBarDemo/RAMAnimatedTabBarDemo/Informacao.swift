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
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func indexChanges(_ sender: Any) {
        
        switch segmentedControl.selectedSegmentIndex
        {
        case 0: break
           
        case 1:
            segmentedControl.selectedSegmentIndex = 0
           
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                self.performSegue(withIdentifier: "allogin", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }

            break
            
        case 2:
            segmentedControl.selectedSegmentIndex = 0
           
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                 self.performSegue(withIdentifier: "gotoFicheiros", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }
            break
            
        case 3:
            segmentedControl.selectedSegmentIndex = 0
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                self.performSegue(withIdentifier: "gotoAval", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }
            break
           
        default:
            break
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get key
        let tab = UserDefaults.standard.integer(forKey: "TabClip")
        UserDefaults.standard.removeObject(forKey: "TabClip")
        switch tab
        {
        case 0: break
            
        case 1:
            segmentedControl.selectedSegmentIndex = 0
            
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                self.performSegue(withIdentifier: "allogin", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }
            
            break
            
        case 2:
            segmentedControl.selectedSegmentIndex = 0
            
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                self.performSegue(withIdentifier: "gotoFicheiros", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }
            break
            
        case 3:
            segmentedControl.selectedSegmentIndex = 0
            if( (UserDefaults.standard.string(forKey: "password") ?? nil ) != nil &&  (UserDefaults.standard.string(forKey: "username") ?? nil ) != nil){
                self.performSegue(withIdentifier: "gotoAval", sender: nil)
                
            }
            else{
                self.performSegue(withIdentifier: "cliplogin", sender: nil)
            }
            break
            
        default:
            break
        }
        
        webview.navigationDelegate = self
        //FAB
        let actionButton = JJFloatingActionButton()
        actionButton.buttonImage = UIImage(named: "sos-warning")
        actionButton.addItem(title: "Alarme de evacuação", image: UIImage(named: "firealarm")?.withRenderingMode(.alwaysTemplate)) { item in
            
            UserDefaults.standard.set(6, forKey: "open")
            self.performSegue(withIdentifier: "seguranca", sender: nil)
            
        }
        actionButton.addItem(title: "Doença súbita/acidente", image: UIImage(named: "disease")?.withRenderingMode(.alwaysTemplate)) { item in
            
            UserDefaults.standard.set(5, forKey: "open")
            self.performSegue(withIdentifier: "seguranca", sender: nil)
        }
        actionButton.addItem(title: "Fogo", image: UIImage(named: "fire")?.withRenderingMode(.alwaysTemplate)) { item in
    
            UserDefaults.standard.set(7, forKey: "open")
            self.performSegue(withIdentifier: "seguranca", sender: nil)
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
           
            UserDefaults.standard.set(8, forKey: "open")
            self.performSegue(withIdentifier: "seguranca", sender: nil)
            
        }

        
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true

        actionButton.buttonColor = .red
        
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
            if( !urlStr.hasPrefix("https://fctapp.neec-fct.com/") ){
                guard let url = URL(string: urlStr) else { return }
                UIApplication.shared.open(url)
                //Go back
                //Load Webview
                let home = URL (string: "https://fctapp.neec-fct.com/Informacao/")
                let requestObj = URLRequest(url: home!)
                webview.load(requestObj)
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
            let url = URL (string: "https://fctapp.neec-fct.com/Informacao/")
            let requestObj = URLRequest(url: url!)
            webview.load(requestObj)
        }
    }
    
}

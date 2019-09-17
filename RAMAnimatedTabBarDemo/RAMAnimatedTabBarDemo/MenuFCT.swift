//
//  SobreNeec.swift
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 J.Veloso All rights reserved.
//

import UIKit


class MenuFCT: UIViewController  {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
    }
    
    func gotoTabView( tab : Int) {
        UserDefaults.standard.set( tab , forKey: "open")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "RAMAnimatedTabBarController") as! RAMAnimatedTabBarController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func powerbyClicked(_ sender: Any) {
        guard let url = URL(string: "https://neec-fct.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func neeclogoClicked(_ sender: Any) {
        guard let url = URL(string: "https://neec-fct.com/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    @IBAction func propinasClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Brevemente", message: "Estamos a desenvolver esta funcionalidade, obrigado pela compreensão", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func sobreClicked(_ sender: Any) {
        guard let url = URL(string: "https://fctapp.neec-fct.com/equipa/about.html") else { return }
        UIApplication.shared.open(url)

    }
    
    @IBAction func happyClicked(_ sender: Any) {
    }
    

    @IBAction func ecoClicked(_ sender: Any) {
        gotoTabView(tab: 4)
    }
    
    
    @IBAction func infoClicked(_ sender: Any) {
         gotoTabView(tab: 2)
    }
    
    @IBAction func mapaClicked(_ sender: Any) {
         gotoTabView(tab: 4)
    }
    
    @IBAction func calenClicked(_ sender: Any) {
         gotoTabView(tab: 3)
    }
    
    
    @IBAction func avaliacaoClicked(_ sender: Any) {
    }
    
    
    @IBAction func clipClicked(_ sender: Any) {
    }
    
    
    @IBAction func horariocliked(_ sender: Any) {
    }
    
    
    @IBAction func faceClicked(_ sender: Any) {
        guard let url = URL(string: "https://www.facebook.com/fct.nova/") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func instaClicked(_ sender: Any) {
        guard let url = URL(string: "https://www.instagram.com/fctnova/") else { return }
        UIApplication.shared.open(url)
    }
    
    
}

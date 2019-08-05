//
//  ScreenSeguranca.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 05/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import Foundation

import UIKit
import WebKit

class ScreenSeguranca: UIViewController   {
    
    @IBOutlet weak var imagem: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screen =  UserDefaults.standard.integer(forKey: "open")
        
        if(screen == 5){
            imagem.image = UIImage(named: "doenca")
            view.backgroundColor = self.hexStringToUIColor( hex: "#63b6e6")
        }
        else if(screen == 6){
            imagem.image = UIImage(named: "alarme")
            view.backgroundColor = self.hexStringToUIColor( hex: "#f0d826")
        }
        else if(screen == 7){
            imagem.image = UIImage(named: "fogo")
            view.backgroundColor = self.hexStringToUIColor( hex: "#6600CC")
        }
        else if(screen == 8){
            imagem.image = UIImage(named: "sismo")
            view.backgroundColor = self.hexStringToUIColor( hex: "#eaa932")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func myHandler(alert: UIAlertAction){
        if( CheckInternet.Connection() == false)
        {
            let controller = UIAlertController(title: "Sem internet" , message: "Esta aplicação necessita de internet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: myHandler)
            controller.addAction(ok)
            present(controller, animated: true, completion: nil)
        }
     
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

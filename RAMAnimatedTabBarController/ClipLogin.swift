//
//  ClipLogin.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 30/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation

class ClipLogin: UIViewController  {
    
    @IBOutlet weak var logintext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        print( logintext.text as! String)
        print( passwordtext.text as! String)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        print("Go Clip Login")
        
      
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  studenNumber.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 02/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import Foundation
import UIKit


class studenNumber: UIViewController  {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Select NUmber")
        print("Recebi")
        let defaults = UserDefaults.standard
        let number = defaults.stringArray(forKey: "numero") ?? [String]()
        let texto = defaults.stringArray(forKey: "texto") ?? [String]()
        let url = defaults.stringArray(forKey: "url") ?? [String]()
        print(number)
        //gotoID
        

        
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}



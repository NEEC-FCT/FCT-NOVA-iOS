//
//  SobreNeec.swift
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 J.Veloso All rights reserved.
//

import UIKit
import WebKit

class SobreNeec: UIViewController  {


    
    override func viewDidLoad() {
        super.viewDidLoad()
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuFCT") as! MenuFCT
        self.present(nextViewController, animated:true, completion:nil)
                
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
    }

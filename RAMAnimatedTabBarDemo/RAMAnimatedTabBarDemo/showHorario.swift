//
//  showHorario.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 31/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//


import UIKit
import Foundation
import SwiftSoup


class showHorario: UIViewController  {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Show horario")
           ApiService.callGetHorario(year: "2019/20", studentNumberId: "88508", semester: 1, finish: finishGetHorario)
        //gotoID
    
        
    }
    
    
    func finishGetHorario(message:String, data:Data?) -> Void
    {
        do
        {
            print(message)
            print("----Horario---")
            
            let html = String(decoding: data!, as: UTF8.self)
            print( html )
            /*
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let links: Array<Element> = try doc.select("a[href]").array()
                for link in links {
                    let linkHref = try link.attr("href")
                    let matched = matches(for: "/utente/eu/aluno/ano_lectivo[?][_a-zA-Z0-9=;&.%]*ano_lectivo=[0-9]*", in: linkHref)
                    if( matched != []){
                        let year = try link.text()
                        print(year)
                    }
                    
                }
                
            }  catch {
                print("error")
            }
            
            /*
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "gotohorario", sender: nil)
            }*/
            */
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



//
//  ChooseYear.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 31/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup


class ChooseYear: UIViewController  {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Select Year")
        //gotoID
        
         ApiService.callGetYears(url: URL(string: "https://clip.unl.pt/utente/eu/aluno?aluno=88508")!, finish: finishGetYear)
        
        
    }
    
    func finishGetYear (message:String, data:Data?) -> Void
    {
        do
        {
            print(message)
            print("-------")
            let html = String(decoding: data!, as: UTF8.self)
            //print( html )
            
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
            
         /*   DispatchQueue.main.async {
                self.performSegue(withIdentifier: "gotoID", sender: nil)
            }*/
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func matches(for regex: String, in text: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}



//
//  avalicao.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 17/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup

class showAulas: UIViewController  {
    
    var id:String = ""
    var ano:String = ""
    var semestre:Int = 1
    var html:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        semestre = defaults.integer(forKey: "semestreSelected")
        id =  defaults.string(forKey: "IDaluno")!
        ano = defaults.string(forKey: "urlSelect")!
        print("Recebi " + id + " " + ano)
        ApiService.callGetgetClassesDocs(year: self.ano, course: "11174", docType: "0ac", studentNumberId: self.id, semester: self.semestre , finish: self.finishGetAvalicacao )
        
        
    }
    
    func finishGetAvalicacao (message:String, data:Data?) -> Void {
        
        
        print("Recebi")
        let html = String(data: data!, encoding: .isoLatin1)
        //print( html! )
        do {
            let doc: Document = try SwiftSoup.parse(html!)
            let docs: Elements = try doc.body()!.select("form[method=post]").array()[1].select("tr");
            
            
            for doc in docs {
                if (!doc.hasAttr("bgcolor")){ continue };
                
                
                print("File data")
                print(try doc.child(0).text());
                print(try doc.child(1).child(0).attr("href"));
                print( try doc.child(2).text());
                print( try doc.child(3).text());
                print( try doc.child(4).text());
                
            }
            
            
            
        }  catch {
            print("error")
        }
        //Falta ser processado
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

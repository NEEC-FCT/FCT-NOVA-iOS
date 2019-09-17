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

class showFiles: UIViewController  {
    
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
        ApiService.callGetgetClassesDocs(year: self.ano , studentNumberId: self.id,  finish: self.finishGetAvalicacao )
        
        
    }
    
    func finishGetAvalicacao (message:String, data:Data?) -> Void {
        
        
        print("Recebi Files")
        let html = String(data: data!, encoding: .isoLatin1)
        print( html! )
        do {
            let doc: Document = try SwiftSoup.parse(html!)
            let hrefs: Elements = try doc.body()!.select("a[href]")
            
            for  href in hrefs {
                
            let linkHref = try href.attr("href");
                
         
                
            if(linkHref.matches("/utente/eu/aluno/ano_lectivo/unidades[?](.)*&tipo_de_per%EDodo_lectivo=s&(.)*")) {
          
                let class_url = linkHref.split(separator: "&");
                let semester = class_url[class_url.count - 1];
                let classID = class_url[class_url.count - 3];
                let className = try href.text();
                let semester_final = semester.suffix( semester.count - 1)
                let classID_final = classID.suffix(10);
                print("Classes")
                print(className);
                print(semester_final.split(separator: "=")[1]);
                print( classID_final.split(separator: "=")[1] );
                
                 }
            else if(linkHref.matches("/utente/eu/aluno/ano_lectivo/unidades[?](.)*&tipo_de_per%EDodo_lectivo=t&(.)*")){
                
                let class_url = linkHref.split(separator: "&");
                
                //String semester = class_url[class_url.length - 1];
                let classID = class_url[class_url.count - 3];
                
                let className = try href.text();
                //int semester_final = Integer.valueOf(semester.substring(semester.length() - 1));
                 let classID_final = classID.suffix( 8 );
                print(className);
                print( classID_final.split(separator: "=")[1] );
                print ("3")
                
                }
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


extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

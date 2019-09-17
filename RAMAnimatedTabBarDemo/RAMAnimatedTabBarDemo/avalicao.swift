//
//  avalicao.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 17/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit

class avaliacao: UIViewController  {
    
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
        ApiService.callGetTestCalendar(year: self.ano , studentNumberId: self.id, semester: self.semestre , finish: self.finishGetAvalicacao)
        
    }
    
    func finishGetAvalicacao (message:String, data:Data?) -> Void {
        
 
            print("Recebi")
            let html = String(data: data!, encoding: .isoLatin1)
            print( html! )
           //Falta ser processado
            
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

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
           ApiService.callGetHorario(year: "2018/19", studentNumberId: "88508", semester: 1, finish: finishGetHorario)
        //gotoID
    
        
    }
    
    
    func finishGetHorario(message:String, data:Data?) -> Void
    {
        do
        {
            print(message)
            print("----Horario---")
            
            let html = String(decoding: data!, as: UTF8.self)
            //print( html )
            
            do {
                let doc: Document = try SwiftSoup.parse(html)
                let trs: Array<Element> = try doc.select("tr[valign=center]").array()
                for tr in trs {
                    
                    let tds = try tr.select("td[class~=turno.* celulaDeCalendario]");
                    
                    for td in tds {
                        let child  = td.child(0).children();
            
                        var href = try child.get(2).attr("href").split(separator: "&");
                        let dia = href[9];
                        let turno = href[7].uppercased();
                        
                        let horas_inicio = try tr.child(0).html();
                        
                        let horas_fim = tr.child(2);
                        //Teoria ir ver sala
                        var scheduleClassRoom:String? = nil ;
                        //
                        if( try tr.child(2).html().count > 250 ){
                         
                            scheduleClassRoom = String(try tr.child(2).html()).slice(from: "</a>\n <br>", to: "\n</div>")!
                           
                        }
                        if( try tr.child(3).html().count > 250 ){
                            
                            scheduleClassRoom = String(try tr.child(3).html()).slice(from: "</a>\n <br>", to: "\n</div>")!
                            
                        }
                        
                        if( try tr.child(4).html().count > 250 ){
                            
                            scheduleClassRoom = String(try tr.child(4).html()).slice(from: "</a>\n <br>", to: "\n</div>")!
                            
                        }
                        
                        if( try tr.child(5).html().count > 250 ){
                            
                            scheduleClassRoom = String(try tr.child(5).html()).slice(from: "</a>\n <br>", to: "\n</div>")!
                            
                        }
                        
                        //print("Continua")
                        //print( try tr.child(6).html() )
                
                       // print(horas_fim)
                        
                        var scheduleDayNumber:Int = -1
                        let stringArray = String(dia).components(separatedBy: CharacterSet.decimalDigits.inverted)
                        for item in stringArray {
                            if let number = Int(item) {
                               scheduleDayNumber = number
                                break
                            }
                        }
                        
                
                          //  Character.getNumericValue(dia.charAt(dia.length() - 1));
                      
                        var scheduleClassType = String(turno.suffix(1));
                        scheduleClassType += String(href[8].last!)
                        
                        let scheduleClassName = try td.attr("title");
                        let scheduleClassNameMin:String = try child.get(0).html()
          
                        
                     
                        
                        let scheduleClassDuration = try td.attr("rowspan");
                        
                        // Calculate scheduleClassHourStart & End
                        var scheduleClassHourStart:String? = horas_inicio;
                        var scheduleClassHourEnd :String? = nil;
                        
                        

                        
                        
                        // Create scheduleClass
                        print("Dia semana " + String(scheduleDayNumber))
                        print(String(scheduleClassName));
                        print(String(scheduleClassNameMin));
                        print(String(scheduleClassType));
                        print(String(scheduleClassHourStart!));
                        print( scheduleClassHourEnd );
                        print(scheduleClassRoom);
               
                        
                      
                        
                        
                    }
                    
                }
                
            }  catch {
                print("error")
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension String {
    
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}



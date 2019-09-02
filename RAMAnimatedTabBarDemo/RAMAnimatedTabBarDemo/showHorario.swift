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
                        
                        var horas_inicio = tr.child(0);
                        let horas_fim = tr.child(1);
                        
                        var scheduleDayNumber:Int = -1
                        let stringArray = String(dia).components(separatedBy: CharacterSet.decimalDigits.inverted)
                        for item in stringArray {
                            if let number = Int(item) {
                               scheduleDayNumber = number
                                break
                            }
                        }
                        
                
                          //  Character.getNumericValue(dia.charAt(dia.length() - 1));
                      
                        var scheduleClassType = turno.suffix(5);
                        scheduleClassType += href[8].suffix(href[8].count - 1);
                        
                        let scheduleClassName = try td.attr("title");
                        let scheduleClassNameMin:String = try child.get(0).html()
          
                        
                        var scheduleClassRoom:String? = nil ;
                        print("count " + String(child.array().count ))
                        
                        if (child.array().count > 4){
                            print("Entrei no child")
                            scheduleClassRoom = child.get(4).data();
                        }
                        
                        
                        let scheduleClassDuration = try td.attr("rowspan");
                        
                        // Calculate scheduleClassHourStart & End
                        var scheduleClassHourStart:String? = nil;
                        var scheduleClassHourEnd :String? = nil;
                        
                        
                        
                        do {
                            
                            
                        let format1 = DateFormatter()
                        format1.dateFormat = "k:mm"
            
                            let dateDuration = ( Int(scheduleClassDuration)! / 2);
                        
                            if (try horas_fim.text().count == 1) {
                        // Start hour
                                /*
                            scheduleClassHourStart = try horas_inicio.text();
                                let dateStart = format1.date(from: scheduleClassHourStart!);
                        
                                let calendar1 = NSCalendar.current.date(from: dateStart)
                              
                        //calendar1.setTime(dateStart);
                                calendar1.date(from: dateStart)
                                
             
                        calendar1.add(Calendar.HOUR, dateDuration);
                        
                        // End hour
                        scheduleClassHourEnd = calendar1.get(Calendar.HOUR_OF_DAY) + ":" + calendar1.get(Calendar.MINUTE) + "0";*/
                        } else {
                        // Calculate start hour
                                /*
                                let dateStart = format1.date(from: horas_fim.text());
                        
                        // Subtract 30 minutes to the start hour
                                let calendar1 = NSCalendar.current
                        calendar1.setTime(dateStart);
                        calendar1.add(Calendar.MINUTE, -30);
                        
                        scheduleClassHourStart = calendar1.get(Calendar.HOUR_OF_DAY) + ":" + calendar1.get(Calendar.MINUTE);
                        
                        // Calculate end hour
                      //  calendar1.add(Calendar.HOUR_OF_DAY, dateDuration);
                        Calendar.current.date(byAdding: .day, value: dateDuration, to: calendar1)
                        
                        scheduleClassHourEnd = calendar1.get(Calendar.HOUR_OF_DAY) + ":" + calendar1.get(Calendar.MINUTE);*/
                        }
                        
                        } catch {
                            print("error 2 catch")
                        }
                        
                        
                        
                        
                        // Create scheduleClass
                        print("Dia semana " + String(scheduleDayNumber))
                        print(scheduleClassName);
                        print(scheduleClassNameMin);
                        print(scheduleClassType);
                        print(scheduleClassHourStart);
                        print(scheduleClassHourEnd);
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



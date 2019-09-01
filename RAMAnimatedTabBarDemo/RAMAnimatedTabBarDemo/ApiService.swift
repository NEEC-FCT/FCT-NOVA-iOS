//
//  ApiService.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 31/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup

class ApiService
{
    

    
    static func callGetHorario(year:String,  studentNumberId:String ,  semester:Int , finish: @escaping ((message:String, data:Data?)) -> Void)
    {
     
        let start = year.prefix(2)
        let end = year.suffix(2)
        let newyear = start + end
        print("ano " + newyear)
        let STUDENT_SCHEDULE_1 = "https://clip.unl.pt/utente/eu/aluno/ano_lectivo/hor%E1rio?" +
        "ano_lectivo=";
        let STUDENT_SCHEDULE_2 = "&institui%E7%E3o=97747&aluno=";
        let STUDENT_SCHEDULE_3 = "&tipo_de_per%EDodo_lectivo=s&per%EDodo_lectivo=";
        let STUDENT_SCHEDULE_3_TRIMESTER = "&tipo_de_per%EDodo_lectivo=t&per%EDodo_lectivo=";
        
        var url = STUDENT_SCHEDULE_1 + newyear + STUDENT_SCHEDULE_2 + studentNumberId;
        if (semester == 3){
            url += STUDENT_SCHEDULE_3_TRIMESTER + String(semester - 1);
        } // Trimester
        else{
            url += STUDENT_SCHEDULE_3 + String(semester);
        }

        print(url)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        print("Cookies before request: ", cookies)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                result.message = "False"
                result.data = data
                
            }
            finish(result)
        }
        task.resume()
        
    }
    
    
    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    static func callGetYears(url:URL, finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        print("Cookies before request: ", cookies)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                result.message = "False"
                result.data = data
                
            }
            finish(result)
        }
        task.resume()
        
    }
    
    static func callPost(url:URL, params:[String:Any], finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        deleteCookies(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        
        let postString = self.getPostString(params: params)
        request.httpBody = postString.data(using: .utf8)
        
        var result:(message:String, data:Data?) = (message: "Fail", data: nil)
        let task = session.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse, let fields = httpResponse.allHeaderFields as? [String : String] {
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: response!.url!)
                HTTPCookieStorage.shared.setCookies(cookies, for: response!.url!, mainDocumentURL: nil)
                result.message = "False"
                for cookie in cookies {
                    var cookieProperties = [HTTPCookiePropertyKey : AnyObject]()
                    cookieProperties[HTTPCookiePropertyKey.name] = cookie.name as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.value] = cookie.value as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.path] = cookie.path as AnyObject
                    cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                    cookieProperties[HTTPCookiePropertyKey.expires] = NSDate().addingTimeInterval(31536000)
                    
                    let newCookie = HTTPCookie(properties: cookieProperties)
                    HTTPCookieStorage.shared.setCookie(newCookie!)
                    
                    print("Cookies")
                    print("name: \(cookie.name) value: \(cookie.value)")
                    if( cookie.name == "JServSessionIdroot1112" ){
                        result.message = "Success"
                    }
                }
                
                result.data = data
                
            }
            finish(result)
        }
        task.resume()
        
    }
}

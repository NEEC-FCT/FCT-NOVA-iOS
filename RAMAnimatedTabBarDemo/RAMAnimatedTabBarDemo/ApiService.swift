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
 
    
    static func getFile(url: String, filename:String , completion: @escaping ((message:URL, data:Data?)) -> Void) {
        print("Filename " + filename)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        var request = URLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }
                
                do {
                 
                    let documentsURL = try
                        FileManager.default.url(for: .documentDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: false)
                    let savedURL = documentsURL.appendingPathComponent(
                        "\(randomString(length: 30)).pdf")
                  
                    print(url)
                    print(savedURL)
                    try FileManager.default.moveItem(at: tempLocalUrl , to: savedURL)
                
                    let result:(message:URL, data:Data?) = (message: savedURL, data: nil)
                    completion(result)
                } catch (let writeError) {
                    print("error writing file : \(writeError)")
                }
                
            } else {
                print("Failure: %@", error?.localizedDescription);
            }
        }
        task.resume()
    }
    
    static func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    static func callGetgetClassesDocs(year:String , studentNumberId:String , finish: @escaping ((message:String, data:Data?)) -> Void){
        
        //URL
        let STUDENT_CLASSES_1 = "https://clip.unl.pt/utente/eu/aluno/ano_lectivo?aluno=";
        let STUDENT_CLASSES_2 = "&institui%E7%E3o=97747&ano_lectivo=";
        
        //Processa os dados
        
        let start = year.prefix(2)
        let end = year.suffix(2)
        let newyear = start + end
        print("ano " + newyear)
        
        let url = STUDENT_CLASSES_1 + studentNumberId + STUDENT_CLASSES_2 + newyear;
        
        
        print(url)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        //print("Cookies before request: ", cookies)
        
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
    
    
    static func callGetgetClassesDocs(year:String, course:String  , docType:String   , studentNumberId:String ,  semester:Int , finish: @escaping ((message:String, data:Data?)) -> Void){
        
        //URL
        let STUDENT_CLASS_DOCS_1 = "https://clip.unl.pt/utente/eu/aluno/ano_lectivo/unidades/unidade_curricular/actividade/documentos?tipo_de_per%EDodo_lectivo=s&ano_lectivo=";
        let STUDENT_CLASS_DOCS_1_TRIMESTER = "https://clip.unl.pt/utente/eu/aluno/ano_lectivo/unidades/unidade_curricular/actividade/documentos?tipo_de_per%EDodo_lectivo=t&ano_lectivo=";
        let STUDENT_CLASS_DOCS_2 = "&per%EDodo_lectivo=";
        let STUDENT_CLASS_DOCS_3 = "&aluno=";
        let STUDENT_CLASS_DOCS_4 = "&institui%E7%E3o=97747&unidade_curricular=";
        let STUDENT_CLASS_DOCS_5 = "&tipo_de_documento_de_unidade=";
        
        //Processa os dados
        
        let start = year.prefix(2)
        let end = year.suffix(2)
        let newyear = start + end
        print("ano " + newyear)
        
        var url = "";
        if (semester == 3){
            url = STUDENT_CLASS_DOCS_1_TRIMESTER + newyear +
                STUDENT_CLASS_DOCS_2 + String(semester - 1);
        }
        else{
            url = STUDENT_CLASS_DOCS_1 + newyear +
                STUDENT_CLASS_DOCS_2 + String(semester);
        }
        url += STUDENT_CLASS_DOCS_3 + studentNumberId +
            STUDENT_CLASS_DOCS_4 + course +
            STUDENT_CLASS_DOCS_5 + docType;
        
        
        print(url)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        //print("Cookies before request: ", cookies)
        
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
     
    
    
    static func callGetTestCalendar(year:String,  studentNumberId:String ,  semester:Int , finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        
        //Processa os dados
        
        let start = year.prefix(2)
        let end = year.suffix(2)
        let newyear = start + end
        print("ano " + newyear)
        
        let STUDENT_CALENDAR_TEST_1 = "https://clip.unl.pt/utente/eu/aluno/acto_curricular/inscri%E7%E3o/testes_de_avalia%E7%E3o?institui%E7%E3o=97747&aluno=";
        let STUDENT_CALENDAR_TEST_2 = "&ano_lectivo=";
        let STUDENT_CALENDAR_TEST_3 = "&tipo_de_per%EDodo_lectivo=s&per%EDodo_lectivo=";
        let STUDENT_CALENDAR_TEST_3_TRIMESTER = "&tipo_de_per%EDodo_lectivo=t&per%EDodo_lectivo=";
        
        var  url = STUDENT_CALENDAR_TEST_1 + studentNumberId + STUDENT_CALENDAR_TEST_2 + newyear;
        if (semester == 3) {
           url += STUDENT_CALENDAR_TEST_3_TRIMESTER + String(semester - 1);
        }
        else{
           url += STUDENT_CALENDAR_TEST_3 + String(semester);
        }
        
        
        print(url)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        //print("Cookies before request: ", cookies)
        
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
    
    
    static func callGetExamCalendar(year:String,  studentNumberId:String ,  semester:Int , finish: @escaping ((message:String, data:Data?)) -> Void)
    {
        
        //Processa os dados
        
        let start = year.prefix(2)
        let end = year.suffix(2)
        let newyear = start + end
        print("ano " + newyear)
        
        let  STUDENT_CALENDAR_EXAM_1 = "https://clip.unl.pt/utente/eu/aluno/ano_lectivo/calend%E1rio?ano_lectivo=";
        let STUDENT_CALENDAR_EXAM_2 = "&aluno=";
        let STUDENT_CALENDAR_EXAM_3 = "&institui%E7%E3o=97747&tipo_de_per%EDodo_lectivo=s&per%EDodo_lectivo=";
        let STUDENT_CALENDAR_EXAM_3_TRIMESTER = "&institui%E7%E3o=97747&tipo_de_per%EDodo_lectivo=t&per%EDodo_lectivo=";
    
        var url = STUDENT_CALENDAR_EXAM_1 + year + STUDENT_CALENDAR_EXAM_2 + studentNumberId;
        // Trimester
        if (semester == 3){
              url += STUDENT_CALENDAR_EXAM_3_TRIMESTER + String(semester - 1);
        }
        else{
              url += STUDENT_CALENDAR_EXAM_3 + String(semester);
        }
    
        print(url)
        
        var request = URLRequest(url: NSURL(string: url)! as URL)
        let session = URLSession.shared
        request.httpMethod = "GET"
        let cookies = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
        //print("Cookies before request: ", cookies)
        
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
        //print("Cookies before request: ", cookies)
        
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
        _ = readCookie(forURL: URL(string: "https://clip.unl.pt/utente/eu")!)
      //  print("Cookies before request: ", cookies)
        
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


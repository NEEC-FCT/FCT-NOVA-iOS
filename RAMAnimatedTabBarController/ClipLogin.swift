//
//  ClipLogin.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 30/08/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup


class ClipLogin: UIViewController  {
    
    @IBOutlet weak var logintext: UITextField!
    @IBOutlet weak var passwordtext: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var numero = [String]()
    var texto  = [String]()
    var url  = [String]()
    
    
    @IBAction func loginClicked(_ sender: Any) {
        
        print( logintext.text!)
        print( passwordtext.text!)

        let params = ["identificador": logintext.text!,
                      "senha":passwordtext.text!
                ]
        
        
        ApiService.callPost(url: URL(string: "https://clip.unl.pt/utente/eu")!, params: params, finish: finishPost)


    }
    
    
    
    func finishPost (message:String, data:Data?) -> Void
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
                    let matched = matches(for: "/utente/eu/aluno[?][_a-zA-Z0-9=&.]*aluno=[0-9]*", in: linkHref)
                    if( matched != []){
                        var numbers = linkHref.components(separatedBy: "&")
                        numbers = numbers[numbers.count - 1].components(separatedBy: "=")
                        print(numbers[1])
                        numero.append(numbers[1])
                        print(try! link.text())
                        texto.append(try! link.text())
                        print(matched)
                        url.append(matched[0])
                    }
                    
                   
                   
                    
                }
                
            }  catch {
                print("error")
            }
        
            if( self.numero.count == 0) {
                let refreshAlert = UIAlertController(title: "Login", message: "Acesso errado ou questionários por preencher.", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    print("Handle Ok logic here")
                }))
                
                present(refreshAlert, animated: true, completion: nil)
                
             }
            else{
            DispatchQueue.main.async {
                let defaults = UserDefaults.standard
                defaults.set(self.numero, forKey: "numero")
                defaults.set(self.texto, forKey: "texto")
                defaults.set(self.url, forKey: "url")
              self.performSegue(withIdentifier: "gotoID", sender: nil)
            }
        }
  
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        print("Go Clip Login")
        //gotoID
        
      
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}




enum Result {
    case success(HTTPURLResponse, Data)
    case failure(Error)
}

func readCookie(forURL url: URL) -> [HTTPCookie] {
    let cookieStorage = HTTPCookieStorage.shared
    let cookies = cookieStorage.cookies(for: url) ?? []
    return cookies
}

func deleteCookies(forURL url: URL) {
    let cookieStorage = HTTPCookieStorage.shared
    
    for cookie in readCookie(forURL: url) {
        cookieStorage.deleteCookie(cookie)
    }
}

func storeCookies(_ cookies: [HTTPCookie], forURL url: URL) {
    let cookieStorage = HTTPCookieStorage.shared
    cookieStorage.setCookies(cookies,
                             for: url,
                             mainDocumentURL: nil)
}

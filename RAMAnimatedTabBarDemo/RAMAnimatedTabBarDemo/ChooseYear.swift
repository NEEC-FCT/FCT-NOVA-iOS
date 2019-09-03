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


class ChooseYear: UIViewController , UITableViewDelegate , UITableViewDataSource  {


    var urlSelect:String = ""
    var years = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = years[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(years[indexPath.row])!")
        
        //Muda de view

        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            defaults.set(String(self.years[indexPath.row]), forKey: "urlSelect")
                 self.performSegue(withIdentifier: "gotohorario", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Check clip login
        tableView.dataSource = self
        tableView.delegate = self
        let defaults = UserDefaults.standard
        urlSelect = defaults.string(forKey: "urlSelect")!
        print("Select Year")
        print(urlSelect)
        //gotoID
        self.showSpinner(onView: self.view)
         ApiService.callGetYears(url: URL(string: "https://clip.unl.pt" + urlSelect)!, finish: finishGetYear)
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
                        years.append(year)
                    }
                }
                
            }  catch {
                print("error")
            }
            
            DispatchQueue.main.async {
                
                self.removeSpinner()
                print(self.years)
                self.tableView.reloadData()
            }
            
            
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



var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}

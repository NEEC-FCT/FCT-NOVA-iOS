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


class pickSemestreCalendar: UIViewController , UITableViewDelegate , UITableViewDataSource  {
    
    
    var urlSelect:String = ""
    var years  = ["1º Semestre" , "2º Semestre" , "2º Trimestre"]
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
            defaults.set(1, forKey: "semestreSelected")
            
            self.performSegue(withIdentifier: "goCalendary", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        //Check clip login
        tableView.dataSource = self
        tableView.delegate = self

        
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





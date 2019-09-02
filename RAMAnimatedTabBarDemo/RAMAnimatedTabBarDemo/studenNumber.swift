//
//  studenNumber.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 02/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import Foundation
import UIKit


class studenNumber: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    var numero = [String]()
    var texto  = [String]()
    var url  = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numero.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = texto[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(texto[indexPath.row])!")
        
        //Muda de view
        
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            defaults.set(String(self.url[indexPath.row]), forKey: "urlSelect")
            self.performSegue(withIdentifier: "chooseYear", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        let defaults = UserDefaults.standard
        numero = defaults.stringArray(forKey: "numero") ?? [String]()
         texto = defaults.stringArray(forKey: "texto") ?? [String]()
         url = defaults.stringArray(forKey: "url") ?? [String]()
        //print(numero)
        tableView.dataSource = self
        tableView.delegate = self
        //gotoID
        

        
        
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}



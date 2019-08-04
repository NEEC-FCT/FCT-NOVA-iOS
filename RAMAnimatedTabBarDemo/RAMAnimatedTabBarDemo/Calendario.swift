//
//  SobreNeec.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import WebKit

class Calendario: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    
    //A string array to save all the names
    var finalArray:[Any] = ["Data 1 " , "Data 2" , "Data 3" , "Data 4" , "Data 5" , "Data 6" , "Data 7" , "Data 8" ]
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))
        getJsonFromUrl()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (finalArray.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = finalArray[indexPath.row] as? String
        return cell
    
    }
    
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        
        if let url = URL(string: "https://fctapp.neec-fct.com/calendar.php") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print(jsonString)
                        
                    }
                }
                }.resume()
        }
    }
    
    func myHandler(alert: UIAlertAction){
        if( CheckInternet.Connection() == false)
        {
            let controller = UIAlertController(title: "Sem internet" , message: "Esta aplicação necessita de internet", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: myHandler)
            
            
            controller.addAction(ok)
            
            
            present(controller, animated: true, completion: nil)
        }
    }

}

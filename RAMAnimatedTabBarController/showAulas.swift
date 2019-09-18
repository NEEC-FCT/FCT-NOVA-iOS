//
//  avalicao.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 17/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import Foundation
import SwiftSoup

class showAulas: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var id:String = ""
    var ano:String = ""
    var semestre:Int = 1
    var idCadeira:String = ""
    var docType:String = ""
    var html:Data? = nil
    var URLDATA:URL? = nil
    
    var name = [String]()
    var URL = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = name[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(name[indexPath.row])!")
        print("You selected cell #\(URL[indexPath.row])!")
        self.showSpinner(onView: self.view)
        ApiService.getFile(url: "https://clip.unl.pt" + URL[indexPath.row] , filename: String(URL[indexPath.row].split(separator: "=")[2]), completion: finishFile)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let defaults = UserDefaults.standard
        semestre = defaults.integer(forKey: "semestreSelected")
        id =  defaults.string(forKey: "IDaluno")!
        ano = defaults.string(forKey: "urlSelect")!
        idCadeira = UserDefaults.standard.string(forKey: "idCadeira") ?? ""
          docType = UserDefaults.standard.string(forKey: "docType") ?? ""
        print("Recebi " + id + " " + ano + " " + idCadeira + " " +  docType)
        self.showSpinner(onView: self.view)
        ApiService.callGetgetClassesDocs(year: self.ano, course: idCadeira, docType: docType, studentNumberId: self.id, semester: self.semestre , finish: self.finishGetAvalicacao )
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewer" {
            if let destinationVC = segue.destination as? PDFViewController {
                destinationVC.pdfURL = URLDATA
            }
        }
    }
    
    func finishFile (message:URL, data:Data?) -> Void {
    
        print("Got file")
        DispatchQueue.main.async {
            self.removeSpinner()
            print("Recebido")
            print ( message )
            self.URLDATA = message
            self.performSegue(withIdentifier: "viewer", sender: self)
        }
    }
    
    
    func finishGetAvalicacao (message:String, data:Data?) -> Void {
        
        
        print("Recebi")
        let html = String(data: data!, encoding: .isoLatin1)
        //print( html! )
        do {
            let doc: Document = try SwiftSoup.parse(html!)
            let docs: Elements = try doc.body()!.select("form[method=post]").array()[1].select("tr");
            
            
            for doc in docs {
                if (!doc.hasAttr("bgcolor")){ continue };
                
                
                print("File data")
                print(try doc.child(0).text() );
                if( (try doc.child(0).text()).contains("pdf")){
                    self.name.append( try doc.child(0).text() )
                    print(try doc.child(1).child(0).attr("href"));
                    self.URL.append( try doc.child(1).child(0).attr("href") )
                    print( try doc.child(2).text());
                    print( try doc.child(3).text());
                    print( try doc.child(4).text());
                }
                
            }
            
            
            
        }  catch {
            print("error")
        }
        //Processado
        DispatchQueue.main.async {
            self.removeSpinner()
            print(self.name)
            print(self.URL)
            self.tableView.reloadData()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

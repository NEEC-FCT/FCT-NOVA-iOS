//
//  avalicao.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 17/09/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import FSCalendar
import Foundation
import SwiftSoup

class avaliacao: UIViewController , UITableViewDelegate  , UITableViewDataSource  , FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    

    @IBOutlet weak var calendar: FSCalendar!
    
    //A string array to save all the names
    var time:[String]  = []
    var color:[String]  = []
    var name:[String]  = []
    
    var id:String = ""
    var ano:String = ""
    var semestre:Int = 1
    var html:Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //calendar.select(self.dateFormatter1.date(from: "2019/10/03"))
        let todayItem = UIBarButtonItem(title: "TODAY", style: .plain, target: self, action: #selector(self.todayItemClicked(sender:)))
        self.navigationItem.rightBarButtonItem = todayItem
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        
        let defaults = UserDefaults.standard
        semestre = defaults.integer(forKey: "semestreSelected")
        id =  defaults.string(forKey: "IDaluno")!
        ano = defaults.string(forKey: "urlSelect")!
        print("Recebi " + id + " " + ano + " " + String(semestre))
        self.showSpinner(onView: self.view)
        ApiService.callGetTestCalendar(year: self.ano , studentNumberId: self.id, semester: self.semestre , finish: self.finishGetAvalicacao)
        
    }
    
    
    func finishPost (message:String, data:Data?) -> Void {
        
        DispatchQueue.main.async {
            print("Pedindo cookie")
            self.removeSpinner()
            self.showSpinner(onView: self.view)
            ApiService.callGetTestCalendar(year: self.ano , studentNumberId: self.id, semester: self.semestre , finish: self.finishGetAvalicacao)
            
        }
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
  
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    var borderDefaultColors = ["2019-08-13": UIColor.cyan]
    
    
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.dateFormatter1.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.dateFormatter1.string(from: date))")
        for n in 0 ... ( self.time.count - 1 ) {
            if( self.time[n] ==  self.dateFormatter1.string(from: date) ){
                let indexPath = NSIndexPath(row: n, section: 0)
                self.tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
                break
            }
        }
    }
    
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        self.calendar.select(self.dateFormatter1.date(from: self.time[indexPath.row]))
        
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderDefaultColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.borderDefaultColors[key] {
            return color
        }
        return appearance.borderSelectionColor
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        if [8, 17, 21, 25].contains((self.gregorian.component(.day, from: date))) {
            return 0.0
        }
        return 1.0
    }
    
    func finishGetAvalicacao (message:String, data:Data?) -> Void {
        
 
            print("Recebi")
            let html = String(data: data!, encoding: .isoLatin1)
            print( html! )
        
        if( (html!.contains("geral de utente"))){
            let defaults = UserDefaults.standard
            let username = defaults.string(forKey: "username")
            let password = defaults.string(forKey: "password")
            print("useername" , username! )
            print("pass" , password! )
            let params = ["identificador": username!,
                          "senha":password!
            ]
         
            
            ApiService.callPost(url: URL(string: "https://clip.unl.pt/utente/eu")!, params: params, finish: finishPost)
            
        }
        else{
       do {
            let doc: Document = try SwiftSoup.parse(html!)
            let body: Element =  doc.body()!
        if (body.childNodeSize() != 0){
          
            var tests = try body.select("form[method=post]");
            // There is no calendar available!
            if (tests.size() == 1){
                return
            }
            
                tests = try tests.get(2).select("tr");
                 for  test in tests {
                    if ( !test.hasAttr("bgcolor") ){
                        continue
                    }
                    
                    var name = test.child(1).textNodes()[0].text();
                    let number = try test.child(2).text();
                    let date = test.child(3).childNode(0);
                    let hour = test.child(3).childNode(2);
        
                    let rooms = test.child(4).child(0).textNodes();
                    var rooms_final = ""
                    for room in rooms{
                        rooms_final +=  room.getWholeText() + "  "
                    }
                   
                    print(name)
                    print(number)
                    print(try date.outerHtml())
                    print(hour)
                    print(rooms_final)
                    //Adiciona ao calendario
                    
                    self.time.append( try date.outerHtml() )
                    let horas:String =  try hour.outerHtml()
                    self.name.append(String(name) + "\n" + number.split(separator: " ")[0] + " às " + horas + " "  + rooms_final )
                    self.color.append("#a10000")
                    //Adiciona ao calendario
                    
                
                }
                
             
            
        }
        
        
       }  catch {
        print("error")
        }
        
        //Reload data
        //adicionar ao UI
        for n in 0...(self.name.count - 1 ){
            
            self.borderDefaultColors[self.time[n]] = self.hexStringToUIColor( hex: self.color[n])
            print(self.time[n] + " " + self.color[n])
            
        }
        
        print("Mapa do calendario")
        print(  self.borderDefaultColors)
        
        DispatchQueue.main.async { self.removeSpinner() ; self.tableView.reloadData() }
        DispatchQueue.main.async { self.calendar.reloadData() }
          }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.time.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            as! HeadlineTableViewCell
        
        cell.nome.text  = name[indexPath.row]
        cell.nome.numberOfLines = 2
        cell.date.text = time[indexPath.row]
        cell.cor.backgroundColor = self.hexStringToUIColor( hex: self.color[indexPath.row])
        
        return cell
        
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
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}

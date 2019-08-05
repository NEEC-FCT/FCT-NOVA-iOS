//
//  SobreNeec.swift
//  RAMAnimatedTabBarDemo
//
//  Created by NEEC on 13/07/2019.
//  Copyright © 2019 Ramotion. All rights reserved.
//

import UIKit
import WebKit
import FSCalendar


class HeadlineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nome: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cor: UIImageView!
    
}

class Calendario: UIViewController , UITableViewDelegate  , UITableViewDataSource  , FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    
    //A string array to save all the names
    var time:[String]  = []
    var color:[String]  = []
    var name:[String]  = []
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    @IBOutlet weak var tableview: UITableView!
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    var borderDefaultColors = ["11/09/2019": UIColor.cyan]

    
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
                self.tableview.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myHandler(alert: UIAlertAction(title: "OK", style: .default, handler: myHandler))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = false
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        
        self.tableview.delegate = self
        self.tableview.dataSource = self
        
        //calendar.select(self.dateFormatter1.date(from: "2019/10/03"))
        let todayItem = UIBarButtonItem(title: "TODAY", style: .plain, target: self, action: #selector(self.todayItemClicked(sender:)))
        self.navigationItem.rightBarButtonItem = todayItem
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        getJsonFromUrl()
        
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
        cell.date.text = time[indexPath.row]
        cell.cor.backgroundColor = self.hexStringToUIColor( hex: self.color[indexPath.row])
        
        return cell
    
    }
    
    
    //this function is fetching the json from URL
    func getJsonFromUrl(){
        //creating a NSURL
        
        if let url = URL(string: "https://fctapp.neec-fct.com/calendar.php") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    print(data)
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            self.time = json
                                .compactMap{$0["time"] as? String}
                            print(self.time)
                            self.color = json
                                .compactMap{$0["color"] as? String}
                            print(self.color)
                            self.name = json
                                .compactMap{$0["name"] as? String}
                            print(self.name)
                            
                            //adicionar ao UI
                            for n in 0...(self.name.count - 1 ){
                                
                                self.borderDefaultColors[self.time[n]] = self.hexStringToUIColor( hex: self.color[n])
                                print(self.time[n] + " " + self.color[n])
                            
                            }
                            
                            print("Mapa do calendario")
                            print(  self.borderDefaultColors)
                            //Reload data
                           DispatchQueue.main.async { self.tableview.reloadData() }
                           DispatchQueue.main.async { self.calendar.reloadData() }
                            
                        } else {
                            print("bad json")
                        }
                    } catch let error as NSError {
                        print(error)
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


extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}


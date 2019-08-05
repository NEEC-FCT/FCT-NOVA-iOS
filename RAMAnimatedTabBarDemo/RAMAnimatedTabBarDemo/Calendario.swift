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

class Calendario: UIViewController , UITableViewDelegate , UITableViewDataSource  , FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    
    //A string array to save all the names
    var finalArray:[Any] = ["Data 1 " , "Data 2" , "Data 3" , "Data 4" , "Data 5" , "Data 6" , "Data 7" , "Data 8" ]
    var time:[String]  = []
    var color:[String]  = []
    var name:[String]  = []
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    
    let borderDefaultColors = ["11/09/2019": UIColor.cyan]

    
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
        calendar.allowsMultipleSelection = true
        calendar.swipeToChooseGesture.isEnabled = true
        calendar.backgroundColor = UIColor.white
        calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesSingleUpperCase]
        
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
                    print(data)
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            self.time = json
                                .compactMap{$0["time"] as? String}
                            print(self.time) // ==> ["09/09/2019",
                            self.color = json
                                .compactMap{$0["color"] as? String}
                            print(self.color) // ==> ["09/09/2019",
                            self.name = json
                                .compactMap{$0["name"] as? String}
                            print(self.name) // ==> ["09/09/2019",
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
    
    
 
    

}



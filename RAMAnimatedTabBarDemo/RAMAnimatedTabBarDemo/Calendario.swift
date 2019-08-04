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
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    let fillSelectionColors = ["2015/10/08": UIColor.green, "2015/10/06": UIColor.purple, "2015/10/17": UIColor.gray, "2015/10/21": UIColor.cyan, "2015/11/08": UIColor.green, "2015/11/06": UIColor.purple, "2015/11/17": UIColor.gray, "2015/11/21": UIColor.cyan, "2015/12/08": UIColor.green, "2015/12/06": UIColor.purple, "2015/12/17": UIColor.gray, "2015/12/21": UIColor.cyan]
    
    
    let fillDefaultColors = ["2015/10/08": UIColor.purple, "2015/10/06": UIColor.green, "2015/10/18": UIColor.cyan, "2015/10/22": UIColor.yellow, "2015/11/08": UIColor.purple, "2015/11/06": UIColor.green, "2015/11/18": UIColor.cyan, "2015/11/22": UIColor.yellow, "2015/12/08": UIColor.purple, "2015/12/06": UIColor.green, "2015/12/18": UIColor.cyan, "2015/12/22": UIColor.magenta]
    
    let borderDefaultColors = ["2015/10/08": UIColor.brown, "2015/10/17": UIColor.magenta, "2015/10/21": UIColor.cyan, "2015/10/25": UIColor.black, "2015/11/08": UIColor.brown, "2015/11/17": UIColor.magenta, "2015/11/21": UIColor.cyan, "2015/11/25": UIColor.black, "2015/12/08": UIColor.brown, "2015/12/17": UIColor.magenta, "2015/12/21": UIColor.purple, "2015/12/25": UIColor.black]
    
    let borderSelectionColors = ["2015/10/08": UIColor.red, "2015/10/17": UIColor.purple, "2015/10/21": UIColor.cyan, "2015/10/25": UIColor.magenta, "2015/11/08": UIColor.red, "2015/11/17": UIColor.purple, "2015/11/21": UIColor.cyan, "2015/11/25": UIColor.purple, "2015/12/08": UIColor.red, "2015/12/17": UIColor.purple, "2015/12/21": UIColor.cyan, "2015/12/25": UIColor.magenta]
    
    var datesWithEvent = ["2015-10-03", "2015-10-06", "2015-10-12", "2015-10-25"]
    var datesWithMultipleEvents = ["2015-10-08", "2015-10-16", "2015-10-20", "2015-10-28"]


    
    deinit {
        print("\(#function)")
    }
    
    @objc
    func todayItemClicked(sender: AnyObject) {
        self.calendar.setCurrentPage(Date(), animated: false)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter2.string(from: date)
        if self.datesWithEvent.contains(dateString) {
            return 1
        }
        if self.datesWithMultipleEvents.contains(dateString) {
            return 3
        }
        return 0
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        let key = self.dateFormatter2.string(from: date)
        if self.datesWithMultipleEvents.contains(key) {
            return [UIColor.magenta, appearance.eventDefaultColor, UIColor.black]
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillSelectionColors[key] {
            return color
        }
        return appearance.selectionColor
    }
    
    
    // MARK:- FSCalendarDelegate
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("change page to \(self.dateFormatter1.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("calendar did select date \(self.dateFormatter1.string(from: date))")

    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter1.string(from: date)
        if let color = self.fillDefaultColors[key] {
            return color
        }
        return nil
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
        if let color = self.borderSelectionColors[key] {
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
        
        calendar.select(self.dateFormatter1.date(from: "2015/10/03"))
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

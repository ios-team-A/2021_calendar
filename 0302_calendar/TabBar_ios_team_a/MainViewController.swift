//
//  MainViewController.swift
//  TabBar_ios_team_a
//
//  Created by 임수정 on 2021/02/16.
//

import UIKit
import SQLite3

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var selectedDate = Date()
  var totalDates = [String]()
  let calendarHelper = CalendarHelper()
  let db = DBHelper()
  var yearMonth = ""
  var day = ""

  override func viewDidLoad() {
    super.viewDidLoad()
    setMonthView()
  }
    
    // 디테일뷰 구분자 = SendToCalendarDetail
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SendToCalendarCurrentTask" {
            if let vc = segue.destination as? CalendarCurrentTaskViewController {
                vc.now = yearMonth + day
                vc.yearMonth = yearMonth
                vc.date = day
                print("\(vc.now)dfdfdfdfdff")
            }
        }
    }
  func setMonthView() {
    totalDates.removeAll()
    let datesInMonth = calendarHelper.numOfDatesInMonth(date: selectedDate)
    let firstDayOfMonth = calendarHelper.firstDayOfMonth(date: selectedDate)
    let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
    
    var count: Int = 1
    
    while(count <= 42){
      if count <= startingSpaces || count - startingSpaces > datesInMonth {
        totalDates.append("")
      }else{
        totalDates.append("\(count-startingSpaces)")
      }
      count += 1
    }
    
    monthLabel.text = calendarHelper.monthString(date: selectedDate) + "월 " + calendarHelper.yearString(date: selectedDate)
    yearMonth = calendarHelper.yearString(date: selectedDate) + calendarHelper.monthString(date: selectedDate)
    collectionView.reloadData()
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
    return totalDates.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CalendarCell else {
      return UICollectionViewCell()
    }
    cell.dateLabel.text = totalDates[indexPath.item]
    cell.titleLabel.text = ""
    cell.titleLabel2.text = ""
    cell.titleLabel3.text = ""
    if cell.dateLabel.text != ""{
        let mclist = db.selectCalendar(now: yearMonth+totalDates[indexPath.item])
        if mclist.count > 0 {
            cell.titleLabel.text = mclist[0].title as String
        }
        if mclist.count > 1 {
            cell.titleLabel2.text = mclist[1].title as String
        }
        if mclist.count > 2 {
            cell.titleLabel3.text = mclist[2].title as String
        }
    }
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        day = totalDates[indexPath.item]
        if totalDates[indexPath.item] != "" {
            performSegue(withIdentifier: "SendToCalendarCurrentTask", sender: indexPath.item)
        }
    }
    
  override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    if let cell = sender as? CalendarCell {
      if cell.dateLabel.text == "" {
        return false
      } else {
        day = cell.dateLabel.text!
      }
    }
    return true
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.size.width)/9
    let height = width * 2
    return CGSize(width: width, height: height)
  }
  
  @IBAction func prevMonthBtn(_ sender: Any) {
    selectedDate = calendarHelper.previousMonth(date: selectedDate)
    setMonthView()
  }
  @IBAction func nextMonthBtn(_ sender: Any) {
    selectedDate = calendarHelper.nextMonth(date: selectedDate)
    setMonthView()
  }
}

class CalendarCell: UICollectionViewCell{
  @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var titleLabel3: UILabel!
}

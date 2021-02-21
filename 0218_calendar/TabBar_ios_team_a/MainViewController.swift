//
//  MainViewController.swift
//  TabBar_ios_team_a
//
//  Created by 임수정 on 2021/02/16.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var selectedDate = Date()
  var totalDates = [String]()
  let calendarHelper = CalendarHelper()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setMonthView()
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

    if cell.calendarDetailButton.isSelected {
      selected()
    }
    
    return cell
  }
    
  // MARK: cell을 선택했을 때 detailVC를 present하는 함수.
  func selected() {
    guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "CalendarDetailViewController") as? CalendarDetailViewController else { return }
    detailVC.modalPresentationStyle = .fullScreen
    present(detailVC, animated: true)
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didDeselectItemAt indexPath: IndexPath) {
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.size.width)/9
    let height = width * 10/7
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
  
  // MARK: cell 안에 있는 버튼에 action 추가.
  @IBAction func toDetialVC(_ sender: Any) {
    selected()
  }
}

class CalendarCell: UICollectionViewCell{
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var calendarDetailButton: UIButton!
}

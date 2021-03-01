
//  CalendarCurrentTaskViewController.swift
//  TabBar_ios_team_a
//
//  Created by 강민성 on 2021/02/23.


import UIKit
import SQLite3

class CalendarCurrentTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var currentDateLabel: UILabel!

    @IBOutlet weak var nothingAddedImageView: UIImageView!
    @IBOutlet weak var nothingAddedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let db = DBHelper()

    var now = ""
    var titleString = ""
    var t_string = ""
    var calList = [CalendarInstance]()
    
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "reviseSeg" {
            if  let vc = segue.destination as? ReviseCalendarViewController {

        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        vc.title_s = calList[(indexPath?.row)!].title as String//내가누른 cell의 text
                vc.plus_date = now
            }
        }
         if segue.identifier == "SendToCalendarDetail" {
            if let vc = segue.destination as? CalendarDetailViewController {
                vc.plus_date = now
            }
        }
    }

    //MARK: - MainViewController에서 선택한 날짜의 정보를 currentDateLabel로 전달하기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calList = db.selectCalendar(now: now)
        if calList.isEmpty {
            tableView.isHidden = true
        }
        currentDateLabel.text = now
       // self.tableView.beginUpdates()
        //self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
        //self.tableView.endUpdates()
            print("\(now) is now")
     
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "SendToCalendarDetail", sender: sender)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        cell.taskTitleLabel.text = calList[indexPath.row].title as String
        titleString = calList[indexPath.row].title as String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         print("section: \(indexPath.section) row:\(indexPath.row)")
        t_string = calList[indexPath.row].title as String
        print("\(t_string)-----------")
        
     }
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskKindsImageVIew: UIImageView!
    
    //MARK: - 추가한 일정의 제목과 종류를 넘겨주기
    //세그웨이로 넘겨주기전 전처리단계
   

  
    
    
}

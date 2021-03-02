
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
    var yearMonth = ""
    var date = ""
    var titleString = ""
    var t_string = ""
    var calList: [CalendarInstance] = []{
        didSet(old){
            tableView.reloadData()
        }
        willSet(new){
            tableView.reloadData()
        }
    }
    
    
    let imgList = ["1":"workplace","2":"house","3":"calendar"]
  
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
        let yearidx = yearMonth.index(yearMonth.startIndex, offsetBy: 4)
        currentDateLabel.text = yearMonth[yearMonth.startIndex..<yearidx] + "년" + yearMonth[yearidx..<yearMonth.endIndex] + "월" + date + "일"
//        self.tableView.beginUpdates()
//        self.tableView.reloadRows(at: self.tableView.indexPathsForVisibleRows!, with: .none)
//        self.tableView.endUpdates()
            print("\(now) is now")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calList = db.selectCalendar(now: now)
        tableView.reloadData()
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: presentingViewController?.viewDidLoad)
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
        cell.taskKindsImageVIew.image = UIImage(named: imgList[calList[indexPath.row].calendar_group as String]!)
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
    
}

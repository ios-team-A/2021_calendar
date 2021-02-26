
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
    var calList = [CalendarInstance]()
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SendToCalendarDetail" {
//            let vc = segue.destination as? CalendarDetailViewController
//        }
//
//    }
    
    //MARK: - MainViewController에서 선택한 날짜의 정보를 currentDateLabel로 전달하기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calList = db.selectCalendar(now: now)
        if calList.isEmpty {
            tableView.isHidden = true
        }
        currentDateLabel.text = now
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
        return cell
    }
    
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskKindsImageVIew: UIImageView!
    
    //MARK: - 추가한 일정의 제목과 종류를 넘겨주기
    
    
    
}

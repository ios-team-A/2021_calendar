//
//  CalendarDetailViewController.swift
//  TabBar_ios_team_a
//
//  Created by 강민성 on 2021/02/18.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    let db = DBHelper()

    @IBOutlet weak var workplaceImage: UIImageView!
    @IBOutlet weak var houseImage: UIImageView!
    @IBOutlet weak var calendarImage: UIImageView!
    
    @IBOutlet weak var workplaceLabel: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var workplaceButton: UIButton!
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    var now = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func save(_ sender: Any) {
        if titleTextField.hasText == false || bodyTextField.hasText == false  {
            let alert = UIAlertController(title: "저장 실패", message: "일정 제목과 내용을 입력해야 합니다.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else if workplaceButton.isSelected == false &&
            workplaceButton.isSelected == false &&
            workplaceButton.isSelected == false {
            let alert = UIAlertController(title: "저장 실패", message: "일정 종류를 선택해야 합니다.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else {
            //MARK: TODO : 일정 제목, 일정 내용, 일정 종류를 DB에 전송하기
            let ci = CalendarInstance(title: titleTextField.text! as NSString, date: now as NSString, calendar_group: "1")
            db.insertIntoCalendar(calendarInstance: ci)
            dismiss(animated: true, completion: presentedViewController?.viewDidLoad)
        }
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapWorkplaceButton(_ sender: Any) {
        workplaceButton.isSelected = !workplaceButton.isSelected
        if houseButton.isSelected || calendarButton.isSelected {
            houseButton.isSelected = false
            calendarButton.isSelected = false
        }
    }
    
    @IBAction func didTapHouseButton(_ sender: Any) {
        houseButton.isSelected = !houseButton.isSelected
        if workplaceButton.isSelected || calendarButton.isSelected {
            workplaceButton.isSelected = false
            calendarButton.isSelected = false
        }
    }
    
    @IBAction func didTapCalendarButton(_ sender: Any) {
        calendarButton.isSelected = !calendarButton.isSelected
        if workplaceButton.isSelected || houseButton.isSelected {
            workplaceButton.isSelected = false
            houseButton.isSelected = false
        }
    }
    
    

}

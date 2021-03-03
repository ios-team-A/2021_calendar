//
//  CalendarDetailViewController.swift
//  TabBar_ios_team_a
//
//  Created by 강민성 on 2021/02/18.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    let db = DBHelper()

    @IBOutlet weak var workplaceLabel: UILabel!
    @IBOutlet weak var houseLabel: UILabel!
    @IBOutlet weak var calendarLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var workplaceButton: UIButton!
    @IBOutlet weak var houseButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
 
    
    //var now = ""
    var plus_date = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hihihihihihih\(plus_date)")
    }
    
    @IBAction func save(_ sender: Any) {
        if titleTextField.hasText == false {
            //updateInstCalendar
            let alert = UIAlertController(title: "저장 실패", message: "일정 제목을 입력해야 합니다.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else if workplaceButton.isSelected == false &&
            houseButton.isSelected == false &&
            calendarButton.isSelected == false {
            let alert = UIAlertController(title: "저장 실패", message: "일정 종류를 선택해야 합니다.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        } else {
            //MARK: TODO : 일정 제목, 일정 내용, 일정 종류를 DB에 전송하기
            var c_group:String!
            if workplaceButton.isSelected == true{
                c_group = "1"
            }
            else if houseButton.isSelected == true{
                c_group = "2"
            } else{
                c_group = "3"
            }
            
            let ci = CalendarInstance(title: titleTextField.text! as NSString, date: plus_date as NSString, calendar_group: c_group as NSString)
            db.insertIntoCalendar(calendarInstance: ci)
            print("ssssssssss-----\(titleTextField.text! as NSString)----------")
            dismiss(animated: true, completion: presentingViewController?.viewDidLoad)
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

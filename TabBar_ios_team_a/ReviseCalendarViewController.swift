//
//  ReviseCalendarViewController.swift
//  TabBar_ios_team_a
//
//  Created by 권예진 on 2021/02/26.
//

import UIKit

class ReviseCalendarViewController: UIViewController {
    let db = DBHelper()
    
    var title_s = ""
    var plus_date = ""
    @IBOutlet weak var t_Label: UILabel!
    
    
   
    @IBOutlet weak var t_TextField: UITextField!
  
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func reviseBtn(_ sender: Any) {
        if  t_TextField.hasText == false {
            //updateInstCalendar
            let alert = UIAlertController(title: "저장 실패", message: "일정 제목을 입력해야 합니다.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
            //MARK: TODO : 일정 제목, 일정 내용, 일정 종류를 DB에 전송하기
        let ci = CalendarInstance(title: t_TextField.text! as NSString, date: plus_date as NSString, r_title: title_s as NSString)
            db.updateInstCalendar(calendarInstance: ci)
            print("ssssssssss-----\(t_TextField.text! as NSString)----------")
            
            dismiss(animated: true, completion: presentedViewController?.viewDidLoad)
    }
    @IBAction func deleteBtn(_ sender: Any) {
       
        let ci = CalendarInstance(title: title_s as NSString, date: plus_date as NSString)
            db.deleteInstCalendar(calendarInstance: ci)
            print("ssssssssss-----\(t_TextField.text! as NSString)----------")
            
            dismiss(animated: true, completion: presentedViewController?.viewDidLoad)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        t_TextField.text = title_s
        print(title_s)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
  
}

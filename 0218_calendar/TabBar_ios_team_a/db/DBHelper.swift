//
//  DBHelper.swift
//  TabBar_ios_team_a
//
//  Created by 권예진 on 2021/02/18.
//

import Foundation
import SQLite3

class DBHelper {
    
    var db: OpaquePointer?
    var path: String = "calendarDB.sqlite"
    
    init() {
        self.db = createDB()
        self.createTable()
    }
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("there is error in creating db")
            return nil
        }
        else{
            print("Database is been created with path \(path)")
            return db
        }
    }
    
    func createTable(){
     let query = "CREATE TABLE IF NOT EXISTS todo(date INTEGER NOT NULL, title TEXT NOT NULL, comleteOrNot INTEGER NOT NULL, PRIMARY KEY(date, title));"
        var createTable : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("table creation success")
            }
            else{
                print("table creation fail")
                
            }
        }else{
            print("preparation fail")
        }
        
        let query1 = "CREATE TABLE IF NOT EXISTS calendar_group(name TEXT NOT NULL, color TEXT NOT NULL, PRIMARY KEY(name));"
           var createTable1 : OpaquePointer? = nil
           
           if sqlite3_prepare_v2(self.db, query1, -1, &createTable1, nil) == SQLITE_OK {
               if sqlite3_step(createTable1) == SQLITE_DONE {
                   print("table1 creation success")
               }
               else{
                   print("table1 creation fail")
                   
               }
           }else{
               print("preparation1 fail")
           }
        
        
        let query2 = "CREATE TABLE IF NOT EXISTS calendar(title TEXT NOT NULL, date INTEGER NOT NULL, calendar_group TEXT NOT NULL, alarm_hour INTEGER, alarm_min INTEGER, PRIMARY KEY(date, title));"
           var createTable2 : OpaquePointer? = nil
           
           if sqlite3_prepare_v2(self.db, query2, -1, &createTable2, nil) == SQLITE_OK {
               if sqlite3_step(createTable2) == SQLITE_DONE {
                   print("table2 creation success")
               }
               else{
                   print("table2 creation fail")
                   
               }
           }else{
               print("preparation2 fail")
           }
    }
    func insertData(){
        //calendar insert
        let insertStatementString = "INSERT INTO calendar (title, date, calendar_group, alarm_hour, alarm_min) VALUES (?, ?, ?, ?, ?);"

       
        var insertStatement: OpaquePointer? = nil
           
           // 1
           if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
               let title: NSString = "철수와 약속"
               let date: Int32 = 20210220
               let calendar_group: NSString = "friends"
               let alarm_hour: Int32 = 10
               let alarm_min: Int32 = 30
               // 2
               sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil)
               sqlite3_bind_int(insertStatement, 2, date)
               sqlite3_bind_text(insertStatement, 3, calendar_group.utf8String, -1, nil)
               sqlite3_bind_int(insertStatement, 4, alarm_hour)
               sqlite3_bind_int(insertStatement, 5, alarm_min)
               //3
               if sqlite3_step(insertStatement) == SQLITE_DONE {
                   print("Successfully inserted row.")
               } else {
                   print("Could not insert row.")
               }
           } else {
               print("INSERT statement could not be prepared.")
           }
           // 4
           sqlite3_finalize(insertStatement)
        
        
        //calendar_group insert
        let insertStatementString1 = "INSERT INTO calendar_group (name, color) VALUES (?, ?);"

       
        var insertStatement1: OpaquePointer? = nil
           
           // 1
           if sqlite3_prepare_v2(db, insertStatementString1, -1, &insertStatement1, nil) == SQLITE_OK {
               let name: NSString = "friends"
               let color: NSString = "yellow"
               
               // 2
               sqlite3_bind_text(insertStatement1, 1, name.utf8String, -1, nil)
               sqlite3_bind_text(insertStatement1, 2, color.utf8String, -1, nil)
               //3
               if sqlite3_step(insertStatement1) == SQLITE_DONE {
                   print("1 Successfully inserted row.")
               } else {
                   print("1 Could not insert row.")
               }
           } else {
               print("1 INSERT statement1 could not be prepared.")
           }
           // 4
           sqlite3_finalize(insertStatement1)
        
        
        //todo insert
        let insertStatementString2 = "INSERT INTO todo(date, title, completeOrNot) VALUES (?, ?, ?);"

       
        var insertStatement2: OpaquePointer? = nil
           
           // 1
           if sqlite3_prepare_v2(db, insertStatementString2, -1, &insertStatement2, nil) == SQLITE_OK {
            let date: Int32 = 20210220
            let title: NSString = "이메일보내기"
            let completeOrNot: Int32 = 0
            // 2
            sqlite3_bind_int(insertStatement2, 1, date)
            sqlite3_bind_text(insertStatement2, 2, title.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement2, 3, completeOrNot)
           
            //3
               //3
               if sqlite3_step(insertStatement2) == SQLITE_DONE {
                   print("2 Successfully inserted row.")
               } else {
                   print("2 Could not insert row.")
               }
           } else {
               print("2 INSERT statement1 could not be prepared.")
           }
           // 4
           sqlite3_finalize(insertStatement2)
    }
    func insertIntoCalendar(calendarInstance: CalendarInstance){
        //calendar insert
        let insertStatementString = "INSERT INTO calendar (title, date, calendar_group, alarm_hour, alarm_min) VALUES (?, ?, ?, ?, ?);"
       
        var insertStatement: OpaquePointer? = nil
           
           // 1
           if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
//               let title: NSString = "철수와 약속"
//               let date: Int32 = 20210220
//               let calendar_group: NSString = "friends"
//               let alarm_hour: Int32 = 10
//               let alarm_min: Int32 = 30
               // 2
               sqlite3_bind_text(insertStatement, 1, calendarInstance.title.utf8String, -1, nil)
               sqlite3_bind_int(insertStatement, 2, calendarInstance.date)
               sqlite3_bind_text(insertStatement, 3, calendarInstance.calendar_group.utf8String, -1, nil)
               sqlite3_bind_int(insertStatement, 4, calendarInstance.alarm_hour)
               sqlite3_bind_int(insertStatement, 5, calendarInstance.alarm_min)
               //3
               if sqlite3_step(insertStatement) == SQLITE_DONE {
                   print("Successfully inserted row.")
               } else {
                   print("Could not insert row.")
               }
           } else {
               print("INSERT statement could not be prepared.")
           }
           // 4
           sqlite3_finalize(insertStatement)
    }
    
   
}


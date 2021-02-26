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
     let query = "CREATE TABLE IF NOT EXISTS todo(date TEXT NOT NULL, title TEXT NOT NULL, comleteOrNot INTEGER NOT NULL, PRIMARY KEY(date, title));"
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
        
        
        let query2 = "CREATE TABLE IF NOT EXISTS calendar(title TEXT NOT NULL, date TEXT NOT NULL, calendar_group TEXT NOT NULL, alarm_hour INTEGER, alarm_min INTEGER, id integer primary key autoincrement);"
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
    
    func insertIntoCalendar(calendarInstance: CalendarInstance){
        //calendar insert
        let insertStatementString = "INSERT INTO calendar (title, date, calendar_group, alarm_hour, alarm_min) VALUES (?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
           // 1
           if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
               // 2
               sqlite3_bind_text(insertStatement, 1, calendarInstance.title.utf8String, -1, nil)
               sqlite3_bind_text(insertStatement, 2, calendarInstance.date.utf8String, -1, nil)
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
    
    func updateInstCalendar(calendarInstance: CalendarInstance){
        //calendar update
        let updateStatementString = "UPDATE calendar SET title = ?, calendar_group = ?, alarm_hour = ?, alarm_min = ? WHERE date = ?;"
        var updateStatement: OpaquePointer? = nil
           // 1
           if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
               // 2
               sqlite3_bind_text(updateStatement, 1, calendarInstance.title.utf8String, -1, nil)
               sqlite3_bind_text(updateStatement, 2, calendarInstance.calendar_group.utf8String, -1, nil)
               sqlite3_bind_int(updateStatement, 3, calendarInstance.alarm_hour)
               sqlite3_bind_int(updateStatement, 4, calendarInstance.alarm_min)
               sqlite3_bind_text(updateStatement, 5, calendarInstance.date.utf8String, -1, nil)
               //3
               if sqlite3_step(updateStatement) == SQLITE_DONE {
                   print("Successfully updated row.")
               } else {
                   print("Could not insert row.")
               }
           } else {
               print("INSERT statement could not be prepared.")
           }
           // 4
           sqlite3_finalize(updateStatement)
    }
    
    func deleteInstCalendar(calendarInstance: CalendarInstance){
        //calendar delete
        let deleteStatementString = "DELETE FROM calendar WHERE date = ? AND title = ?;"
        var deleteStatement: OpaquePointer? = nil
           // 1
           if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
               // 2
               sqlite3_bind_text(deleteStatement, 1, calendarInstance.date.utf8String, -1, nil)
               sqlite3_bind_text(deleteStatement, 2, calendarInstance.title.utf8String, -1, nil)
               //3
               if sqlite3_step(deleteStatement) == SQLITE_DONE {
                   print("Successfully delete row.")
               } else {
                   print("Could not delete row.")
               }
           } else {
               print("DELETE statement could not be prepared.")
           }
           // 4
           sqlite3_finalize(deleteStatement)
    }
    
    func deleteAllCalendar(){
        //calendar delete
        let deleteStatementString = "DELETE FROM calendar;"
        var deleteStatement: OpaquePointer? = nil
           // 1
           if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
               if sqlite3_step(deleteStatement) == SQLITE_DONE {
                   print("Successfully delete ALL row.")
               } else {
                   print("Could not delete row.")
               }
           } else {
               print("DELETE statement could not be prepared.")
           }
           // 4
           sqlite3_finalize(deleteStatement)
    }
    
    func selectCalendar(now:String)->[CalendarInstance]{
        let selectStatementString = "SELECT * FROM calendar WHERE date = '\(now)';"
        var selectStatement: OpaquePointer? = nil
        var cilist = [CalendarInstance]()
        if sqlite3_prepare_v2(db, selectStatementString, -1, &selectStatement, nil) == SQLITE_OK{
            while(sqlite3_step(selectStatement) == SQLITE_ROW){
                var ci = CalendarInstance()
                ci.date = String(cString: sqlite3_column_text(selectStatement, 1)) as NSString
                ci.title = String(cString: sqlite3_column_text(selectStatement, 0)) as NSString
                ci.calendar_group = String(cString: sqlite3_column_text(selectStatement, 2)) as NSString
                cilist.append(ci)
                print("\(ci.date):\(ci.title)")
            }
        } else {
            print("SELECT statement could not be prepared.")
        }
        return cilist
    }
   
}

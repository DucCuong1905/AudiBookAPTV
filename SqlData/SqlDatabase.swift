//
//  SqlDatabase.swift
//  AudiBookAppTV
//
//  Created by nguyenhuyson on 9/24/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//
import Foundation
import SQLite

// Lớp connect với Database

class SqlDataBase{
    // tạo 1 singleton để gọi sqldatabáse
    static let shared = SqlDataBase()
    // khai báo phương thức connection
    public let connection: Connection?
    public let dataFileName = "sqliteDulieu.sqlit3"
    private init(){
        // lấy ra đường dẫn thư mục của nó
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        print("Đường dânz \(dbPath!)")
        
        let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = document.appendingPathComponent("Book.db")
        do
        {
            // khởi tạo kết nối
            connection = try Connection(fileUrl.path)
        } catch
        {
            connection = nil
            let nserr = error as NSError
            print("Cannot connect to Database. Error is: \(nserr), \(nserr.userInfo)")
        }
    }
}

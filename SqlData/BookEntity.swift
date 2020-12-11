//
//  BookEntity.swift
//  AudiBookAppTV
//
//  Created by nguyenhuyson on 9/24/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//


import Foundation
import SQLite
class BookEntity{
    //id, name, addrress, city
     static let shared = BookEntity()
    
   
    
     // khai báo 1 table
    private let tblBook = Table("tblBook")
    
    
    // khai báo cá thành phần trong table(lblDepartment)
    
    
    
    
    private let id = Expression<Int64>("id")
    private let  idBook = Expression<String>("idBook")
    private let titleBook = Expression<String>("titleBook")
    private let imageBook = Expression<String>("imageBook")
    private let authorBook = Expression<String>("authorBook")
    private let favorite = Expression<String>("favorite")
    private let isLiked = Expression<String>("isLiked")
    private let isViewed = Expression<String>("isViewed")
    private let isDownload = Expression<String>("isDownload")
    
    
    // trong hàm khởi tạo thì kiểm tra nếu mà table đã được tạo thì không tạo nữa.còn chưa thì tạo
    private init()
    {
        
        do{
            // khởi tạo kết nối đến database
            if let connection = SqlDataBase.shared.connection{
                
                // chạy cái truy vấn khởi tạo // ifnotexists: true. nếu tạo rồi thì không tạo lại nữa
                // có phương thức closure để cho việc sau khi tạo xong thì nó sẽ làm cái gì.
                
                try connection.run(tblBook.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { (table) in
                    
                    // Thêm cột cho bẳng sau khi đã được tạo thành công
                    table.column(id, primaryKey: true)
                    table.column(idBook)
                    table.column(titleBook)
                    table.column(imageBook)
                    table.column(authorBook)
                    table.column(favorite)
                    table.column(isLiked)
                    table.column(isViewed)
                    table.column(isDownload)
                    
                }))
                
            
            }
            
        }catch
        {
            let nsError = error as NSError
            print("Cannnont create to Table, Error is: \(nsError) ,\(nsError.userInfo)")
        }
    }
    
    // phương thức để lấy ra thông tin 1 dòng trong databaset
    func covertRowToBook(book: Row) -> Book
    {
        
         var bookReturn = Book()
        bookReturn.id = String(book[id])
        bookReturn.idBook = book[idBook]
        bookReturn.titleBook = book[titleBook]
        bookReturn.authorBook = book[authorBook]
        bookReturn.imageBook = book[imageBook]
        bookReturn.isLiked = Bool(book[isLiked])!
        bookReturn.isViewed = Bool(book[isViewed])!
        bookReturn.isDownload = Bool(book[isDownload])!
        bookReturn.favorite = book[favorite]
        return bookReturn
    }
    
    
    func isLike(book: Row) -> Bool

    {
        if let like = Bool(book[isLiked])
        {
            return like
        }
       return false
    }
    
    // Lấy ra tất cả các giá trị bản ghi. kiểu trả về của nó là AnySequeen<Row>?
    
    func getAllData() -> AnySequence<Row>?
    {
        do{
            // truyền vào cái table
             return try SqlDataBase.shared.connection?.prepare(self.tblBook)
           
            
        }catch
        {
            let nsError = error as NSError
            print("Cannot get Data: error is: \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    
    // Lấy dữ liệu với điều kiện
    
    func getDataFilter(id: Int64) -> AnySequence<Row>? {
        do{
            // id = ?
            let filterCondition = (self.id == id)
            print("filter \(filterCondition)")
            
            //id trong khoảng khoảng này thì in ra hếtß
            //let filterCondition = [1,2,5,6].contains(self.id)
            
            //id tìm hết các tên có kí tự kaka
           // let filterCondition = self.name.like("%kaka%")
           
            // tìm với điều kiện và
          //  let filterCondition = (self.id <= 3) && (name.lowercaseString == "hahha")
            
            // tìm với điều kiện hoặc
           // let filterCondition = (self.id == 3 ) || (name == "Hà Nội")
            
            return try SqlDataBase.shared.connection?.prepare(self.tblBook.filter(filterCondition))
        }catch
        {
            let nsError = error as NSError
            print("Cannot get Data: error is: \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    
    
    func getRowBookViewed() -> AnySequence<Row>?
    {
        do{
            let filterCondition = (self.isViewed == String(true))
            print("filter \(filterCondition)")
            
            return try SqlDataBase.shared.connection?.prepare(self.tblBook.filter(filterCondition))
        }catch
        {
            let nsError = error as NSError
            print("Cannot get Data: error is: \(nsError), \(nsError.userInfo)")
            return nil
        }
     
        
    }

   
    func getRowBookFavorite() -> AnySequence<Row>?
    {
        do{
            let filterCondition = (self.isLiked == String(true))
            print("filter \(filterCondition)")
            
            
            return try SqlDataBase.shared.connection?.prepare(self.tblBook.filter(filterCondition))
        }catch
        {
            let nsError = error as NSError
            print("Cannot get Data: error is: \(nsError), \(nsError.userInfo)")
            return nil
        }
     
        
    }
    
    
    
    // Dữ Liệu trả về cho bên My Audio
    func getDataBookViewed() -> [Book]
    {
        var listBook = [Book]()
        if let data = getRowBookViewed(){
            for i in data{
                listBook.append(covertRowToBook(book: i))
            }
        }
        return listBook
    }
    
    
    func getDataBookFavorite() -> [Book]
    {
        var listBook = [Book]()
        if let data = getRowBookFavorite(){
            for i in data{
                listBook.append(covertRowToBook(book: i))
            }
        }
        return listBook
    }
    
    
    
    
    
    
    //  Hàm thêm giá trị có dữ liệu trả về là cái id của dòng đã thêm
    func insertData(book: Book) -> Int64?
    {
        do{
            book.isViewed = true
            // Tạo câu truy vấn
            let queryInsert = tblBook.insert( self.id <- Int64(book.id)!,
                                                   self.idBook <- book.idBook,
                                                   self.titleBook <- book.titleBook,
                                                   self.imageBook <- book.imageBook,
                                                   self.authorBook <- book.authorBook,
                                                   self.favorite <- String(book.favorite),
                                                   self.isLiked <- String(book.isLiked),
                                                   self.isViewed <- String(book.isViewed),
                                                   self.isDownload <- String(book.isDownload)
            
            )
            
            
            // kêt nối với database và thực hiện thêm dữ liệu
            let insertSuccess = try SqlDataBase.shared.connection?.run(queryInsert)
            
            // trả về ID của dòng đã được thêm
            return insertSuccess
            
        }catch
        {
            let nsError = error as NSError
            print("Cannot insert Deparment: Error is: \(nsError), \(nsError.userInfo)")
            return nil
        }
    }
    
    
    //Sử dữ liệu
     // like thì truyền true. còn unlike thì truyền false vao
    func updateLikeOrUnLike(book: Book, like: Bool) -> Bool
    {
        do{
            if SqlDataBase.shared.connection == nil{
                return false
            }
            // cái này là where
            let tblFilter = self.tblBook.filter(self.id == Int64(book.id)!)
            book.isLiked = like
            // truyền cái giá trị mới
            var setter: [SQLite.Setter] = [SQLite.Setter]()
            setter.append(self.id <- Int64(book.id)!)
            setter.append(self.idBook <- book.idBook)
            setter.append(self.titleBook <- book.titleBook)
            setter.append(self.authorBook <- book.authorBook)
            setter.append(self.favorite <- book.favorite)
            setter.append(self.isLiked <- String(book.isLiked))
            setter.append(self.isViewed <- String(book.isViewed))
            setter.append(self.isDownload <- String(book.isDownload))
            // xong câu truy vấn
            let tblUpdate = tblFilter.update(setter)
            if try SqlDataBase.shared.connection!.run(tblUpdate) <= 0
            {
                return false
            }
            return true
        }catch
        {
           let nsError = error as NSError
            print("Cannot update data, Error is: \(nsError), \(nsError)")
            return false
        }
        
    }
    
    
    
    // Xoá dữ liệu
    func deleteData(id: Int64) -> Bool
    {
        do
        {
            if SqlDataBase.shared.connection == nil{
                return false
            }
            let filterCondition = (self.id == id)
            let tblFilter = self.tblBook.filter(filterCondition)
            try SqlDataBase.shared.connection?.run(tblFilter.delete())
            return true
        }catch
        {
           let nsError = error as NSError
            print("Cannot delete row! Error is: \(nsError), \(nsError)")
            return false
        }
    }
    
    
    
    
    
    
}

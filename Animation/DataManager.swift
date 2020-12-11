//
//  DataManager.swift
//  audioBooks
//
//  Created by Quang Nguyễn  on 3/25/20.
//  Copyright © 2020 PTIT. All rights reserved.
//


import Foundation
import RealmSwift
import Alamofire

class DataManager: NSObject {
    var realm: Realm!
    static let shared = DataManager()
    
    override init() {
        var config = Realm.Configuration.defaultConfiguration
         print("Đường dẫn \(Realm.Configuration.defaultConfiguration.fileURL)")
        config.schemaVersion = 2
        config.migrationBlock = { migration, oldSchemaVersion in }
        realm = try! Realm(configuration: config)
       
        
        
    }
    
    func loadBookDownloaded() -> [Book]{
        return Array(realm.objects(Book.self).filter("isDownload == true").sorted(byKeyPath: "viewDate", ascending: false))
    }
    
    func loadBookFavourites() -> [Book]{
        return Array(realm.objects(Book.self).filter("isLiked == true").sorted(byKeyPath: "viewDate", ascending: false))
    }
    
    func loadBookViewed() -> [Book]{
        return Array(realm.objects(Book.self).filter("isViewed == true").sorted(byKeyPath: "viewDate", ascending: false))
    }
    
    func book(bookId: String) -> Book?{
        return realm.object(ofType: Book.self, forPrimaryKey: bookId)
    }
    
    
    
    func isFavorite(bookId: String) -> Bool{
        if let movie = realm.object(ofType: Book.self, forPrimaryKey: bookId){
            return movie.isLiked
        }
        return false
    }
    
    func viewBook(book: Book){
    
        if let oldBook = self.book(bookId: book.id){
            try! realm.write {
                // thực hiện việc update dữ liệu khi người ta bấm vào like
                book.isLiked = oldBook.isLiked
                book.isDownload = oldBook.isDownload
                book.isViewed = true
                book.viewDate = Date()
                realm.add(book, update: .all)
                print("Add boook")
               
            }
        }else{
            try! realm.write {
                // Thực viện việc thêm dữ liệu khi mà người ta bấm vào xem
                book.isDownload = false
                book.isLiked = false
                book.isViewed = true
                book.viewDate = Date()
                realm.add(book, update: .all)
                print("Book dowload is false")
            }
        }
    }
    
    // cập nhật dữ liệu like book
    func favorite(book: Book) ->Book{
        try! realm.write {
            book.isLiked = true
            realm.add(book, update: .all)
        }
        return book
    }
    
    
    // cập nhật dữ liệu unlike book
    @discardableResult
    func unFavorite(book: Book) ->Book{
        try! realm.write {
            book.isLiked = false
            realm.add(book, update: .all)
        }
        return book
    }

    // thêm cái listlink của thằng audio
    func addAudioToDownloadedList(id:[String], bookID:String) {
        let object = Chapter()
        object.bookID = bookID
        object.downloadedListAudio.append(contentsOf: id)
        DataManager.shared.addObject(object: object)
    }
    
    //MARK: -- get object
    // lất ra danh sách book
    func getBooks() -> [Book] {
        return Array(realm.objects(Book.self))
    }
    
    //MARK: -- Commond
    // thêm một đối tượng
    @discardableResult
    func addObject(object: Object) ->Object{
        try! realm.write {
            realm.add(object, update: .all)
        }
        return object
    }
    
    
    // xoá 1 đối tượng
    func deleteObject(object: Object){
        try! realm.write {
            realm.delete(object)
        }
    }
    
    
    // xoá nhiều đối tượng
    func deleteObjects(objects: [Object]){
        try! realm.write {
            realm.delete(objects)
        }
    }
}

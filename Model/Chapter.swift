//
//  Chapter.swift
//  audioBooks
//
//  Created by Quang Nguyễn  on 3/27/20.
//  Copyright © 2020 PTIT. All rights reserved.
//


import Foundation
import RealmSwift
import ObjectMapper

class Chapter: Object, Mappable {
    
    @objc dynamic var id = "0"
    @objc dynamic var bookID = ""
    @objc dynamic var titleChapter = ""
    @objc dynamic var urlChapter = ""
    @objc dynamic var urlHtml = ""
    
    var downloadedListAudio = [String]()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        if let order_chapter =  map.JSON["order_chapter"] as? String{
            id = order_chapter
            titleChapter         <- map["title_chapter"]
        }else{
            id                  <- map["id"]
            titleChapter         <- map["title"]
        }
        urlChapter           <- map["url_chapter"]
        urlHtml              <- map["url"]
    }
}

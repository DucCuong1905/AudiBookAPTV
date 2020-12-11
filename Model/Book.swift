//
//  Books.swift
//  audioBooks
//
//  Created by Quang Nguyễn  on 3/25/20.
//  Copyright © 2020 PTIT. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Book: Object,  Mappable {
    
    @objc dynamic var id = "0"
    @objc dynamic var idBook = ""
    @objc dynamic var titleBook = ""
    @objc dynamic var imageBook = ""
    @objc dynamic var authorBook = ""
    @objc dynamic var favorite = ""
    @objc dynamic var descriptionBook = ""
    @objc dynamic var text_book = ""
    @objc dynamic var isLiked = false
    @objc dynamic var viewDate = Date()
    @objc dynamic var isViewed = false
    @objc dynamic var isDownload = false

    override static func primaryKey() -> String? {
        return "id"
    }

    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        id                  <- map["id"]
        idBook              <- map["id_book"]
        titleBook           <- map["title_book"]
        imageBook           <- map["url_image_book"]
        authorBook          <- map["author_book"]
        descriptionBook     <- map["desc_book"]
        favorite            <- map["status_book"]
        text_book            <- map["text_book"]
    }
    
    func textBookIds() -> [String]{
        return text_book.components(separatedBy: "*")
    }
}

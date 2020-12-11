//
//  HttpClient.swift
//  BitEclipse
//
//  Created by Nhuom Tang on 24/4/19.
//  Copyright © 2019 Nhuom Tang. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

extension BaseClient{

    func getChapter(idBook: String) -> Promise<[Chapter]> {
        let newidBook = idBook.replacingOccurrences(of: "http://www.", with: "", options: .anchored)
        let url = "http://www.aduapp.space/audiobookapi/getbook2.php/?id_book=\(newidBook)"
        return request(.get, url, parameters: [:], encoding: URLEncoding.default, headers: nil).responseArrayTask()
    }
    
    func getChapterHtml(bookId: String) -> Promise<[Chapter]> {
        let url = "http://www.aduapp.space/audiobookapi/getlisttxtbook.php"
        let param: [String: Any] = ["textbook": bookId]
        return request(.get, url, parameters: param, encoding: URLEncoding.default, headers: nil).responseArrayTask()
    }
    
    func getAllBooks(category: String, numberPage: Int) -> Promise<[Book]> {
        //print("Allbook")
        var str = category
        if category == "All"{
            str = "all"
        }
        let url = "http://www.aduapp.space/audiobookapi/getgen.php"
        var param: [String: Any] = ["gene": str]
        param["page"] = numberPage
        
        print("Paramneter: \(param)") //kiểu dicionnary
        
        return request(.get, url, parameters: param, encoding: URLEncoding.default, headers: nil).responseArrayTask()
    }
    
    func searchBook(keyword: String) -> Promise<[Book]> {
        let url = "http://www.aduapp.space/audiobookapi/search.php"
        let param: [String: String] = ["text": keyword]
        return request(.get, url, parameters: param, encoding: URLEncoding.default, headers: nil).responseArrayTask()
    }
    
    
    func imageFrom(_ urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
              let session = URLSession.shared
              if let url = URL(string: urlString) {
                  let request = URLRequest(url: url)
                  let task = session.dataTask(with: request) {

                      (data, response, error) in
                      guard error == nil else {
                        completion(nil, Error.self as! Error)
                          return
                      }
                      guard let data = data else {
                          completion(nil, Error.self as! Error)
                          return
                      }
                      if let image = UIImage(data: data) {
                          completion(image, nil)
                      }
                  }
                  task.resume()
              }
          }
}

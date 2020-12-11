//
//  WEbview.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/15/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

class Search: UIViewController {

    @IBOutlet var nv: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

          
              let webViewClass : AnyObject.Type = NSClassFromString("UIWebView")!
              let webViewObject : NSObject.Type = webViewClass as! NSObject.Type
              let webview: AnyObject = webViewObject.init()
              let url = NSURL(string: "https://www.youtube.com/watch?v=ZZu4pdH80Fs")
              let request = NSURLRequest(url: url as! URL)
              webview.loadRequest(request as URLRequest)
              let uiview = webview as! UIView
        uiview.frame = CGRect(x: 0, y: 0, width: nv.frame.width , height: nv.frame.height)
              nv.addSubview(uiview)
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

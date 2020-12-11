//
//  MenuView.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/10/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

var i: Int = 1

class MenuView: UIViewController {

    var listButton: [UIButton] = [UIButton]()
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnMyAudio: UIButton!
    @IBOutlet weak var btnExplore: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if i == 0{
            buttonActive(btnExplore)
        }
        listButton = [btnSearch, btnSetting, btnExplore, btnMyAudio]
        var lineview = UIView(frame: CGRect(x: 0,y:  btnSearch.frame.size.height, width: btnSearch.frame.size.width, height: 2))
        lineview.backgroundColor = UIColor.red
        btnSearch.addSubview(lineview)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnClickForAll(_ sender: Any) {
        let button = sender as! UIButton
        switch button {
        case btnMyAudio: print("audio")
            break
        case btnExplore:
      //  i = 
        let src = storyboard?.instantiateViewController(withIdentifier: "MyAudioViewController") as! MyAudioViewController
               // src.book = books[indexPath.row]
                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                    self.present(src, animated: true , completion: nil)
                })
        
        ; break
        case btnSetting: print("Setting") ; break
        case btnSearch: print("Search") ; break
        default:
            break
        }
    }
    
    
    
    func buttonActive(_ button: UIButton)
    {
        var lineview = UIView(frame: CGRect(x: 0,y:  button.frame.size.height, width: button.frame.size.width, height: 2))
               lineview.backgroundColor = UIColor.red
               button.addSubview(lineview)
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



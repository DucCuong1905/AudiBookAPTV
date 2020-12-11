//
//  SettingVC.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/23/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {

    
    @IBOutlet var listButton: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configButton()

        // Do any additional setup after loading the view.
    }


    func configButton(){
        
        for button in listButton{
            
            button.layer.backgroundColor = .init(srgbRed: 255, green: 255, blue: 255, alpha: 1)
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 30
        }
    }
    
    @IBAction func btnClick(_ sender: Any) {
      //  let src = storyboard?.instantiateViewController(identifier: "PrivacyVC") as! PrivacyVC
        //.present(src, animated: true, completion: nil)
        
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

                        if let button = context.previouslyFocusedView as? UIButton{
                              coordinator.addCoordinatedAnimations({ () -> Void in
                              button.transform = CGAffineTransform.identity
                               }, completion: nil)

                      }
             
                  if let button = context.nextFocusedItem as? UIButton{
                              
                              coordinator.addCoordinatedAnimations({ () -> Void in
                                              button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

                                             }, completion: nil)
                      }
              
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

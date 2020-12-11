//
//  Menu.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/16/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//


import UIKit

protocol IButtonClick {
    func buttonClick(_ click: String)
}

class MenuMainView: UIView {
   
    @IBOutlet weak var btnExplore: UIButton!
    @IBOutlet weak var btnMyAudio: UIButton!
    
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    let nibName = "Menu"
    var ibutton: IButtonClick?
   
    required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
    
    
    @IBAction func btnSearch(_ sender: Any) {
        
        ibutton?.buttonClick("Đã Search")
        
//        let main = UIStoryboard(name: "Main", bundle: nil)
//        guard let resultsController = main.instantiateViewController(withIdentifier: "SearchFF") as? SearchFF else { fatalError("Unable to instantiate a SearchResultsViewController.") }
//                      // Tạo searchUI controller
//                      let searchController = UISearchController(searchResultsController: resultsController)
//                      searchController.searchResultsUpdater = resultsController
//                      searchController.hidesNavigationBarDuringPresentation = false
//
//        let searchPlaceholderText = NSLocalizedString("Search for a Show or Movie", comment: "")
//                      searchController.searchBar.placeholder = searchPlaceholderText
//            searchController.searchBar.tintColor = UIColor.black
//               searchController.searchBar.barTintColor = UIColor.black
//               searchController.searchBar.searchBarStyle = .minimal
//        searchController.view.backgroundColor = .gray
//                      // gọi viewroot để truyền sang
//                      guard let rootViewController = self.window?.rootViewController else { fatalError("Unable to get root view controller.") }
//                rootViewController.view.backgroundColor = .gray
//                      rootViewController.present(searchController, animated: true, completion: nil)

    }
    func commonInit() {
           guard let view = loadViewFromNib() else { return }
           view.frame = bounds
           addSubview(view)
       }
       
       func loadViewFromNib() -> UIView? {
           let nib = UINib(nibName: nibName, bundle: nil)
           return nib.instantiate(withOwner: self, options: nil).first as? UIView
       }
}

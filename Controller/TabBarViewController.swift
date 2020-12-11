//
//  TabBarViewController.swift
//  Search
//
//  Created by Marcos Polanco on 8/1/17.
//  Copyright © 2017 Visor Labs. All rights reserved.
//


//
//  Create a file called TabBarViewController.swift
//

import UIKit
var searchContainerViewController:UISearchContainerViewController!
class TabBarViewController: UITabBarController, UINavigationControllerDelegate {
    
    var window: UIWindow?
    
    func searchContainerDisplay(){
        // gọi và trả kết quả về cho bên searchVC
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        let searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = resultsController
        
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        // cái này dùng để việc sử dụng nhiều ngôn ngữ khác nhau
        let searchPlaceholderText = NSLocalizedString("Search Title", comment: "")
        searchController.searchBar.placeholder = searchPlaceholderText
        
        // cái này không còn ảnh hưởng đến background của bar trong phiên bản ios 7.0
        searchController.searchBar.tintColor = UIColor.black
        
       // cái này mới có ảnh hưởng đến
        searchController.searchBar.barTintColor = UIColor.black
        searchController.searchBar.searchBarStyle = .minimal// hiển thị cho calerder notes
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.light // hiển thị keyboard
        
        // cái này để chứa cái search
        searchContainerViewController = UISearchContainerViewController(searchController: searchController)
        // thực hiện thêm cái searchContainer là cái để chứa ở trên cái navigation
        let navController = UINavigationController(rootViewController: searchContainerViewController)
        
        
     //   navController.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgrSearch")!) // cái này để thêm cái background cho công cụ search
        
        // Thiết lập cái Homvc là cái navigationrootView
        let explore = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExploreViewController") as! ExploreViewController
        let exploreViewController = UINavigationController(rootViewController: explore)
        
        let setting = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        let settingViewController = UINavigationController(rootViewController: setting)

        // thiết lâp cái game là rootView Controller:
        let myAudio = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyAudioViewController") as! MyAudioViewController
        let myAudioViewController = UINavigationController(rootViewController: myAudio)
        
       
        
        
        // cho vào mảng viewcontroller
        self.viewControllers = [exploreViewController,myAudioViewController,settingViewController,navController]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // thiết lập hiển thị
       self.searchContainerDisplay()
    
        // Sets the default color of the icon of the selected UITabBarItem and Title
        //UIBarButtonItem.appearance().tintColor = UIColor.black
       // UITabBar.appearance().tintColor = UIColor.black
        // Sets the default color of the background of the UITabBar
       // UITabBar.appearance().barTintColor = UIColor.gray

        UITabBar.appearance().isTranslucent = true
      
        if let tbItems = self.tabBar.items{
         let tabBarItem1: UITabBarItem = tbItems[0]
           let tabBarItem2: UITabBarItem = tbItems[1]
            let tabBarItem3: UITabBarItem = tbItems[2]
            let tabBarItem4: UITabBarItem = tbItems[3]
        
            UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
           tabBarItem1.title = "Explore"
        tabBarItem2.title = "My Audio"
            tabBarItem3.title = "Setting"
            tabBarItem4.title = "Search"
        
            
            // thiết lập hiển thị cho các cái bar
        }
        
        if let tabBarItems = self.tabBar.items{

            for item in tabBarItems as [UITabBarItem]
            {
                //Preserves white Color on selected
                // thiết lập cái màu background cho cái nút hiển thị ở trên
                self.tabBar.barTintColor = UIColor.blue
                
                // thay đổi thuộc tính và màu chữ của noá/
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], for:UIControl.State()) // trạng thái chữ khi mà chưa được chọn
                //item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.green], for:UIControl.State.disabled)
                item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for:UIControl.State.selected) // trạng thái chữ khi mà được chọn
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

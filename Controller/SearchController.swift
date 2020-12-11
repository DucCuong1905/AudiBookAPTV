//
//  SearchController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/15/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

class SearchController: UIViewController, UISearchResultsUpdating {
    
    var books: [Book] = []
    //    var peopleResultsViewController: SearchPeopleResultsVC?
    
    func updateSearchResults(for searchController: UISearchController) {
       // searchController.searchResultsController?.view.isHidden = false
        guard let text = searchController.searchBar.text else { return }
        DispatchQueue.main.async {
                 BaseClient.shared.searchBook(keyword: text).done { [weak self] (result) in
                            self?.books.removeAll()
                            self?.books.append(contentsOf: result)
                     self?.SearchCLV.reloadData()
              }
          }
        
    }
    
    
    func createSearch(storyboard: UIStoryboard?) -> UIViewController {
        guard let movieListController = storyboard?.instantiateViewController(withIdentifier: "SearchController") as? SearchController else {
            fatalError("Unable to instantiate a NewsController")
        }
        
        let searchController = UISearchController(searchResultsController: movieListController)
        searchController.searchResultsUpdater = movieListController
        
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        return searchContainer
    }
    @IBOutlet weak var lbl1: UITextField!
    
   
    @IBOutlet weak var SearchCLV: UICollectionView!
    var searchContainerViewController:UISearchContainerViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl1.becomeFirstResponder()
        
        layoutCLV()
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStoryBoard.instantiateViewController(withIdentifier: "SearchController") as! SearchController
        let searchController = UISearchController(searchResultsController: search)
        searchController.searchResultsUpdater = search
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        SearchCLV.delegate = self
        SearchCLV.dataSource = self
    }
    @IBAction func editBegin(_ sender: Any) {
        print("edit begin")
    }
    @IBAction func btEditchange(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            
            print(self.lbl1.text)
        })
        print("EditchANge")
    }
    
    @IBAction func EditEnd(_ sender: Any) {
        print("Đã thành công")
    }
    @IBAction func onEnd(_ sender: Any) {
        //print("Đã thành công1")
    }
    
     func layoutCLV(){
            SearchCLV.translatesAutoresizingMaskIntoConstraints = false
            SearchCLV.backgroundColor = .clear
            SearchCLV.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            SearchCLV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
            SearchCLV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
            SearchCLV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            
        SearchCLV.register(UINib(nibName: "BookCollectionView", bundle: nil), forCellWithReuseIdentifier: "BookCollectionView")
        }
}
    
    extension SearchController: UICollectionViewDataSource, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            return books.count
        }
        func collectionView( _ collectionView: UICollectionView,layoutcollectionViewLayout: UICollectionViewLayout,sizeForItemAtindexPath: IndexPath) -> CGSize {
            
            let yourPreferedWidth = SearchCLV.bounds.size.width - 20
            
            return CGSize(width: yourPreferedWidth , height: view.frame.width)
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionView", for: indexPath) as! BookCollectionView
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.lblBookTitle.text = books[indexPath.row].titleBook
            let url = URL(string: books[indexPath.row].imageBook)
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            cell.imgBook.image = UIImage(data: data!)
            cell.lblAuthor.text = books[indexPath.row].authorBook
            if DataManager.shared.isFavorite(bookId: books[indexPath.row].id)
            {
                cell.lblStar.isHidden = false
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
          let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionView
                  UIView.transition(with: cell, duration: 2, options: .transitionCurlUp,
                                         animations: {
                                          cell.backgroundColor = UIColor.white
                      })
                  
                  
                  let src = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                  src.book = books[indexPath.row]

          //        let transition = CATransition()
          //        transition.duration = 0.5
          //        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
          //        transition.type = CATransitionType.moveIn
          //        transition.subtype = CATransitionSubtype.fromTop
          //        navigationController?.view.layer.add(transition, forKey: nil)
          //        navigationController?.pushViewController(src, animated: false)
                  DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                      self.present(src, animated: true , completion: nil)
                  })
            
        }
    }


    extension SearchController: UICollectionViewDelegateFlowLayout {
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                return .zero
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 20
            }
            
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0
            }
            
            
            
            
            // CGSize thì truyền vào kích thước của cái con
            func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //        if UIDevice.current.userInterfaceIdiom == .pad{
        //            return CGSize(width: UIScreen.main.bounds.width, height: 150)
        //        }
        //        return CGSize(width: UIScreen.main.bounds.width, height: 150)
        //        print(collectionView.bounds.width)
              //   let yourWidth = collectionView.bounds.width/4
                //let yourHeight = collectionView.bounds.height/4
        //        print(yourWidth)
        //           let yourHeight = yourWidth

                   return CGSize(width: 290, height: 360)
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

//
//  SearchViewController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/23/20.
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
class SearchViewController: UIViewController, UISearchResultsUpdating {
    var dataSearch: [Book] = []
    var oldText = ""
    var newText = ""
    
    var imageCache = [String: UIImage?]()
    var dataBeingRefreshed = false
    //    var peopleResultsViewController: SearchPeopleResultsVC?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        newText = text
        
        
    }

    
    @IBOutlet weak var Search: UICollectionView!
   // @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCLV()
        Search.delegate = self
        Search.dataSource = self
        indicator.isHidden = true
        
       Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateAudio), userInfo: nil, repeats: true)
        
    }
    @objc func updateAudio(){
        
        
           if newText != oldText
           {
            if !stateInternet{
                let alertController = UIAlertController(title: "No Internet", message: "Please check your internet connection and try again ", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "0k", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                
                
            }
            else{
                oldText = newText
                 self.indicator.isHidden = false
                 self.indicator.stopAnimating()
                    BaseClient.shared.searchBook(keyword: newText).done { [weak self] (result) in
                           self?.dataSearch.removeAll()
                           self?.dataSearch.append(contentsOf: result)
                        DispatchQueue.main.async {
                            self?.Search.resignFirstResponder()
                            self?.Search.reloadData()
                         self?.indicator.isHidden = true
                         self?.indicator.stopAnimating()
                        }
                    print("ĐÃ hiện")
                }
            }
           }}

    func layoutCLV(){
        Search.translatesAutoresizingMaskIntoConstraints = false
        Search.backgroundColor = .clear
        Search.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        Search.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        Search.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        Search.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        Search.register(UINib(nibName: "BookCollectionView" , bundle: nil), forCellWithReuseIdentifier: "BookCollectionView")
    }
    
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
              
                 if let cell = context.previouslyFocusedView as? UICollectionViewCell {
                
                     coordinator.addCoordinatedAnimations({ () -> Void in
                         cell.transform = CGAffineTransform.identity
                         cell.layer.borderWidth = 0
                         cell.backgroundColor = .white
                          }, completion: nil)
                   }
               
             
                 if let cell = context.nextFocusedView as? UICollectionViewCell {
                     coordinator.addCoordinatedAnimations({ () -> Void in
                       cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                       cell.layer.borderWidth = 1
                         cell.backgroundColor = .orange
                         

                     }, completion: nil)
                 }
                
         }
    
    private func loadImage(for book: Book, into cell: BookCollectionView, at indexPath: IndexPath) {
             let urlString = book.imageBook
               if let cachedImage = imageCache[urlString] {
                cell.imgBook.image = cachedImage
                   if !dataBeingRefreshed {
                       self.indicator.isHidden = true
                      self.indicator.stopAnimating()
                   }
               } else {
                   BaseClient.shared.imageFrom(urlString) { (image, error) in
                       guard error == nil else {
                           print(error!)
                           return
                       }
                       self.imageCache[urlString] = image
                       DispatchQueue.main.async { [weak self] in
                           guard let self = self else { return }
                           if !self.dataBeingRefreshed {
                            self.indicator.isHidden = true
                             self.indicator.stopAnimating()
                           }
                           if book == self.dataSearch[indexPath.row] {
                               cell.imgBook.image = image
                           }
                       }
                   }
               }
           }
    
}






extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSearch.count
    }
    func collectionView( _ collectionView: UICollectionView,layoutcollectionViewLayout: UICollectionViewLayout,sizeForItemAtindexPath: IndexPath) -> CGSize {
        
        let yourPreferedWidth = Search.bounds.size.width - 20
        
        return CGSize(width: yourPreferedWidth , height: view.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = Search.dequeueReusableCell(withReuseIdentifier:"BookCollectionView", for: indexPath) as! BookCollectionView
            cell.layer.cornerRadius = 10
               cell.layer.masksToBounds = true
               cell.lblBookTitle.text = dataSearch[indexPath.row].titleBook
               let book = dataSearch[indexPath.row]
               //cell.configure(with: movie)
               loadImage(for: book, into: cell, at: indexPath)
               cell.lblAuthor.text = dataSearch[indexPath.row].authorBook
               
        return cell
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !stateInternet{
            let alertController = UIAlertController(title: "No Internet", message: "Please check your internet connection and try again ", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "0k", style: .default) { (action:UIAlertAction) in
                print("You've pressed default");
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
       let src = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        src.book = dataSearch[indexPath.row]
        self.present(src, animated: true, completion: nil)
        
    }
}





extension SearchViewController: UICollectionViewDelegateFlowLayout {
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
}

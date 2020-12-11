//
//  MyAudioViewController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/11/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit



class MyAudioViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var booksHistory: [Book] = []
    var booksLike: [Book] = []
    var imageCache = [String: UIImage?]()
        var dataBeingRefreshed = false

    @IBOutlet weak var indicatorHistory: UIActivityIndicatorView!
    @IBOutlet weak var idicatorFavorite: UIActivityIndicatorView!
    @IBOutlet weak var historyCollection: UICollectionView!
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
      
       historyCollection.register(UINib(nibName: "BookCollectionView", bundle: nil), forCellWithReuseIdentifier: "BookCollectionView")
        favoriteCollectionView.register(UINib(nibName: "BookCollectionView", bundle: nil), forCellWithReuseIdentifier: "BookCollectionView")
        
        historyCollection.delegate = self
        historyCollection.dataSource = self

        
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
       
        
      
    }

    override func viewWillAppear(_ animated: Bool) {
        indicatorHistory.isHidden = false
        idicatorFavorite.isHidden = false
        indicatorHistory.startAnimating()
        idicatorFavorite.startAnimating()
            booksHistory.removeAll()
            booksLike.removeAll()
        booksHistory.append(contentsOf: BookEntity.shared.getDataBookViewed())
            booksLike.append(contentsOf: BookEntity.shared.getDataBookFavorite())
        
                           DispatchQueue.main.async {
                               self.historyCollection.reloadData()
                               self.favoriteCollectionView.reloadData()
                            self.indicatorHistory.isHidden = true
                            self.idicatorFavorite.isHidden = true
                            self.indicatorHistory.stopAnimating()
                            self.idicatorFavorite.stopAnimating()
                           }
        }
           
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView{
        case  favoriteCollectionView:
            return booksLike.count
        case historyCollection: return booksHistory.count
        default:
            break
        }
        return 4
    }
    
    // =============== Image Cache===================//
    
    private func loadImage(for book: Book, into cell: BookCollectionView, at indexPath: IndexPath, books: [Book]) {
            let urlString = book.imageBook
              if let cachedImage = imageCache[urlString] {
               cell.imgBook.image = cachedImage
                  if !dataBeingRefreshed {
                      self.indicatorHistory.isHidden = true
                      self.indicatorHistory.stopAnimating()
                    self.idicatorFavorite.isHidden = true
                    self.idicatorFavorite.stopAnimating()
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
                              self.indicatorHistory.isHidden = true
                              self.indicatorHistory.stopAnimating()
                            self.idicatorFavorite.isHidden = true
                            self.idicatorFavorite.stopAnimating()
                          }
                          if book == books[indexPath.row] {
                              cell.imgBook.image = image
                          }
                      }
                  }
              }
          }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if collectionView == historyCollection{
            let cellHistoryCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionView", for: indexPath) as! BookCollectionView
            
            cellHistoryCollection.layer.cornerRadius = 10
            cellHistoryCollection.layer.masksToBounds = true
            cellHistoryCollection.lblBookTitle.text = booksHistory[indexPath.row].titleBook
            let book = booksHistory[indexPath.row]
            loadImage(for: book, into: cellHistoryCollection, at: indexPath, books: booksHistory)
            cellHistoryCollection.lblAuthor.text = booksHistory[indexPath.row].authorBook
            
            return cellHistoryCollection
        }
        else
        {
            let cellFavoriteCollection = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionView", for: indexPath) as! BookCollectionView
             cellFavoriteCollection.layer.cornerRadius = 10
                       cellFavoriteCollection.layer.masksToBounds = true
                       cellFavoriteCollection.lblBookTitle.text = booksLike[indexPath.row].titleBook
                     let book = booksLike[indexPath.row]
                    loadImage(for: book, into: cellFavoriteCollection, at: indexPath, books: booksLike)
                         cellFavoriteCollection.lblStar.isHidden = false
                       cellFavoriteCollection.lblAuthor.text = booksLike[indexPath.row].authorBook
            return cellFavoriteCollection
        }
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
        
        if collectionView == historyCollection{
            src.book = booksHistory[indexPath.row]
        }else
        {
            src.book = booksLike[indexPath.row]
        }
        
        self.present(src, animated: true , completion: nil)
    }
    
}


extension MyAudioViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: 290, height: 360)
    }
}
    

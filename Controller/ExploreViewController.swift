//
//  ExploreViewController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/17/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit
//import SVPullToRefresh.h
var stateInternet: Bool = true

var PER_PAGE = 20
class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //=================================Khai báo=============================//
    
    let currentCategory = ["All", "Children", "Comedy", "Adventure", "Fairy_tales", "Fantasy", "Fiction", "Historical_Fiction", "History","Humor", "Literature","Mystery", "Non-fiction", "Philosophy","Art","Animals","Short_stories","Romance","Poetry"]
    var listButton: [UIButton] = [UIButton]()
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnFantasy: UIButton!
    @IBOutlet weak var indicatorloadmore: UIActivityIndicatorView!
    @IBOutlet weak var btnFiction: UIButton!
    var books: [Book] = [Book]()
    var booksFavorite: [Book] = [Book]()
     var reachability: Reachability?
    let hostNames = [nil, "google.com", "google.com"]
    var hostIndex = 0
    var imageCache = [String: UIImage?]()
      var dataBeingRefreshed = false
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnFairy: UIButton!
    @IBOutlet weak var btnAdventure: UIButton!
    @IBOutlet weak var btnComdy: UIButton!
    @IBOutlet weak var btnChildren: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startHost(at: 0)
        listButton = [ btnFairy, btnComdy, btnFantasy, btnFiction, btnChildren, btnAdventure]
        btnCornerRadius()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "BookCollectionView", bundle: nil), forCellWithReuseIdentifier: "BookCollectionView")
        getDataFromServer(currentCategory[0])
        
       
    }

    
    
    
    
    // ================ Thục hiện bắt sự kiện thay đổi khi mất mạng================///
    
    
    func startHost(at index: Int) {
           stopNotifier()
           setupReachability(hostNames[index], useClosures: true)
           startNotifier()
           DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
               self.startHost(at: (index + 1) % 3)
           }
       }
    
       
    func setupReachability(_ hostName: String?, useClosures: Bool) {
           let reachability: Reachability?
           if let hostName = hostName {
               reachability = try? Reachability(hostname: hostName)
             //  hostNameLabel.text = hostName
            print(hostName)
           } else {
               reachability = try? Reachability()
              // hostNameLabel.text = "No host name"
            print("no host name")
           }
           self.reachability = reachability
           print("--- set up with host name: sss")
           
           if useClosures {
               reachability?.whenReachable = { reachability in
                   self.updateLabelColourWhenReachable(reachability)
               }
               reachability?.whenUnreachable = { reachability in
                   self.updateLabelColourWhenNotReachable(reachability)
               }
           } else {
               NotificationCenter.default.addObserver(
                   self,
                   selector: #selector(reachabilityChanged(_:)),
                   name: .reachabilityChanged,
                   object: reachability
               )
           }
       }
       
    
       func startNotifier() {
           
           do {
               try reachability?.startNotifier()
                print("--- start notifier")
           } catch {
//               networkStatus.textColor = .red
            print("Unable to start\nnotifier")
              // networkStatus.text = "Unable to start\nnotifier"
               return
           }
       }
       
       func stopNotifier() {
           print("--- stop notifier")
           reachability?.stopNotifier()
           NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
           reachability = nil
       }
       
       func updateLabelColourWhenReachable(_ reachability: Reachability) {
           print("\(reachability.description) - \(reachability.connection)")
         print("Có kết nổi internet")
        stateInternet = true
       }
       
       func updateLabelColourWhenNotReachable(_ reachability: Reachability) {
           print("\(reachability.description) - \(reachability.connection)")
        print("Không có kết nối internet")
         stateInternet = false
        
       }
       
       @objc func reachabilityChanged(_ note: Notification) {
           let reachability = note.object as! Reachability
           
           if reachability.connection != .none {
               updateLabelColourWhenReachable(reachability)
           } else {
               updateLabelColourWhenNotReachable(reachability)
           }
       }
       
       deinit {
           stopNotifier()
       }
    
    
    
    

      //====================================Bo các góc cho các nút=====================================//
     func btnCornerRadius()
         {
             for i in listButton{
                 i.layer.cornerRadius = i.frame.width / 6
                 i.layer.masksToBounds = true
                 i.layer.borderWidth = 1
                 i.layer.borderColor  = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
                 i.setTitleColor(.black, for: .normal)
             }
             btnAll.layer.cornerRadius = btnAll.frame.width / 3
             btnAll.layer.masksToBounds = true
            btnAll.layer.borderWidth = 1
             btnAll.layer.borderColor  = .init(srgbRed: 255, green: 0, blue: 0, alpha: 1)
         }
    
    
    
    // ========================Image Cache==================================//
    
    private func loadImage(for book: Book, into cell: BookCollectionView, at indexPath: IndexPath) {
         let urlString = book.imageBook
           if let cachedImage = imageCache[urlString] {
            cell.imgBook.image = cachedImage
               if !dataBeingRefreshed {
                   self.indicatorloadmore.isHidden = true
                   self.indicatorloadmore.stopAnimating()
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
                           self.indicatorloadmore.isHidden = true
                           self.indicatorloadmore.stopAnimating()
                       }
                       if book == self.books[indexPath.row] {
                           cell.imgBook.image = image
                       }
                   }
               }
           }
       }
    
    
    // ============================ Tải thêm dữ liệu ===================================//
    
    func loadMoreDataFromServer(){
        DispatchQueue.main.async {
             self.indicatorloadmore.isHidden = false
                   self.indicatorloadmore.startAnimating()
        }
       
        if self.books.count > 0 && self.books.count % PER_PAGE == 0{
            let page = books.count / PER_PAGE + 1
            BaseClient.shared.getAllBooks(category:currentCategory[0], numberPage: page).done {  [weak self] (result) in
                self?.books.append(contentsOf: result)
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                self?.indicatorloadmore.isHidden = true
                self?.indicatorloadmore.stopAnimating()
                }
                
            }.catch { [weak self] (error) in
                //self?.showError(message: error.localizedDescription)
             print("Error")
                self?.collectionView.infiniteScrollingView?.stopAnimating()
            }
        }else{
            self.collectionView.infiniteScrollingView?.stopAnimating()
        }
    }
    
    
    
    //==================================Thực hiện khi click chọn các mục==========================//
    
    @IBAction func ButtonAllClick(_ sender: Any) {
        
        if !stateInternet{
                let alertController = UIAlertController(title: "No Internet", message: "Please check your internet connection and try again ", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "0k", style: .default) { (action:UIAlertAction) in
                    print("You've pressed default");
                }
                alertController.addAction(action1)
                self.present(alertController, animated: true, completion: nil)
                
                return
            }
        
        let button = sender as! UIButton
        switch button {
        case btnAll:
            getDataFromServer(currentCategory[0])
            break
        case btnFairy:
              getDataFromServer(currentCategory[4])
            break
        case btnComdy:
              getDataFromServer(currentCategory[2])
            break
        case btnFantasy:
              getDataFromServer(currentCategory[5])
            break
        case btnChildren:
              getDataFromServer(currentCategory[1])
            break
        case btnAdventure:
              getDataFromServer(currentCategory[3])
            break
        case btnFiction:
              getDataFromServer(currentCategory[6])
            break
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
        print(indexPath.row)
     //  let index = self.collectionView.indexPath(for: cell)!.row
       if indexPath.row == self.books.count - 4 {
            DispatchQueue.main.async {
               self.collectionView.infiniteScrollingView?.startAnimating()
            }
            self.loadMoreDataFromServer()
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
              let cell = collectionView.cellForItem(at: indexPath) as! BookCollectionView
          UIView.transition(with: cell, duration: 2, options: .transitionCurlUp,
                                 animations: {
                                  cell.backgroundColor = UIColor.white
              })
        
          let src = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
          src.book = books[indexPath.row]
          self.present(src, animated: true , completion: nil)
          
      }
    
    override func viewWillAppear(_ animated: Bool) {
//           booksFavorite.removeAll()
//            booksFavorite.append(contentsOf: BookEntity.shared.getDataBookFavorite())
           collectionView.reloadData()
       }
    

    
    
    //=============================Thực hiện các hiệu ứng và load dữ liệu khi focus====================================//
    
      override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
            btnAll.layer.borderColor  = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
              if let cell = context.previouslyFocusedView as? UICollectionViewCell {
                  coordinator.addCoordinatedAnimations({ () -> Void in
                      cell.transform = CGAffineTransform.identity
                      cell.layer.borderWidth = 0
                      cell.backgroundColor = .white
                       }, completion: nil)
                }
              else if let button = context.previouslyFocusedView as? UIButton{
                 
                  coordinator.addCoordinatedAnimations({ () -> Void in
                  button.transform = CGAffineTransform.identity
                     button.layer.borderColor  = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
                  button.setTitleColor(.black, for: .normal)
                   }, completion: nil)

          }
              if let cell = context.nextFocusedView as? UICollectionViewCell {
                  coordinator.addCoordinatedAnimations({ () -> Void in
                    cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                    cell.layer.borderWidth = 1
                      cell.backgroundColor = .orange
                      

                  }, completion: nil)
              }
              else if let button = context.nextFocusedItem as? UIButton{
                  
                  coordinator.addCoordinatedAnimations({ () -> Void in

                                  button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                                   button.layer.borderColor  = .init(srgbRed: 255, green: 0, blue: 0, alpha: 1)
                                  button.setTitleColor(.red, for: .normal)

                                 }, completion: nil)
          }
      }
    
    
    
    //=====================================Lấy dữ liệu từ server=============================//
       
       func getDataFromServer(_ catag: String){
        self.indicatorloadmore.isHidden = false
        self.indicatorloadmore.startAnimating()
          let data = DispatchQueue(label: "GetData")
          data.async {
                BaseClient.shared.getAllBooks(category: catag, numberPage: 1).done { [weak self] (result) in
                                    self?.books.removeAll()
                                    self?.books.append(contentsOf: result)
                           //  let translate = CGAffineTransform(translationX: -120, y: -120)
                             //self?.collectionView.transform = translate
                            // UIView.animate(withDuration: 2, delay: 0, options: .curveEaseInOut, animations: {
                                // self!.collectionView.transform = .identity
                            // }, completion: nil)
                   DispatchQueue.main.async {
                          self?.collectionView.reloadData()
                    self?.indicatorloadmore.isHidden = true
                    self?.indicatorloadmore.stopAnimating()
                   }
         }
             
        }
       }
    
     
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionView", for: indexPath) as! BookCollectionView
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.lblBookTitle.text = books[indexPath.row].titleBook
        let book = books[indexPath.row]
        loadImage(for: book, into: cell, at: indexPath)
        cell.lblAuthor.text = books[indexPath.row].authorBook
        return cell
        
        
    }
     

}

extension ExploreViewController: UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
}


func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return true
}


func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      // let yourWidth = collectionView.bounds.width/5
       //let yourHeight = collectionView.bounds.height/2
      
          return CGSize(width: 290, height: 360)
   }

}

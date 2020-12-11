//
//  DetailViewController.swift
//  AudiBookAppTV
//
//  Created by Nguyen Van Tinh on 9/11/20.
//  Copyright © 2020 Nguyen Van Tinh. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class DetailViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var listChapter: [Chapter] = []
    enum MusicType {
           case ONLINE, LOCAL, NONE
       }
    var like: Bool = false
        var book: Book!
       var onlinePlayer : AVPlayer?
       var localPlayer : AVAudioPlayer?
    var musicType = MusicType.ONLINE
       //var data : MusicData?
    var time: Float = 0.0
    var checkPause: Bool = false
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var nv: UIView!
    @IBOutlet weak var imgBook: UIImageView!
  
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btnStar: UIButton!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPre: UIButton!
    var timer1  = Timer()
    @IBOutlet weak var tableCollection: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableCollection.delegate = self
        tableCollection.dataSource = self
        print("Đã vào did load ")
        print(book)
        tableCollection.layer.borderWidth = 0
        BookEntity.shared.insertData(book: book)
        tableCollection.register(UINib(nibName: "ChapterViewCell", bundle: nil), forCellReuseIdentifier: "ChapterViewCell")
       getChapter()
        txtDescription.isSelectable = true
        txtDescription.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        timer1 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    
    }
    
    func initPlayer(_ urlChapter: String) {
           if musicType == MusicType.LOCAL {
               guard let url = Bundle.main.url(forResource: "http://www.archive.org/download/huckleberry_mfs_librivox/huckleberry_finn_43_twain_64kb.mp3", withExtension: ".mp3") else {
                   return
               }
               do {
                   localPlayer = try AVAudioPlayer(contentsOf: url)
                   let duration = localPlayer?.duration
                   let min = Int(duration!) / 60
                   let second = Int(duration!) % 60
//                   self.lbEnd.text = "\(min):\(second)"
//                   self.sliderMusic.maximumValue = Float(duration!)
               } catch let err {
                   print(err.localizedDescription)
               }
           }
           else if musicType == MusicType.ONLINE {
            print("chay vao online")
            let url = URL(string: (urlChapter))
            print("url \(url)")
               onlinePlayer = AVPlayer(url: url!)
               guard let duration = onlinePlayer?.currentItem?.asset.duration else {
                   return
               }
               let durationBySecond = CMTimeGetSeconds(duration)
               let min = Int(durationBySecond) / 60
               let second = Int(durationBySecond) % 60
               onlinePlayer?.play()
            btnPlay.setImage(UIImage(named: "pause.png"), for: .normal)

           }
           else {
               return
           }
       }
    
    
    // ======= Thực hiện cập nhật thời gian chạy video ======//
    @objc func updateSlider() {
        
        if localPlayer == nil && onlinePlayer == nil {
            print("nill")
            return
        }
        if onlinePlayer != nil{
            print("Chay vao day1")
            let currentTimeBySecond = CMTimeGetSeconds((onlinePlayer!.currentTime()))
            time = Float(currentTimeBySecond)
        }else if !checkPause{
            nextVideo()
        }
        
    }
    
    
    
    func nextVideo()
    {
        onlinePlayer?.play()
        btnPlay.setImage(UIImage(named: "pause.png"), for: .normal)
    }
    
    
    
    // thực hiện kiểm tra dữ liệu
    override func viewWillAppear(_ animated: Bool) {
        
        if let data = BookEntity.shared.getDataFilter(id: Int64(book.id)!)
        {
            for i in data{
                
                if BookEntity.shared.isLike(book: i)
                {
                   btnStar.setImage(UIImage(named: "likeStar.png"), for: .normal)
                }else{
                    btnStar.setImage(UIImage(named: "unlikeStar.png"), for: .normal)
                }
            }
        }
        
            guard  let url = URL(string: book.imageBook) else {
                return
            }
               let data = try? Data(contentsOf: url)
               imgBook.image = UIImage(data: data!)
                    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onlinePlayer?.pause()
        timer1.invalidate()
    }
    
   
    
    @IBAction func btnCliclAllAudio(_ sender: Any) {
        let button = sender as! UIButton
        switch button {
        case btnPre:
            print("cajy bapf next nhe")
            onlinePlayer?.seek(to: CMTime(seconds: Double(time - 30), preferredTimescale: 1))
        break
        case btnStar:
            
            
            if !book.isLiked{
                btnStar.setImage(UIImage(named: "likeStar.png"), for: .normal)
               if BookEntity.shared.updateLikeOrUnLike(book: book, like: true)
               {
                print("Da sua thanh cong")
                }
                
              
            }else{
                btnStar.setImage(UIImage(named: "unlikeStar.png"), for: .normal)
                print("unlike is read")
                
                if BookEntity.shared.updateLikeOrUnLike(book: book, like: false)
                {
                    print("Da sua that bai")
                }
                
            }
        case btnNext:
            onlinePlayer?.seek(to: CMTime(seconds: Double(time + 30), preferredTimescale: 1))
            break
        case btnPlay:
            print("chay vao pay")
          if onlinePlayer != nil {
            if checkPause {
                
               btnPlay.setImage(UIImage(named: "pause.png"), for: .normal)
                  onlinePlayer?.play()
                  checkPause = false
              } else {
                
                 btnPlay.setImage(UIImage(named: "play.png"), for: .normal)
                  onlinePlayer?.pause()
                  checkPause = true
              }
          }
            
            break
        default:
                break
        }
        
    }
    
    
    
    // bookid cua no la truyen vao duong dan
    func getChapter(){
        self.indicator.isHidden = false
        self.indicator.startAnimating()
        let getChapAsyn = DispatchQueue(label: "Get Chappter")
        getChapAsyn.async {
             BaseClient.shared.getChapter(idBook: self.book!.idBook).done { [weak self] (result) in
                              self?.listChapter.removeAll()
                              print("result \n \(result)")
                                 self?.listChapter.append(contentsOf: result)
                              
                              DispatchQueue.main.async {
                                  self?.tableCollection.reloadData()
                                  self?.initPlayer((self?.listChapter[0].urlChapter)!)
                                  self?.getURLDescription(self!.listChapter[0].id)
                               self?.indicator.isHidden = true
                               self?.indicator.stopAnimating()
                              }
                   }
        }
           
       
    
    }
    
    
    // hiển thị đoạn chuỗi để đọc
    
   func  getURLDescription(_ id: String)
    {
        let k = """
 <p>Important Notice:</p>\n<p>We are sorry to inform you that the old version you are using is no longer maintained.\nAnd you are suggested to update your All Football to new version for better experience:</p>\n\n<p>- Match list updated: You can see the important events of games directly in the list;</p>\n<p>- All you want to know about the games of your favorite team during the matchday will show in the homepage, such as match preview, GIF list, chat room, match report, etc;</p>\n<p>- Team\'s page add their performance of this season, including the team\'s attack, defensive, discipline and key players;</p>\n<p>- News, videos and more according to your preferences.</p>\n\n<p>Come and check the new All Football!</p>
 """
        print(k.htmlToString)
        
        let myURLString = "http://www.aduapp.space/audiobookfiles/\(id).htm"
                                  guard let myURL = URL(string: myURLString) else {
                                  print("Error: \(myURLString) doesn't seem to be a valid URL")
                                      return
                                  }
                                      do {
                                        print(myURL)
                                          let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
                                         // print("HTML : \(myHTMLString)")
                                       txtDescription.attributedText = myHTMLString.htmlToAttributedString
                                      } catch let error {
                                          print("Error: \(error)")
                              }
                   
    }
    
    
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

                     if let button = context.previouslyFocusedView as? UIButton{
                           coordinator.addCoordinatedAnimations({ () -> Void in
                           button.transform = CGAffineTransform.identity
                            }, completion: nil)

                   }
          
               if let button = context.nextFocusedItem as? UIButton{
                           
                           coordinator.addCoordinatedAnimations({ () -> Void in
                                           button.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)

                                          }, completion: nil)
                   }
           
       }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       initPlayer(listChapter[indexPath.row].urlChapter)
        DispatchQueue.main.async {
            
            self.getURLDescription(self.listChapter[indexPath.row].id)
        }
       
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listChapter.count    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChapterViewCell", for: indexPath) as! ChapterViewCell
        cell.lblName.text = book?.titleBook
        cell.lblpart.text = listChapter[indexPath.row].id
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
    
        return cell
    }

}
class myUIView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

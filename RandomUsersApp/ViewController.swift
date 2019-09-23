//
//  ViewController.swift
//  RandomUsersApp
//
//  Created by Ana Victoria Frias on 9/22/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit
import Nuke

class ViewController: UIViewController {
//Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
//    Outlets icons
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var mailIcon: UIImageView!
    @IBOutlet weak var calendarIcon: UIImageView!
    @IBOutlet weak var mapIcon: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var lockIcon: UIImageView!
//    Outlets buttons
    @IBOutlet weak var like: UIButton!
    var md5ValueUsers = [String]()
//    value user
    var user: user!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = imageView.frame.height / 2
        //Assign Image with NUKE
        Nuke.loadImage(with: URL(string: user.avatar)!, into: imageView)
        // Do any additional setup after loading the view.
//        Transform color of icons
        
        userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
        userIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
        userIcon.tag = 10000
        
        mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
        mailIcon.tintColor = UIColor.lightGray
        mailIcon.tag = 10001
        
        calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
        calendarIcon.tintColor = UIColor.lightGray
        calendarIcon.tag = 10002
        
        mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
        mapIcon.tintColor = UIColor.lightGray
        mapIcon.tag = 10003
        
        phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
        phoneIcon.tintColor = UIColor.lightGray
        phoneIcon.tag = 10004
        
        lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
        lockIcon.tintColor = UIColor.lightGray
        lockIcon.tag = 10005
        
        like.imageView?.image = like.imageView?.image?.withRenderingMode(.alwaysTemplate)
        like.tintColor = UIColor.lightGray
        
        if let id_user = UserDefaults.standard.object(forKey: "id") as? [String] {
            if id_user.contains(user.id) {
                like.isSelected = true
            }else{
                like.isSelected = false
            }
        }else{
            like.isSelected = false
        }
    }
    func addColors(tag: Int) {
        for i in 0..<self.view.subviews.count {
            guard let imageView = self.view.viewWithTag(10000 + i) as? UIImageView else {
                return
            }
            if 10000 + i == tag {
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
            }else{
                imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func likeBtn(_ sender: Any) {
        if like.isSelected {
            like.isSelected = false
            if let md5Users = UserDefaults.standard.object(forKey: "id") as? [String] {
                md5ValueUsers = md5Users
                if md5Users.contains(user!.id) {
                    md5ValueUsers.remove(at: md5Users.index(of: user!.id)!)
                }
                UserDefaults.standard.set(md5ValueUsers, forKey: "id")
            }
        }else{
            like.isSelected = true
            if let md5Users = UserDefaults.standard.object(forKey: "id") as? [String] {
                md5ValueUsers = md5Users
                if !md5Users.contains(user!.id) {
                    md5ValueUsers.append(user!.id)
                }
                UserDefaults.standard.set(md5ValueUsers, forKey: "id")
            }else{
                md5ValueUsers.append(user!.id)
                UserDefaults.standard.set(md5ValueUsers, forKey: "id")
            }
        }
        
    }
    
    @IBAction func tapUser(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
    
    @IBAction func tapMail(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
    }
    @IBAction func tapBirthday(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 2, section: 0), at: .right, animated: true)
    }
    @IBAction func tapAddress(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 3, section: 0), at: .right, animated: true)
    }
    @IBAction func tapPhone(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 4, section: 0), at: .right, animated: true)
    }
    
    @IBAction func tapPassword(_ sender: Any) {
        collectionView.scrollToItem(at: IndexPath(item: 5, section: 0), at: .right, animated: true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userInfo", for: indexPath) as! UserInfoCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Hi, My name is"
            cell.subtitleLabel.text = user.name
        case 1:
            cell.titleLabel.text = "My email address is"
            cell.subtitleLabel.text = user.email_address
        case 2:
            cell.titleLabel.text = "My birthday is"
//            Convert to date
            let birthdayString = user.birthday
            let formatterToDate = DateFormatter()
            formatterToDate.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            formatterToDate.locale = Locale(identifier: "en_US")
            let dateConverted = formatterToDate.date(from: birthdayString)
//            convert to string
            let formatterToString = DateFormatter()
            formatterToString.dateFormat = "MM/dd/yyy"
            formatterToString.locale = Locale(identifier: "en_US")
            let stringConverted = formatterToString.string(from: dateConverted!)
            
            cell.subtitleLabel.text = stringConverted
        case 3:
            cell.titleLabel.text = "My address is"
            cell.subtitleLabel.text = user.address
        case 4:
            cell.titleLabel.text = "My phone number is"
            cell.subtitleLabel.text = user.phone_number
        default:
            cell.titleLabel.text = "My password is"
            cell.subtitleLabel.text = user.password
        }
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x < self.view.frame.width {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)

            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.lightGray

            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.lightGray

            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.lightGray

            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.lightGray

            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.lightGray
            
        }else if scrollView.contentOffset.x < (self.view.frame.width * 2) {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.lightGray

            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)

            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.lightGray

            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.lightGray

            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.lightGray

            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.lightGray
        }else if scrollView.contentOffset.x < (self.view.frame.width * 3) {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.lightGray
            
            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.lightGray
            
            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
            
            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.lightGray
            
            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.lightGray
            
            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.lightGray
        }else if scrollView.contentOffset.x < (self.view.frame.width * 4) {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.lightGray
            
            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.lightGray
            
            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.lightGray
            
            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
            
            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.lightGray
            
            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.lightGray
        }else if scrollView.contentOffset.x < (self.view.frame.width * 5) {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.lightGray
            
            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.lightGray
            
            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.lightGray
            
            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.lightGray
            
            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
            
            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.lightGray
        }else {
            userIcon.image = userIcon.image?.withRenderingMode(.alwaysTemplate)
            userIcon.tintColor = UIColor.lightGray
            
            mailIcon.image = mailIcon.image?.withRenderingMode(.alwaysTemplate)
            mailIcon.tintColor = UIColor.lightGray
            
            calendarIcon.image = calendarIcon.image?.withRenderingMode(.alwaysTemplate)
            calendarIcon.tintColor = UIColor.lightGray
            
            mapIcon.image = mapIcon.image?.withRenderingMode(.alwaysTemplate)
            mapIcon.tintColor = UIColor.lightGray
            
            phoneIcon.image = phoneIcon.image?.withRenderingMode(.alwaysTemplate)
            phoneIcon.tintColor = UIColor.lightGray
            
            lockIcon.image = lockIcon.image?.withRenderingMode(.alwaysTemplate)
            lockIcon.tintColor = UIColor.init(red: 110/255, green: 193/255, blue: 44/255, alpha: 1)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: self.view.frame.width, height: 156)
    }
}

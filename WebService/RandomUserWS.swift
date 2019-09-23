//
//  RandomUserWS.swift
//  RandomUsersApp
//
//  Created by Ana Victoria Frias on 9/22/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit
import Alamofire
//create user object as struct
struct user {
    var id: String
    var name: String
    var email_address: String
    var birthday: String
    var address: String
    var phone_number: String
    var password: String
    var avatar: String
    var thumbnail: String
}
//create delegate to share info with vc
protocol userDelegate: class {
    func didSuccessGetRandomUser(user: [user])
    func didFailGetRandomUser(error: String)
}
//class WS
class RandomUserWS: NSObject {
    var delegate: userDelegate!
    func viewRandomUsers() {
        let request = Constants.baseURL
        Alamofire.request(request, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) in
                switch response.result{
                case .success:
                    debugPrint(response)
                    switch Int((response.response?.statusCode)!){
                    case 200:
//                        Success!!
                        let usersInfo = self.makeRandomUsers(info: response.value as! NSDictionary)
                        self.delegate.didSuccessGetRandomUser(user: usersInfo)
                        break
                    case 400:
//                        Error 400
                        self.delegate.didFailGetRandomUser(error: "There's a bad request!")
                        break
                    case 404:
//                        Error Not Found
                        self.delegate.didFailGetRandomUser(error: "Item not found")
                        break
                    case 500:
//                        Server error
                        self.delegate.didFailGetRandomUser(error: "Now we have a server error")
                        break
                    default:
//                        Catching other errors
                        break
                    }
                    break
                case .failure( _):
                    self.delegate.didFailGetRandomUser(error: "Check your internet connection")
                    break
                }
            })
        
    }
}

extension NSObject {
    func makeRandomUsers(info: NSDictionary) -> [user] {
        let results = info.value(forKey: "results") as! NSArray
        var id = String()
        var first_name = String()
        var last_name = String()
        var email = String()
        var birthday = String()
        var address = String()
        var phone = String()
        var password = String()
        var avatar = String()
        var thumbnail = String()
        var usersInfo = [user]()
        for result in results {
            print(result as! NSDictionary)
            guard let id_info = ((result as! NSDictionary).value(forKey: "login") as! NSDictionary).value(forKey: "md5") as? String, let firstname_info = ((result as! NSDictionary).value(forKey: "name") as! NSDictionary).value(forKey: "first") as? String, let lastname_info = ((result as! NSDictionary).value(forKey: "name") as! NSDictionary).value(forKey: "last") as? String, let email_info = ((result as! NSDictionary).value(forKey: "email") as? String), let birthday_info = ((result as! NSDictionary).value(forKey: "dob") as! NSDictionary).value(forKey: "date") as? String, let address_info = ((result as! NSDictionary).value(forKey: "location") as! NSDictionary).value(forKey: "street") as? String, let phone_info = ((result as! NSDictionary).value(forKey: "phone") as? String), let password_info = ((result as! NSDictionary).value(forKey: "login") as! NSDictionary).value(forKey: "password") as? String, let avatar_info = ((result as! NSDictionary).value(forKey: "picture") as! NSDictionary).value(forKey: "large") as? String, let thumbnail_info = ((result as! NSDictionary).value(forKey: "picture") as! NSDictionary).value(forKey: "thumbnail") as? String else {
                let userInfo = user.init(id: "0", name: "", email_address: "", birthday: "", address: "", phone_number: "", password: "", avatar: "", thumbnail: "")
                usersInfo.append(userInfo)
                return usersInfo
            }
            id = id_info
            first_name = firstname_info
            last_name = lastname_info
            email = email_info
            birthday = birthday_info
            address = address_info
            phone = phone_info
            password = password_info
            avatar = avatar_info
            thumbnail = thumbnail_info
            let userInfo = user.init(id: id, name: first_name + " " + last_name, email_address: email, birthday: birthday, address: address, phone_number: phone, password: password, avatar: avatar, thumbnail: thumbnail)
            usersInfo.append(userInfo)
        }
        return usersInfo
    }
}

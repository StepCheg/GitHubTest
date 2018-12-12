//
//  NetworkManager.swift
//  GitTest
//
//  Created by Stepan Chegrenev on 08/12/2018.
//  Copyright © 2018 Stepan Chegrenev. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()

    
    private var url: String = "https://api.github.com/"
    
    private var headers: HTTPHeaders = [:]
    
    func authFunc(
        userName: String,
        password: String,
        success: @escaping () -> Void,
        failure: @escaping (_ message: (statusCode: Int, description: String)) -> Void) {
        
        if let authorizationHeader = Request.authorizationHeader(user: userName, password: password) {
            headers[authorizationHeader.key] = authorizationHeader.value
            
            Alamofire.request(url + "user", method: .get, headers: headers).responseJSON { (response) in
                
                
                guard let value = response.value else {
                    return
                }
                
                let json = JSON(value)
                
                if response.response!.statusCode == 200
                {
                    
                    UserDefaults.standard.set(userName, forKey: "username")
                    UserDefaults.standard.set(password, forKey: "password")
            
                    success()
                }
                else
                {
                    if let string = json["message"].string {
                        failure((statusCode: response.response!.statusCode, description: string))
                        print(string)
                    }
                }
            }
        }
    }
    
    func getListOfRepositories(
        userName: String,
        success: @escaping (_ value: [String]) -> Void,
        failure: @escaping (_ message: (statusCode: Int, description: String)) -> Void) {
        
        Alamofire.request(url + "users/\(userName)/repos", method: .get).responseJSON { response in
            
            guard let value = response.value else {
                return
            }
            
            let json = JSON(value)
            
//            print(json)
            
            if response.response!.statusCode == 200
            {
                var array: [String] = []
                
                for i in 0..<json.count {
                    array.append(json[i]["name"].string!)
                }
                
                success(array)
            }
            else
            {
                if let string = json["message"].string {
                    failure((statusCode: response.response!.statusCode, description: string))
                    print(string)
                }
            }
        }
    }
    
    
    func getInfoAboutRepository(
        userName: String,
        repository: String,
        success: @escaping (_ value: [String : Any]) -> Void,
        failure: @escaping (_ message: (statusCode: Int, description: String)) -> Void) {
        
        Alamofire.request(url + "repos/\(userName)/\(repository)", method: .get).responseJSON { response in
            
            guard let value = response.value else {
                return
            }
            
            let json = JSON(value)
            
            if response.response!.statusCode == 200
            {
                var dictionary: [String: Any] = [:]
                
                if let name = json["name"].string
                {
                    dictionary["name"] = name
                }
                if let description = json["description"].string
                {
                    dictionary["description"] = description
                }
                if let login = json["owner"]["login"].string
                {
                    dictionary["login"] = login
                }
                if let avatarURL = json["owner"]["avatar_url"].string
                {
                    dictionary["avatar_url"] = avatarURL
                }
                if let forksCount = json["forks_count"].int
                {
                    dictionary["forks_count"] = forksCount
                }
                if let watchersCount = json["watchers_count"].int
                {
                    dictionary["watchers_count"] = watchersCount
                }
                
                success(dictionary)
            }
            else
            {
                if let string = json["message"].string {
                    failure((statusCode: response.response!.statusCode, description: string))
                    print(string)
                }
            }
        }
    }
    
    func getListOfCommits(
        userName: String,
        repositoryName: String,
        success: @escaping (_ value: [Any]) -> Void,
        failure: @escaping (_ message: (statusCode: Int, description: String)) -> Void) {
        
        Alamofire.request(url + "repos/\(userName)/\(repositoryName)/commits", method: .get).responseJSON { response in
            
            guard let value = response.value else {
                return
            }
            
            let json = JSON(value)
            
            if response.response!.statusCode == 200
            {
                var array: [Any] = []
                
                for i in 0..<json.count {
                    
                    var dictionary: [String : Any] = [:]
                    dictionary["author"] = json[i]["commit"]["author"]["name"].string
                    dictionary["date"] = json[i]["commit"]["committer"]["date"].string
                    dictionary["sha"] = json[i]["sha"].string
                    dictionary["message"] = json[i]["commit"]["message"].string
                    array.append(dictionary)
                }
                
                success(array)
            }
            else
            {
                if let string = json["message"].string {
                    failure((statusCode: response.response!.statusCode, description: string))
                    print(string)
                }
            }
        }
    }
    
    
    func getAvatar(
        avatarURL: String,
        success: @escaping (_ value: UIImage) -> Void) {
        
        Alamofire.request(avatarURL).responseImage { response in
            
            if let image = response.result.value {
                
                success(image)
                
                print("image downloaded: \(image)")
            }
        }
    }
}

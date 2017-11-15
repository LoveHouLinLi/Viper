//
//  Entity.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/11.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import Foundation
import Runes
import Curry
import Moya
import Argo

enum VIPERs:String{
    case one
    case two
}

extension VIPERs{
    var identifier:String{
        return self.rawValue
    }
}

enum OneRequest:Request{
    case jump
    case login(userName:String,password:String)
}
//
enum OneResponse:Response {
    case jumpResponse(viper:VIPERs)
    case loginResponse(json:Any?)
}

//
struct OneViewModel:ViewModel {
    let alertMessage:String
    init(alertMessage:String) {
        self.alertMessage = alertMessage
    }
}

// MARKS: - VIPERs
enum TwoRequest:Request{
    case back
}

enum TwoResponse:Response {
    case back
}

enum UserGender:String {
    case male = "男"
    case female = "女"
}

struct User{
    let name:String
    let age:Int
    let gender:UserGender
    let token:String
}

extension User:CustomStringConvertible{
    var description:String{
        return "姓名:\(self.name),年龄: \(self.age), 性别: \(self.gender.rawValue), 令牌: \(self.token)"
    }
}

//  !!!
extension User: Argo.Decodable {
    //
    static func decode(_ json: JSON) -> Decoded<User> {
        
        let genderMapper: (Int) -> UserGender = { genderType in
            if genderType == 1 {
                return .male
            } else {
                return .female
            }
        }
        
        return curry(self.init)
            <^> json <| "name"
            <*> json <| "age"
            <*> (genderMapper <^> json <| "gender")
            <*> json <| "token"
    }
}

//  MARK: - Network Response
enum NetworkResponse {
    case faild(message: String)
    case success(user: User)
}

extension NetworkResponse:Argo.Decodable {
    
    init(code: Int, message: String, userInfo: User?) {
        if let user = userInfo, code == 200 {
            self = .success(user: user)
        } else {
            self = .faild(message: message)
        }
    }
    
    static func decode(_ json: JSON) -> Decoded<NetworkResponse> {
        return curry(self.init)
            <^> json <| "code"
            <*> json <| "message"
            <*> json <|? "user_info"
    }
}

//
enum NetworkRequest {
    case login(userName:String,password:String)
}

extension NetworkRequest:TargetType{
    
    // MARK: -  ！！！ 这是返回默认的编码格式  .default  老工程里没有加 笔者 加上这个然后编译正确
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    //
    var baseURL: URL {
        return URL(string: "http://127.0.0.1")!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/projects/tanviper.php"
        }
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .login(userName, password):
            return ["user_name": userName, "password": password]
        }
    }
    
    var sampleData: Data {
        return "{\"code\": \"300\", \"message\": \"不存在此用户\"}".data(using: .utf8)!
    }
    
    var task: Task {
        return .request
    }
        
}

// MARK: BinderHelper
struct BinderHelper {
    static func initBinder(){
        Binder.addUnity(unity: [OneView.self,OneInteractor.self,OnePresenter.self], identifier: VIPERs.one.identifier)
        Binder.addUnity(unity: [TwoView.self,TwoInteractor.self,TwoPresenter.self], identifier: VIPERs.two.identifier)
    }
}















//
//  OneInteractor.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/11.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit
import Moya

class OneInteractor: Interactor {
    
    let provider:MoyaProvider<NetworkRequest> = MoyaProvider<NetworkRequest>()
    
    override func refresh(request: Request) {
        let request = request as! OneRequest
        switch request {
        case .jump:
            self.presenter.present(response: OneResponse.jumpResponse(viper: VIPERs.two))
        // MARK: !!! 注意  这里 let 是很关键的 不然 会报错 无法找到 userName 和 password
        case let .login(userName, password):
            self.provider.request(.login(userName: userName, password: password), completion: { result in
                var json: Any? = nil
                switch result {
                case .failure: ()
                case let .success(response):
                    json = try? response.mapJSON()
                    print("login request success \(String(describing: json))")
                }
                self.presenter.present(response: OneResponse.loginResponse(json: json))
            })
        }
    }
}








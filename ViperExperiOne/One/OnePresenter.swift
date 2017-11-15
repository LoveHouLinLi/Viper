//
//  OnePresenter.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/11.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit
import Argo

class OnePresenter: Presenter {
    override func present(response: Response) {
        let response = response as! OneResponse
        switch response {
        case let .jumpResponse(viper):
            self.router?.route(type: .modal(identifier: viper.identifier), userInfo: "From one To Two | One --> Two")
        case let.loginResponse(json):
            var alertMessage = ""
            if let json = json{
                let networkResponse:NetworkResponse = decode(json)!
                switch networkResponse{
                case let .faild(message):
                    alertMessage = "登录失败,\(message)"
                case let .success(user):
                    alertMessage = "登录成功,\(user)"
                }
            } else {
                alertMessage = "网络请求或者数据解析错误"
            }
            self.view?.display(viewModel: OneViewModel(alertMessage: alertMessage))
        }
    }
}













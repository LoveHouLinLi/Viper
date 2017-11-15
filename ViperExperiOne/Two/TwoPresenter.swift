//
//  TwoPresenter.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit

class TwoPresenter: Presenter {
    override func present(response: Response) {
        switch response as! TwoResponse {
        case .back:
            self.router?.route(type: .back, userInfo: nil)
        }
    }
}

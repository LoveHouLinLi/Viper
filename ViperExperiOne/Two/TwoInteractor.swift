//
//  TwoInteractor.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit

class TwoInteractor: Interactor {
    override func refresh(request: Request) {
        self.presenter.present(response: TwoResponse.back)
    }
}

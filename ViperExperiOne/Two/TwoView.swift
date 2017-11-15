//
//  TwoView.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/13.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import UIKit

class TwoView: View {
    
    var  showMessage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.view.addSubview(self.showView)
//        self.showView.center = self.view.center
        self.showView.frame =  CGRect(x: 0, y: 0, width: 320, height: 100)
        self.showView.center = self.view.center
        self.showView.text = self.showMessage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK :  重写 View 类的 方法
    override func show(router: Router, userInfo: Any?) {
        self.showMessage = userInfo as? String
    }
    
    override func display(viewModel: ViewModel) {
        
    }
    
    // MARK: -  白色的 状态栏
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: -  监听 所有的点击事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.interactor.refresh(request: TwoRequest.back)
    }
    
    // MARK: - Lazy Load
    private lazy var showView:UILabel = {
        // 白板编程 俗称
        $0.textColor = UIColor.white
        $0.font = UIFont.systemFont(ofSize: 23)
        $0.textAlignment = .center
        return $0
    }(UILabel())

}






















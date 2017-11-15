//
//  OneView.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/11.
//  Copyright © 2017年 DeLongYang. All rights reserved.
/*
    本来是想使用 snap 来做约束的但是因为 没更新到swift4 所以
    暂时使用 frame 的方式 适配就暂时不做了
 */

import UIKit

class OneView: View {

    private var buttonListener:OneViewButtonListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonListener = OneViewButtonListener(jump: {
            self.interactor.refresh(request: OneRequest.jump)
        }, login: {
            self.interactor.refresh(request: OneRequest.login(userName: self.userNameInput.text!, password: self.passwordInput.text!))
            self.loginButton.isEnabled = false
        })
        
        //
        self.setUpUI()
    }
    

    //
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func show(router: Router, userInfo: Any?) {
        
    }
    
    // MARK: ---- 显示 网络数据错误提示
    override func display(viewModel: ViewModel) {
        //
        self.loginButton.isEnabled = true
        let alertMessage = (viewModel as! OneViewModel).alertMessage
        self.alertController.message = alertMessage
        self.present(alertController, animated: true, completion: nil)
    }
    
    //
    func setUpUI()  {
        
        self.view.addSubview(self.jumpButton)
        self.view.addSubview(self.loginButton)
        self.view.addSubview(self.userNameInput)
        self.view.addSubview(self.passwordInput)
        
        let viewHeight:Int = 45
        let viewMargin:Int = 20
        let viewWidth:Int = 200
        //
        let userNameRect:CGRect = CGRect(x: 20, y: 60, width:viewWidth , height: viewHeight)
        let passwordRect:CGRect = CGRect(x: 20, y: 60+viewMargin+viewHeight, width: viewWidth, height: viewHeight)
        let jumpButtonRect:CGRect = CGRect(x: 20, y: 60+2*viewMargin+2*viewHeight, width: viewWidth, height: viewHeight)
        let loginButtonRect:CGRect = CGRect(x: 20, y: 60+3*viewMargin+3*viewHeight, width: viewWidth, height: viewHeight)
        self.userNameInput.frame = userNameRect
        self.passwordInput.frame = passwordRect
        self.jumpButton.frame = jumpButtonRect
        self.loginButton.frame = loginButtonRect
        
    }
    
    private func initButton(_ button:UIButton,title:String,onClick:Selector) -> UIButton
    {
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor.orange
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.addTarget(self.buttonListener, action: onClick, for: .touchUpInside)
        return button;
    }
    
    private func initTextField(_ textField: UITextField, placeHolder: String) -> UITextField {
        textField.backgroundColor = UIColor.green
        textField.textColor = UIColor.darkGray
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.placeholder = placeHolder
        return textField
    }
    
    // MARK: -  Lazy Load
    private  lazy var userNameInput:UITextField = {   // 注意这个有意思的写法 $0 这是 swift 不好的地方
        return self.initTextField($0, placeHolder: "userName")
    }(UITextField())
    
    private lazy var passwordInput:UITextField = {
        return self.initTextField($0, placeHolder: "password")
    }(UITextField())
    
    private lazy var alertController:UIAlertController = {
        let action = UIAlertAction(title: "确认", style: .default, handler: nil)
        $0.addAction(action)
        return $0
    }(UIAlertController(title: "Login", message: "what you want from me", preferredStyle: .alert))
    
    private lazy var jumpButton:UIButton = {
        return self.initButton($0, title: "跳转", onClick: #selector(OneViewButtonListener.onJumpButtonClick))
    }(UIButton())
    
    private lazy var loginButton: UIButton = {
        return self.initButton($0, title: "登录", onClick: #selector(OneViewButtonListener.onLoginButtonClick))
    }(UIButton())
    
    // MARK: - Event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

// MARK: 点击跳转的 闭包
//  use innder private class to use this is intersting
fileprivate class OneViewButtonListener{
    
    //  !!!  @Objc  别放在block 前面 不然会出现无法点击的情况
    let jumpButtonClickCallback:()->();
    let loginButtonClickCallback:()->()
    
    init(jump:@escaping ()->(),login:@escaping ()->()) {
        self.jumpButtonClickCallback = jump
        self.loginButtonClickCallback = login
    }
    
    //
    @objc  func onJumpButtonClick(){
        self.jumpButtonClickCallback()
    }
    
    @objc func onLoginButtonClick(){
        self.loginButtonClickCallback()
    }
}







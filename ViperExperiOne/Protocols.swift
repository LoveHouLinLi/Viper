//
//  Protocols.swift
//  ViperExperiOne
//
//  Created by 杨德龙 on 2017/11/9.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

import Foundation
import UIKit

/// MARK: -  Protocol
protocol Request {
    
}

protocol Response  {
    
}

protocol ViewModel {
    
}

protocol ViewToInteractorPipline {
    func refresh(request:Request) ;
}

protocol InteratorToPresenterPipline {
    func present(response:Response)
}

protocol PresenterToViewPipline {
    func display(viewModel:ViewModel)
}

// MARK: - RouterType
enum RouterType{
    case root(identifier:String)
    case push(identifier:String)
    case modal(identifier:String)
    case back
}

extension RouterType{
    var identifier:String?{
        switch self {
        case let .root(identifier) :
            return identifier
        case let .push(identifier) :
            return identifier
        case let .modal(identifier):
            return identifier
        default:
            return nil
        }
    }
    
    var view:View?{
        guard let identifier = self.identifier else {
            return nil;
        }
        return Binder.obtainView(identifier: identifier)
    }
}

// MARK:  Binder
class  Binder{
    static var unitySet:[String:Unity] = [:]
    static func addUnity( unity:Unity , identifier:String){
        self.unitySet[identifier] = unity
    }
    
    static func obtainView (identifier:String) ->View?{
        guard let  unity = self.unitySet[identifier] else {
            return nil
        }
        let presenter = unity.presenterType.init()
        let interactor = unity.interactorType.init(presenter:presenter)
        let view = unity.viewType.init(interactor:interactor)
        presenter.view = view
        return view
        
    }
}


// MARK:  Unity
struct Unity {
    let viewType:View.Type
    let interactorType:Interactor.Type
    let presenterType:Presenter.Type
}

extension Unity:ExpressibleByArrayLiteral{
    
    typealias ArrayLiteralElement = AnyClass
    //
    init(arrayLiteral elements: Unity.ArrayLiteralElement...) {
        assert(elements.count == 3)
        guard let viewType = elements[0] as? View.Type else { assert(false) }
        guard let interactorType = elements[1] as? Interactor.Type else { assert(false) }
        guard let presenterType = elements[2] as? Presenter.Type else { assert(false) }
        self.viewType = viewType
        self.interactorType = interactorType
        self.presenterType = presenterType
    }
}

// MARK:  Interactor
class Interactor: ViewToInteractorPipline {
    
    final let presenter:Presenter
    
    required init(presenter:Presenter) {
        self.presenter = presenter
    }
    
    func refresh(request: Request) {
        fatalError("refresh(request:)")
    }
}

// MARK: - Abstact Class
class Presenter: InteratorToPresenterPipline {
    
    private final weak var _view:View?{  // !!weak!!
        didSet{
           self._router = Router(presenter:self)
        }
    }
    
    private final var _router:Router?
    //
    final var view:View?{  // why here not use weak
        set{
            //  不允许 设置 为 nil
            assert(self._view == nil)
            self._view = newValue
        }
        //
        get{
            return self._view;
        }
    }
    
    final var router:Router?{
        get{
            return self._router
        }
    }
    
    required init() {
        
    }
    
    func present(response: Response) {
        fatalError("response(Response:) is an abstract function ")
    }
}


class Router {  // 类似 路由器
    let presenter:Presenter?
    
    // 表示这个方法必须要去实现
    required init(presenter:Presenter?) {
        self.presenter = presenter
    }
    //  路由器 跳转
    func route(type:RouterType,userInfo:Any?)  {
        
        let view = type.view
        view?.show(router: self, userInfo: userInfo)
        
        switch type {
        case .root:
            UIApplication.shared.keyWindow?.rootViewController = view
        case .push:
            if let view = view{
                self.presenter?.view?.navigationController?.pushViewController(view, animated: true)
            }
        case .modal:
            if let view = view{
                self.presenter?.view?.present(view, animated: true, completion: nil)
            }
        case .back:
            guard let view = presenter?.view else {return}
            if view.presentationController != nil{
                view.dismiss(animated: true, completion: nil)
            } else{
                view.navigationController?.popViewController(animated: true)
            }
        }
    }
}

class View: ViewController,PresenterToViewPipline {
    //
    final let interactor:Interactor
    required init(interactor:Interactor){
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }
    
    //
    func show(router:Router,userInfo:Any?)  {
        fatalError("show(route:userInfo:) is an abstract function")
    }
    
    //
    func display(viewModel: ViewModel) {
        fatalError("display(viewModel:) is an abstract function")
    }
    
}







//
//  TMPJPopupService.swift
//  swifttemplate
//
//  Created by supertext on 2017/11/8.
//  Copyright © 2017年 icegent. All rights reserved.
//

import Airmey

let popup = TMPJPopupService()

final class TMPJPopupService {
    enum RemindType {
        case succeed(String)
        case failure(String)
        case error(Error)
    }
    
    fileprivate init(){}
    private var wating:(UIViewController & AMControllerWaitable)?
    private weak var current:UIViewController?
    func alert(error:Error){
        switch error {
        case let err as TMPJAlertable:
            self.alert(title:err.title,message: err.message)
        default:
            self.alert(message: "网络错误")
        }
    }
    func alert(title:String?="提示",message:String?,ensure:String = "确定",cancel:String?=nil,dismissIndex:((Int)->Void)?=nil){
        guard self.current == nil else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.current = alert
        alert.addAction(UIAlertAction(title: ensure, style: .default, handler: { (action) in
            dismissIndex?(0)
        }))
        if let cancel = cancel{
            alert.addAction(UIAlertAction(title: cancel, style: .default, handler: { (action) in
                dismissIndex?(1)
            }))
        }
        
        UIApplication.shared.lastPresentedController?.present(alert, animated: true, completion: nil)
    }
    func waiting(message:String,appeared:(()->Void)?=nil,canceled:(()->Void)? = nil) {
        self.waiting(AMWaitingController(message), appeared: appeared, canceled: canceled)
    }
    func waiting<Controller:AMControllerWaitable>(_ controller:Controller,appeared:(()->Void)?=nil,canceled:(()->Void)? = nil){
        guard self.current == nil else {
            return
        }
        controller.transitioningDelegate = controller.assistor
        controller.modalPresentationStyle = .custom
        controller.assistor.appearedBlock = appeared
        controller.assistor.dismissBlock = canceled
        self.wating = controller
        self.current = controller
        UIApplication.shared.lastPresentedController?.present(controller, animated: true, completion: nil)
    }
    func hideWaiting(dismissed:(()->Void)?=nil) {
        guard self.wating != nil else {
            return
        }
        self.wating!.dismiss(animated: true, completion: {
            self.wating = nil
            self.current = nil
            dismissed?()
        })
    }
    func remind(_ type:RemindType,dismissed:(()->Void)?=nil) {
        guard self.current == nil else {
            return
        }
        var message:String?
        switch type {
        case .succeed(let info):
            message = info
        case .failure(let info):
            message = info
        case .error(let err as TMPJAlertable):
            message = err.message
        default:
            message = "未知错误"
        }
        let remind = AMRemindController(message)
        self.current = remind
        remind.assistor.dismissBlock = dismissed
        UIApplication.shared.lastPresentedController?.present(remind, animated: true, completion: nil)
    }
    func action(title:String?=nil, items:[AMNameConvertible],dismissIndex:((AMNameConvertible?,Int?)->Void)?){
        guard self.current == nil else {
            return
        }
        guard items.count > 0 else {
            return
        }
        let action = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        for item in items.enumerated() {
            action.addAction(UIAlertAction(title: item.element.name, style: .default, handler: { (action) in
                dismissIndex?(item.element,item.offset)
            }))
        }
        action.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            dismissIndex?(nil,nil)
        }))
        UIApplication.shared.lastPresentedController?.present(action, animated: true, completion: nil)
    }
}

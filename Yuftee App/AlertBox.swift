//
//  Alert.swift
//  Yuftee
//
//  Created by AppsCreationTech on 22/02/2015.
//  Copyright (c) 2015 Yuftee. All rights reserved.
//

// Handles both iOS7 and iOS8 Alert Styles

enum AlertStyle {
    case Default
    case Cancel
    case Destructive
}

class AlertBox: NSObject {

    var delegate: UIViewController?
    var alert: AnyObject?
    var iOS8: Bool
    
    private func alertStyleToSwift (style: AlertStyle) -> UIAlertActionStyle {
        switch style {
        case .Default :
            return UIAlertActionStyle.Default
        case .Cancel :
            return UIAlertActionStyle.Cancel
        case .Destructive :
            return UIAlertActionStyle.Destructive
        default :
            return UIAlertActionStyle.Default
        }
    }
    
    var buttonCallbacks: [Int:() -> ()] = [:]
  
    init (delegate: UIViewController, title: String, message: String?) {
        iOS8 = (objc_getClass("UIAlertController") != nil)
        super.init()
        self.delegate = delegate
        if iOS8 {
            alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        } else {
            alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: nil)
            (alert! as UIAlertView).delegate = self
            (alert! as UIAlertView).alertViewStyle = .Default
        }
    }
    
    func addButton(#title: String, style: AlertStyle, handler: (() -> ())?) {
        if iOS8 {
            (alert!as UIAlertController).addAction(UIAlertAction(title: title, style: alertStyleToSwift(style)) { alertAction in
                if handler != nil { handler!() }
            })
        } else {
            let buttonIndex = (alert! as UIAlertView).addButtonWithTitle(title)
            if handler != nil { buttonCallbacks[buttonIndex] = handler! }
        }
    }
    
    func show() {
        if iOS8 {
            delegate!.presentViewController(alert!as UIAlertController, animated: true, completion: nil)
        } else {
            (alert! as UIAlertView).show()
        }
    }

}

extension AlertBox: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        if let callback = buttonCallbacks[buttonIndex] {
            callback()
        }
    }
}

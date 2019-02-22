//
//  YLActivityIndicatorViewable.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/1.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

/**
 *  UIViewController conforms this protocol to be able to display YLActivityIndicatorView as UI blocker.
 *
 *  This extends abilities of UIViewController to display and remove UI blocker.
 */
public protocol YLActivityIndicatorViewable {}

public extension YLActivityIndicatorViewable where Self: UIViewController {
    
    /**
     Display UI blocker.
     
     Appropriate YLActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter size:                 size of activity indicator view.
     - parameter message:              message displayed under activity indicator view.
     - parameter messageFont:          font of message displayed under activity indicator view.
     - parameter type:                 animation type.
     - parameter color:                color of activity indicator view.
     - parameter padding:              padding of activity indicator view.
     - parameter displayTimeThreshold: display time threshold to actually display UI blocker.
     - parameter minimumDisplayTime:   minimum display time of UI blocker.
     */
    public func startAnimating(
        _ size: CGSize? = nil,
        message: String? = nil,
        messageFont: UIFont? = nil,
        type: YLActivityIndicatorType? = nil,
        color: UIColor? = nil,
        padding: CGFloat? = nil,
        displayTimeThreshold: Int? = nil,
        minimumDisplayTime: Int? = nil,
        backgroundColor: UIColor? = nil,
        textColor: UIColor? = nil) {
        let activityData = ActivityData(size: size,
                                        message: message,
                                        messageFont: messageFont,
                                        type: type,
                                        color: color,
                                        padding: padding,
                                        displayTimeThreshold: displayTimeThreshold,
                                        minimumDisplayTime: minimumDisplayTime,
                                        backgroundColor: backgroundColor,
                                        textColor: textColor)
        
        YLActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    }
    
    /**
     Remove UI blocker.
     */
    public func stopAnimating() {
        YLActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
}

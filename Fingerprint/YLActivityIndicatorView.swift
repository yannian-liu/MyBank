//
//  YNActivityIndicatorView.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/5/1.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit
public enum YLActivityIndicatorType: Int {
    case blank
    case ballScale
    case ballPulse
    case ballScaleMultiple
    
    static let allTypes = (blank.rawValue ... ballScaleMultiple.rawValue).map { YLActivityIndicatorType(rawValue: $0)! }
    
    func animation() -> YLActivityIndicatorAnimationDelegate {
        switch self {
        case .blank:
            return YLActivityIndicatorAnimationBlank()
        case .ballScale:
            return YLActivityIndicatorAnimationBallScale()
        case .ballPulse:
            return YLActivityIndicatorAnimationBallPulse()
        case .ballScaleMultiple:
            return YLActivityIndicatorAnimationBallScaleMultiple()
        }
    }
}

public final class YLActivityIndicatorView: UIView {
    public static var DEFAULT_TYPE: YLActivityIndicatorType = .ballScale
    public static var DEFAULT_COLOR = UIColor.white
    public static var DEFAULT_TEXT_COLOR = UIColor.white
    public static var DEFAULT_PADDING: CGFloat = 0
    public static var DEFAULT_BLOCKER_SIZE = CGSize(width: 60, height: 60)
    /// Default display time threshold to actually display UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0
    /// Default minimum display time of UI blocker. Default value is 0 ms.
    public static var DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0
    public static var DEFAULT_BLOCKER_MESSAGE: String?
    public static var DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
    public static var DEFAULT_BLOCKER_BACKGROUND_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
    /// Animation type.
    public var type: YLActivityIndicatorType = YLActivityIndicatorView.DEFAULT_TYPE
    
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'type' instead.")
    
    @IBInspectable var typeName: String {
        get {
            return getTypeName()
        }
        set {
            _setTypeName(newValue)
        }
    }
    @IBInspectable public var color: UIColor = YLActivityIndicatorView.DEFAULT_COLOR
    @IBInspectable public var padding: CGFloat = YLActivityIndicatorView.DEFAULT_PADDING
    
    /// Current status of animation, read-only.
    @available(*, deprecated: 3.1)
    public var animating: Bool { return isAnimating }
    
    /// Current status of animation, read-only.
    private(set) public var isAnimating: Bool = false
    
    /**
     Returns an object initialized from data in a given unarchiver.
     self, initialized using the data in decoder.
     
     - parameter decoder: an unarchiver object.
     
     - returns: self, initialized using the data in decoder.
     */
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clear
        isHidden = true
    }
    
    /**
     Create a activity indicator view.
     
     Appropriate YLActivityIndicatorView.DEFAULT_* values are used for omitted params.
     
     - parameter frame:   view's frame.
     - parameter type:    animation type.
     - parameter color:   color of activity indicator view.
     - parameter padding: padding of activity indicator view.
     
     - returns: The activity indicator view.
     */
    public init(frame: CGRect, type: YLActivityIndicatorType? = nil, color: UIColor? = nil, padding: CGFloat? = nil) {
        self.type = type ?? YLActivityIndicatorView.DEFAULT_TYPE
        self.color = color ?? YLActivityIndicatorView.DEFAULT_COLOR
        self.padding = padding ?? YLActivityIndicatorView.DEFAULT_PADDING
        super.init(frame: frame)
        isHidden = true
    }
    
    // Fix issue #62
    // Intrinsic content size is used in autolayout
    // that causes mislayout when using with MBProgressHUD.
    /**
     Returns the natural size for the receiving view, considering only properties of the view itself.
     
     A size indicating the natural size for the receiving view based on its intrinsic properties.
     
     - returns: A size indicating the natural size for the receiving view based on its intrinsic properties.
     */
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: bounds.height)
    }

    public final func startAnimating() {
        isHidden = false
        isAnimating = true
        layer.speed = 1
        setUpAnimation()
    }

    public final func stopAnimating() {
        isHidden = true
        isAnimating = false
        layer.sublayers?.removeAll()
    }
    
    // MARK: Internal
    
    func _setTypeName(_ typeName: String) {
        for item in YLActivityIndicatorType.allTypes {
            if String(describing: item).caseInsensitiveCompare(typeName) == ComparisonResult.orderedSame {
                type = item
                break
            }
        }
    }
    
    func getTypeName() -> String {
        return String(describing: type)
    }
    
    // MARK: Privates
    
    private final func setUpAnimation() {
        let animation: YLActivityIndicatorAnimationDelegate = type.animation()
        var animationRect = frame.inset(by: UIEdgeInsets.init(top: padding, left: padding, bottom: padding, right: padding))
        let minEdge = min(animationRect.width, animationRect.height)
        
        layer.sublayers = nil
        animationRect.size = CGSize(width: minEdge, height: minEdge)
        animation.setUpAnimation(in: layer, size: animationRect.size, color: color)
    }
}





//
//  SegueFromLeft.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/3.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import UIKit

class SegueFromLeftAllDismiss: UIStoryboardSegue
{
    override func perform()
    {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseInOut,
                       animations: {
                        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: { finished in
                        src.presentedViewController?.dismiss(animated: false, completion: nil)
                        src.present(dst, animated: false, completion: nil)
        }
        )
    }
}

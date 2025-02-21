//
//  UIScrollView.swift
//  prography
//
//  Created by kangChangHyeok on 20/02/2025.
//

import UIKit

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}


extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

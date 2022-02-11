//
//  BottomEndView.swift
//  chatKit
//
//  Created by fengming on 2022/2/7.
//

import UIKit

open class CustomView: UIView {
    
    open var maxHeight: CGFloat = 0 {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: maxHeight)
    }
}

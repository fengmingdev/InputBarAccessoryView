//
//  BottomEndManager.swift
//  chatKit
//
//  Created by fengming on 2022/2/7.
//

import Foundation
import UIKit

open class CustomManager: NSObject, InputPlugin {
    
    // MARK: - Properties [Public]
    
    /// The `BottomEndView` that renders available autocompletes for the `currentSession`
    open lazy var customView: CustomView = { [weak self] in
        let customView = CustomView()
        if #available(iOS 13, *) {
            customView.backgroundColor = .systemBackground
        } else {
            customView.backgroundColor = .white
        }
        return customView
    }()
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
    }
    
    // MARK: - InputPlugin
    
    /// Reloads the InputPlugin's session
    open func reloadData() {
        
    }
    
    /// Invalidates the InputPlugin's session
    open func invalidate() {
        layoutIfNeeded()
    }
    
    /// Passes an object into the InputPlugin's session to handle
    ///
    /// - Parameter object: A string to append
    @discardableResult
    open func handleInput(of object: AnyObject) -> Bool {
        guard let newText = object as? String else { return false }
        print(newText)
        return true
    }
    
    
    private func layoutIfNeeded() {
        
        // Remove all child views
        customView.subviews.forEach { $0.removeFromSuperview() }
        
        // Resize the table to be fit properly in an `InputStackView`
        customView.invalidateIntrinsicContentSize()
        
        // Layout the table's superview
        customView.superview?.layoutIfNeeded()
    }
}

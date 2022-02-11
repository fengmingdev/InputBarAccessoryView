//
//  CustomViewController.swift
//  Example
//
//  Created by fengming on 2022/2/11.
//  Copyright © 2022 Nathan Tannar. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class CustomViewController: UIViewController {

    private let keyboardManager = KeyboardManager()
    
    let inputBar: InputBarAccessoryView = SlackInputBar()
    
    /// The object that manages attachments
    lazy var customManagerTop: CustomManager = { [unowned self] in
        let manager = CustomManager()
        return manager
    }()
    lazy var customManagerBottomEnd: CustomManager = { [unowned self] in
        let manager = CustomManager()
        return manager
    }()
    
    private lazy var topBtnButton: UIButton = {
        let topBtn = UIButton()
        topBtn.backgroundColor = .green
        topBtn.setTitle("top button", for: .normal)
        topBtn.bounds = CGRect(x: 0, y: 0, width: 200, height: 44)
        topBtn.addTarget(self, action: #selector(topButtonClick), for: .touchUpInside)
        return topBtn
    }()
    private lazy var bottomEndButton: UIButton = {
        let bottomEndBtn = UIButton()
        bottomEndBtn.backgroundColor = .lightGray
        bottomEndBtn.setTitle("bottom end button", for: .normal)
        bottomEndBtn.bounds = CGRect(x: 0, y: 0, width: 200, height: 44)
        bottomEndBtn.addTarget(self, action: #selector(bottomEndButtonClick), for: .touchUpInside)
        return bottomEndBtn
    }()
    
    var isTopActive: Bool = false
    var isBottomEndActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        inputBar.delegate = self
        inputBar.inputTextView.keyboardType = .twitter
        
        view.addSubview(inputBar)
        
        
        view.addSubview(topBtnButton)
        topBtnButton.center = CGPoint(x: view.center.x, y: view.center.y - 100)
        
        view.addSubview(bottomEndButton)
        bottomEndButton.center = CGPoint(x: view.center.x, y: view.center.y)
        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
        keyboardManager.bind(inputAccessoryView: inputBar)
        
    }
    
    @objc func topButtonClick() {
        isTopActive = !isTopActive
        setCustomManagerTop(active: isTopActive)
        let bottomEndView = self.customManagerTop.customView
        bottomEndView.maxHeight = 100
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 100))
        v.backgroundColor = .green
        bottomEndView.addSubview(v)
    }
    
    @objc func bottomEndButtonClick() {
        isBottomEndActive = !isBottomEndActive
        setCustomManagerBottomEnd(active: isBottomEndActive)
        let bottomEndView = self.customManagerBottomEnd.customView
        bottomEndView.maxHeight = 100
        let v = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width, height: 100))
        v.backgroundColor = .lightGray
        bottomEndView.addSubview(v)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        /// This replicates instagram's behavior when commenting in a post. As of 2020-09, it appears like they have one of the best product experiences of this handling the keyboard when dismissing the UIViewController
        self.inputBar.inputTextView.resignFirstResponder()
        /// This is set because otherwise, if only partially dragging the left edge of the screen, and then cancelling the dismissal, on viewDidAppear UIKit appears to set the first responder back to the inputTextView (https://stackoverflow.com/a/41847448)
        self.inputBar.inputTextView.canBecomeFirstResponder = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /// The opposite of `viewWillDisappear(_:)`
        self.inputBar.inputTextView.canBecomeFirstResponder = true
        self.inputBar.inputTextView.becomeFirstResponder()
    }
    
    func setCustomManagerTop(active: Bool) {
        let bottomEndStackView = self.inputBar.topStackView
        if active && !bottomEndStackView.arrangedSubviews.contains(customManagerTop.customView) {
            bottomEndStackView.insertArrangedSubview(customManagerTop.customView, at: bottomEndStackView.arrangedSubviews.count)
            bottomEndStackView.layoutIfNeeded()
        } else if !active && bottomEndStackView.arrangedSubviews.contains(customManagerTop.customView) {
            bottomEndStackView.removeArrangedSubview(customManagerTop.customView)
            customManagerTop.customView.removeFromSuperview()
            bottomEndStackView.layoutIfNeeded()
        }
        self.inputBar.invalidateIntrinsicContentSize()
    }
    
    func setCustomManagerBottomEnd(active: Bool) {
        let bottomEndStackView = self.inputBar.bottomEndStackView
        if active && !bottomEndStackView.arrangedSubviews.contains(customManagerBottomEnd.customView) {
            bottomEndStackView.insertArrangedSubview(customManagerBottomEnd.customView, at: bottomEndStackView.arrangedSubviews.count)
            bottomEndStackView.layoutIfNeeded()
        } else if !active && bottomEndStackView.arrangedSubviews.contains(customManagerBottomEnd.customView) {
            bottomEndStackView.removeArrangedSubview(customManagerBottomEnd.customView)
            customManagerBottomEnd.customView.removeFromSuperview()
            bottomEndStackView.layoutIfNeeded()
        }
        self.inputBar.invalidateIntrinsicContentSize()
    }
    
    
    
}
extension CustomViewController: InputBarAccessoryViewDelegate {
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (attributes, range, stop) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()

        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, didChangeIntrinsicContentTo size: CGSize) {
        // Adjust content insets
        print(size)
    }
    
    @objc func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        
    }
    
}

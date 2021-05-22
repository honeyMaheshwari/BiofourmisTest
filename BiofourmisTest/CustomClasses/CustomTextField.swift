//
//  CustomTextField.swift
//  BiofourmisTest
//
//  Created by Honey Maheshwari on 22/05/21.
//

import UIKit

class CustomTextField: UITextField, Threads {
    
    enum FieldSataus {
        case ideal
        case editing
        case filled
        case error
        
        fileprivate var color: UIColor {
            switch self {
            case .ideal:
                return .gray
            case .editing:
                return .appThemeColor
            case .filled:
                return .successColor
            case .error:
                return .errorColor
            }
        }
        
        fileprivate var floatingLabelAlpha: CGFloat {
            switch self {
            case .ideal:
                return 0.0
            default:
                return 1.0
            }
        }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
    
    @IBInspectable var floatingPlaceholder: String? {
        didSet {
            floatingLabel?.text = floatingPlaceholder
            if floatingPlaceholder.validate.count > 0 {
                placeholder = floatingPlaceholder
            }
        }
    }
    
    @IBInspectable var exampleValue: String? {
        didSet {
            contentVerticalAlignment = exampleValue != nil ? .bottom : .center
        }
    }
    
    private var lineView: UIView?
    private var floatingLabel: UILabel?
    private var defaultPlaceholderY: CGFloat = 0.0
    
    override var text: String? {
        didSet {
            textFieldEditingDidEnd()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            floatingLabel?.frame.size.width = bounds.size.width
        }
    }
    
    override var frame: CGRect {
        didSet {
            floatingLabel?.frame.size.width = frame.size.width
        }
    }
    
    var status: FieldSataus = FieldSataus.ideal {
        didSet {
            updateUIWhenStatusChanges()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    // MARK: - Setup
    
    private func initialSetup() {
        contentVerticalAlignment = exampleValue != nil ? .bottom : .center
        clipsToBounds = false
        runOnMainThread {
            self.addFloatingLabel()
            self.addLineView()
            self.addObservers()
        }
    }
    
    private func addFloatingLabel() {
        floatingLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: 0.0))
        floatingLabel?.text = floatingPlaceholder
        floatingLabel?.numberOfLines = 1
        floatingLabel?.font = UIFont.systemFont(ofSize: 13.0)
        floatingLabel?.alpha = 0.0
        if let defaultPlaceholderLabel = subviews.filter({ $0 is UILabel }).first as? UILabel {
            defaultPlaceholderY = defaultPlaceholderLabel.frame.origin.y
            floatingLabel?.font = defaultPlaceholderLabel.font
        }
        floatingLabel?.sizeToFit()
        floatingLabel?.frame.origin.y = defaultPlaceholderY
        floatingLabel?.frame.size.width = bounds.size.width
        addSubview(floatingLabel!)
    }
    
    private func addLineView() {
        lineView = UIView(frame: CGRect(x: 0.0, y: bounds.size.height + (exampleValue != nil ? 5 : 0), width: bounds.size.width, height: 1.0))
       // lineView = UIView(frame: CGRect(x: 0.0, y: bounds.size.height, width: bounds.size.width, height: 1.0))
        lineView?.backgroundColor = status.color
        addSubview(lineView!)
    }
    
    // MARK: - Text Field Observers
    
    func addObservers() {
        addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(textFieldEditingChange), for: .editingChanged)
        addTarget(self, action: #selector(textFieldEditingDidEnd), for: .editingDidEnd)
    }
    
    @objc
    private func textFieldEditingDidBegin() {
        status = .editing
        if exampleValue.validate.count > 0 {
            placeholder = exampleValue
        }
    }
    
    @objc
    private func textFieldEditingChange() {
        status = .editing
    }
    
    @objc
    private func textFieldEditingDidEnd() {
        status = text?.count == 0 ? .ideal : .filled
    }
    
    // MARK: - Privat methods
    
    private func updateUIWhenStatusChanges() {
        var y: CGFloat = 0.0
        
        switch status {
        case .ideal:
            if floatingPlaceholder.validate.count > 0 {
                placeholder = floatingPlaceholder
            }
            y = defaultPlaceholderY
        case .editing:
            if exampleValue.validate.count > 0 {
                placeholder = exampleValue
            }
        case .filled:
            if exampleValue.validate.count > 0 {
                placeholder = exampleValue
            }
        case .error:
            if exampleValue.validate.count > 0 {
                placeholder = exampleValue
            }
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.lineView?.backgroundColor = self.status.color
            self.floatingLabel?.alpha = self.status.floatingLabelAlpha
            self.floatingLabel?.frame.origin.y = y
            self.floatingLabel?.textColor = UIColor.lightGray
        }) { (_) in
            
        }
    }
    
}

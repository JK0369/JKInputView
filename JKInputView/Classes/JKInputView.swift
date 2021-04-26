//
//  JKInputView.swift
//  TapRider
//
//  Created by 김종권 on 2021/03/08.
//  Copyright © 2021 42dot. All rights reserved.
//

import Foundation
import UIKit

protocol JKInputViewDelegate: class {
    func textField(_ inputView: JKInputView, didChangeText string: String)
}

enum TextFieldType: Int {
    case name
    case phoneNumber
    case email
    case password
}

public enum JKInputViewState {
    typealias ColorSet = (inputText: UIColor, underLine: UIColor, description: UIColor)

    case active
    case inactive
    case error

    func color() -> ColorSet {
        switch self {
        case .active:
            return (.black,
                    .blue,
                    .darkGray)
        case .inactive:
            return (.black,
                    .lightGray,
                    .darkGray)
        case .error:
            return (.red,
                    .red,
                    .red)
        }
    }
}

enum PasswordTextFieldState {
    case validPassword
    case invalidPassword
}

@IBDesignable
public class JKInputView: UIView {

    // Outlet

    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var btnRight: UIButton!
    @IBOutlet weak private var underlineView: UIView!
    @IBOutlet weak private var lblDescription: UILabel!
    @IBOutlet var constraintTopSuperViewAndTopTextField: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomTextFieldAndTopUnderLine: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomUnderlineAndTopLblDesc: NSLayoutConstraint!

    // Properties

    private var textFieldType: TextFieldType = .name
    weak var delegate: JKInputViewDelegate?
    private var passwordTextFieldStatus: PasswordTextFieldState = .validPassword
    private var textFieldState_: JKInputViewState = .inactive
    private var textFieldState: JKInputViewState {
        get {
            return textFieldState_
        } set {
            textFieldState_ = newValue
            updateUI(by: newValue)
        }
    }

    @IBInspectable private var isHideDescription: Bool {
        get { return lblDescription.isHidden }
        set { lblDescription.isHidden = newValue }
    }

    @IBInspectable private var placeholder: String? {
        get { return nil }
        set { textField.placeholder = newValue }
    }

    @IBInspectable private var textFieldTypeAdapter: Int {
        get { return textFieldType.rawValue }
        set(typeAdapter) {
            textFieldType = TextFieldType(rawValue: typeAdapter) ?? .name
            switch textFieldType {
            case .password:
                btnRight.setImage(ResourceImage.invisibleEye, for: .normal)
                textField.textContentType = .password
                textField.isSecureTextEntry = true
                btnRight.isHidden = false

            case .phoneNumber:
                btnRight.setImage(ResourceImage.clear, for: .normal)
                textField.keyboardType = .phonePad

            case .email:
                btnRight.setImage(ResourceImage.clear, for: .normal)
                textField.textContentType = .emailAddress
                textField.autocorrectionType = .no

            default:
                btnRight.setImage(ResourceImage.clear, for: .normal)
            }
        }
    }

    @IBInspectable private var labelText: String? {
        get { return lblDescription.text }
        set { lblDescription.text = newValue }
    }

    // Initialize

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpInputBinding()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
        setUpInputBinding()
    }

    public override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }

    private func setUpView() {
        guard let jkInputView = loadViewFromNib(nib: "JKInputView") else {
            return
        }
        jkInputView.frame = bounds
        addSubview(jkInputView)
        textField.delegate = self
    }

    private func loadViewFromNib(nib: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nib, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

    // Binding

    private func setUpInputBinding() {
        btnRight.addTarget(self, action: #selector(didTapRightBtton), for: .touchUpInside)
    }

    @objc private func didTapRightBtton() {
        switch textFieldType {
        case .password:
            if textField.isSecureTextEntry {
                btnRight.setImage(ResourceImage.invisibleEye, for: .normal)
            } else {
                btnRight.setImage(ResourceImage.visibleEye, for: .normal)
            }
            textField.isSecureTextEntry.toggle()
        default:
            removeAllTextField()
        }
    }

    private func updateUI(by state: JKInputViewState) {
        let colorSet = state.color()
        textField.textColor = colorSet.inputText
        underlineView.backgroundColor = colorSet.underLine
        lblDescription.textColor = colorSet.description
    }

    private func removeAllTextField() {
        textField.text?.removeAll()
        delegate?.textField(self, didChangeText: "")
        textFieldState = .active

        if textFieldType == .password {
            passwordTextFieldStatus = .validPassword
        } else {
            btnRight.isHidden = true
            lblDescriptionUpdate(isHidden: true)
        }
    }

    private func checkIsHiddenBtnRight(text: String?) {
        guard textFieldType != .password else {
            btnRight.isHidden = false
            return
        }
        btnRight.isHidden = (text ?? "").isEmpty
    }
}

// MARK: - Utils

extension JKInputView {

    // TextField

    public func textFieldSetUpSmallSpace() {
        constraintTopSuperViewAndTopTextField.constant = 12
        constraintBottomTextFieldAndTopUnderLine.constant = 12
    }

    public func textFieldSetUpSmallLayoutForIPhoneSE() {
        constraintTopSuperViewAndTopTextField.constant = 8
        constraintBottomTextFieldAndTopUnderLine.constant = 8
    }

    public func textFieldBecomeFirstResponder() {
        DispatchQueue.main.async { [weak self] in
            self?.textField.becomeFirstResponder()
        }
    }

    public func textFieldUpdate(to state: JKInputViewState) {
        switch textFieldType {
        case .password:
            if state == .error {
                passwordTextFieldStatus = .invalidPassword
            } else {
                passwordTextFieldStatus = .validPassword
            }
        case .email:
            if state == .error {
                lblDescriptionUpdate(isHidden: false)
            } else {
                lblDescriptionUpdate(isHidden: true)
            }
        default:
            break
        }
        textFieldState = state
    }

    public func textFieldString() -> String {
        return textField.text ?? ""
    }

    public func textFieldSetString(_ string: String) {
        textField.text = string
        delegate?.textField(self, didChangeText: string)
        textFieldUpdate(to: .active)
    }

    public func textFieldRemoveAll() {
        removeAllTextField()
    }

    public func textFieldUpdateFontSize(to font: UIFont) {
        textField.font = font
    }

    public func textFieldPlaceHolder(_ string: String) {
        placeholder = string
    }

    // Label Description

    public func lblDescriptionUpdate(isHidden: Bool) {
        isHideDescription = isHidden
    }

    public func lblDescriptionUpdate(text: String) {
        isHideDescription = false
        lblDescription.text = text
    }
}

// MARK: - Delegate

extension JKInputView: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        guard let text = textField.text,
              let textRange = Range(range, in: text) else {
            return false
        }
        let newText = text.replacingCharacters(in: textRange, with: string)
        checkIsHiddenBtnRight(text: newText)

        switch textFieldType {
        case .name:
            delegate?.textField(self, didChangeText: newText)
            if newText.count > 16 {
                return false
            }
            return true

        case .phoneNumber:
            textField.text = format(phoneNumber: text)
            delegate?.textField(self, didChangeText: textField.text ?? "")
            return false

        case .email:
            textFieldUpdate(to: .active)
            delegate?.textField(self, didChangeText: newText)
            return true

        case .password:
            lblDescriptionUpdate(text: "character + number + special")
            if passwordTextFieldStatus == .invalidPassword, string.isEmpty {
                textFieldRemoveAll()
                return false
            } else {
                textFieldUpdate(to: .active)
                delegate?.textField(self, didChangeText: newText)
                return true
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textFieldState != .error else {
            return
        }
        textFieldState = .active
    }

    func format(phoneNumber: String, shouldRemoveLastDigit: Bool = false) -> String {
        guard !phoneNumber.isEmpty else { return "" }
        guard let regex = try? NSRegularExpression(pattern: "[\\s-\\(\\)]", options: .caseInsensitive) else { return "" }
        let r = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber, options: .init(rawValue: 0), range: r, withTemplate: "")

        if number.count > 10 {
            let tenthDigitIndex = number.index(number.startIndex, offsetBy: 10)
            number = String(number[number.startIndex..<tenthDigitIndex])
        }

        if shouldRemoveLastDigit {
            let end = number.index(number.startIndex, offsetBy: number.count-1)
            number = String(number[number.startIndex..<end])
        }

        if number.count < 7 {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d+)", with: "($1) $2", options: .regularExpression, range: range)

        } else {
            let end = number.index(number.startIndex, offsetBy: number.count)
            let range = number.startIndex..<end
            number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        }

        return number
    }
    
}

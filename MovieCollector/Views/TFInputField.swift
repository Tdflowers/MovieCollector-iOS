//
//  TFInputField.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/9/22.
//

import UIKit

enum TFInputFieldType {
    case Name
    case Password
    case ConfirmPassword
    case Email
    case Username
}

class TFInputField: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var titleLabel:UILabel!
    public var textField:UITextField!
    var subtitleLabel:UILabel!
    
    var title:String = ""
    var textPlaceholder:String = ""
    var subtitle:String = ""
    
    var type: TFInputFieldType!
    
    init(type: TFInputFieldType) {
        self.type = type
        
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        setupView()
        setupAutolayout()
        setupType()
    }
    
    
    func setupView() {
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        self.addSubview(titleLabel)
        
        textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = textPlaceholder
        textField.borderStyle = .roundedRect
        if type == .Password || type == .ConfirmPassword {
            textField.isSecureTextEntry = true
        } else {
            textField.isSecureTextEntry = false
        }
        self.addSubview(textField)
        
        subtitleLabel = UILabel(frame: .zero)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        self.addSubview(subtitleLabel)
    }
    
    func setupType() {
        switch type {
        case .Name:
            titleLabel.text = "Full Name"
            textField.placeholder = "John Smith"
            subtitleLabel.text = ""
        case .Password:
            titleLabel.text = "Password"
            textField.placeholder = "••••••••••"
//            subtitleLabel.text = ""
        case .ConfirmPassword:
            titleLabel.text = "Confirm Password"
            textField.placeholder = "••••••••••"
//            subtitleLabel.text = ""
        case .Email:
            titleLabel.text = "Email"
            textField.placeholder = "john@applesmith.com"
//            subtitleLabel.text = ""
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        case .Username:
            titleLabel.text = "Username"
            textField.placeholder = "@johnapple"
            subtitleLabel.text = "You’ll use the username to share your profile and find your friends!"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
        case .none:
            titleLabel.text = "We broke what"
        }
    }
    
    func setupAutolayout() {
        guard let titleLabel = titleLabel else { return }
        guard let subtitleLabel = subtitleLabel else { return }
        guard let textField = textField else { return }
        
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: subtitleLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .top, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: subtitleLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: subtitleLabel, attribute: .top, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: textField, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textField, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: textField, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1, constant: 120).isActive = true

        
    }
    
    func animateSubtitleText(red:Bool, with text:String) {
                
        UIView.transition(with: self.subtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
          self.subtitleLabel.textColor = .systemRed
            self.subtitleLabel.text = text
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

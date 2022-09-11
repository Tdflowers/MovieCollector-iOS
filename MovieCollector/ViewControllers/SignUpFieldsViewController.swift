//
//  SignUpFieldsViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/9/22.
//

import UIKit
import FirebaseAuth

enum SignUpPageType {
    case SignUpPage1
    case SignUpPage2
    case Login
    case SignupApple
}

class SignUpFieldsViewController: UIViewController {
    
    var signUpTitle: String
    var fields: [TFInputFieldType] = []
    var signuptype:SignUpPageType

    var fieldsStackView:UIStackView!
    var tfFields: [TFInputField] = []
    var closeButton:UIButton!
    
    var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    var nextButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Continue"
        config.background.backgroundColor = .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = .label
        config.titlePadding = 10
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            return outgoing
          }
        button.configuration = config
        button.tag = 0
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    init(title: String, fields:[TFInputFieldType], signupType:SignUpPageType) {
        self.signUpTitle = title
        self.fields = fields
        self.signuptype = signupType
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .systemBackground
        
        fieldsStackView = UIStackView(frame: .zero)
        fieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        fieldsStackView.distribution = .equalCentering
        fieldsStackView.axis = .vertical
//        fieldsStackView.spacing = 20
        self.view.addSubview(fieldsStackView)
        self.view.addSubview(nextButton)
        self.view.addSubview(titleLabel)
        titleLabel.text = title
        
        nextButton.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
                
        for field in fields {
            let tfField = TFInputField(type: field)
            tfFields.append(tfField)
            fieldsStackView.addArrangedSubview(tfField)
        }
        
        closeButton = UIButton(type: .custom, primaryAction: UIAction(handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        }))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "chevron.left" ), for: .normal)
        closeButton.tintColor = .label
        self.view.addSubview(closeButton)

        let count = tfFields.count
        NSLayoutConstraint(item: fieldsStackView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .height, relatedBy: .lessThanOrEqual, toItem: tfFields[0], attribute: .height, multiplier: CGFloat(count), constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15)
            ])
        
        NSLayoutConstraint(item: nextButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: fieldsStackView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -10).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        var buttonConfig = nextButton.configuration
        
        switch signuptype {
        case .SignUpPage1:
            buttonConfig?.title = "Continue"
        case .SignUpPage2:
            buttonConfig?.title = "Finish"
        case .Login:
            buttonConfig?.title = "Login"
        case .SignupApple:
            buttonConfig?.title = "Finish"
        }
        nextButton.configuration = buttonConfig
        
    }
    
    @objc func continuePressed() {
        
        switch signuptype {
            case .SignUpPage1:
            let signupvc = SignUpFieldsViewController(title: "Sign Up", fields: [TFInputFieldType.Email, TFInputFieldType.Password, TFInputFieldType.ConfirmPassword], signupType: .SignUpPage2)
                self.navigationController?.pushViewController(signupvc, animated: true)
            case .SignUpPage2:
                print("Signup Page 2 Finished")
                self.dismiss(animated: true)
            case .Login:
                print("Login Pressed")
            if tfFields[0].textField.text != nil && tfFields[1].textField.text != nil && tfFields[0].textField.text != "" && tfFields[1].textField.text != "" {
                Auth.auth().signIn(withEmail: tfFields[0].textField.text ?? "", password: tfFields[1].textField.text ?? "") {
                    authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
    //                    errorString = "Signup error: " + error.localizedDescription
                        return
                    } else {
                        self.dismiss(animated: true)
                    }
                }
            }
            case .SignupApple:
                print("Sign Up with Apple Completed")
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

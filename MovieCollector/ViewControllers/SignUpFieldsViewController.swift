//
//  SignUpFieldsViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/9/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

enum SignUpPageType {
    case SignUpPage1
    case SignUpPage2
    case Login
    case SignupApple
    case ForgotPassword
}

class SignUpFieldsViewController: UIViewController {
    
    var signUpTitle: String
    var fields: [TFInputFieldType] = []
    var signuptype:SignUpPageType

    var fieldsStackView:UIStackView!
    var tfFields: [TFInputField] = []
    var closeButton:UIButton!
    
    var ref: Firestore!
    
    var continueButtonLayoutBottom:NSLayoutConstraint!
    
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
        
        ref = Firestore.firestore()
        
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
            tfField.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint(item: fieldsStackView!, attribute: .centerY, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.85, constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .height, relatedBy: .lessThanOrEqual, toItem: tfFields[0], attribute: .height, multiplier: CGFloat(count), constant: 0).isActive = true
        NSLayoutConstraint(item: fieldsStackView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15)
            ])
        
        NSLayoutConstraint(item: nextButton, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: fieldsStackView, attribute: .bottom, multiplier: 1, constant: 50).isActive = true
        continueButtonLayoutBottom = NSLayoutConstraint(item: nextButton, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: self.view.keyboardLayoutGuide, attribute: .top, multiplier: 1, constant: -10)
        continueButtonLayoutBottom.isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.75, constant: 0).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: nextButton, attribute: .height, relatedBy: .lessThanOrEqual, toItem: .none, attribute: .height, multiplier: 1, constant: 50).isActive = true
        
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
        case .ForgotPassword:
            buttonConfig?.title = "Send Reset Email"
        }
        nextButton.configuration = buttonConfig
        
        self.hideKeyboardWhenTappedAround()

    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func continuePressed() {
        
        switch signuptype {
            case .SignUpPage1:
            if tfFields[1].textField.text!.count > 2 {
                checkIfUserNameExists(name:tfFields[1].textField.text!) { usernameInUse in
                    if usernameInUse {
                        self.tfFields[1].animateSubtitleText(red: true, with: "Username in Use. Please select another.")
                    } else {
                        self.tfFields[1].animateSubtitleText(red: false, with: "")
                        let signupvc = SignUpFieldsViewController(title: "Sign Up", fields: [TFInputFieldType.Email, TFInputFieldType.Password, TFInputFieldType.ConfirmPassword], signupType: .SignUpPage2)
                        self.navigationController?.pushViewController(signupvc, animated: true)
                    }
                }
            }
            case .SignUpPage2:
            var fails = false
            if !isValidEmail(self.tfFields[0].textField.text ?? "") {
                self.tfFields[0].animateSubtitleText(red: true, with: "Invalid Email")
                fails = true
            } else {
                self.tfFields[0].animateSubtitleText(red: false, with: "")
            }
            let passwordRegEx = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z])(?=.*[0-9]).{8,}$")
            if (!passwordRegEx.evaluate(with: tfFields[1].textField.text ?? "")) {
                self.tfFields[1].animateSubtitleText(red: true, with: "Password Does Not Meet Requirements")
                fails = true
            } else {
                self.tfFields[1].animateSubtitleText(red: false, with: "")
            }
            if (tfFields[1].textField.text != tfFields[2].textField.text && tfFields[1].textField.text != "") {
                self.tfFields[2].animateSubtitleText(red: true, with: "Passwords do not match")
                fails = true
            } else {
                self.tfFields[2].animateSubtitleText(red: false, with: "")
            }
            if fails { return }
            if let navController = self.navigationController, navController.viewControllers.count >= 2 {
                Auth.auth().createUser(withEmail: tfFields[0].textField.text ?? "", password: tfFields[1].textField.text ?? "") { authResult, error in
                    if let error = error {
                        print(error.localizedDescription)
//                        errorString = "Signup error: " + error.localizedDescription
                        self.tfFields[0].animateSubtitleText(red: true, with: error.localizedDescription)
                        return
                    } else {
                        if let authResult = authResult {
                                if let viewController = navController.viewControllers[navController.viewControllers.count - 2] as? SignUpFieldsViewController {
                                    self.ref.collection("users").document(authResult.user.uid).setData(["name":viewController.tfFields[0].textField.text ?? "", "username":viewController.tfFields[1].textField.text ?? "", "email":self.tfFields[0].textField.text ?? ""]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            print("Document successfully written!")
                                        }
                                    }
                                }
                            }
                        }
                        self.dismiss(animated: true)
                    }
                }
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
        case .ForgotPassword:
            if let email = tfFields[0].textField.text {
                if isValidEmail(email) {
                    tfFields[0].animateSubtitleText(red: false, with: "")
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        // ...
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    tfFields[0].animateSubtitleText(red: true, with: "Invalid Email")
                }
            }
        }
        
    }
    
    func checkIfUserNameExists(name:String, completion: @escaping (Bool) -> Void) {
        let userref = Firestore.firestore().collection("users")
        
        userref.getDocuments { doc, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in doc!.documents {
                    if let data = document.data() as? Dictionary <String, String> {
                        if data["username"] == name {
                            completion(true)
                            return
                        }
                    }
                }
                completion(false)
            }
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

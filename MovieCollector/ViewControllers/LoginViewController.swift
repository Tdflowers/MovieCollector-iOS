//
//  LoginViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/7/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    var isInSignupMode:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupViews()
        setupAutolayout()
    }
    
    var closeButton:UIButton!
    
    var titleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign Up for Movie Collector"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel.init(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create a profile to save your movies and tv shows"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    var signUpWithAppleButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.filled()
        config.title = "Sign Up With Apple"
        config.background.backgroundColor = .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = .label
        config.titlePadding = 10
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            // 1
            var outgoing = incoming
            // 2
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            // 3
            return outgoing
          }
        button.configuration = config
        button.tag = 0
        
        return button
    }()
    
    var signUpWithEmailButton: UIButton = {
        let button = UIButton.init(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.filled()
        config.title = "Sign Up With Email"
        config.background.backgroundColor = .systemBackground
        config.background.strokeColor = .label
        config.background.strokeWidth = 1
        config.baseForegroundColor = .label
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            // 1
            var outgoing = incoming
            // 2
            outgoing.font = UIFont.systemFont(ofSize: 22, weight: .medium)
            // 3
            return outgoing
          }
        button.configuration = config

        button.tag = 1
        
        return button
    }()
    
    var switchAccountType: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        var config = UIButton.Configuration.borderless()
        config.title = "Already have an account? Login"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            // 1
            var outgoing = incoming
            // 2
            outgoing.font = UIFont.systemFont(ofSize: 10, weight: .bold)
            // 3
            return outgoing
          }
        button.configuration = config
        button.tintColor = .label
        return button
    }()
    
    func setupViews() {
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)

        self.view.addSubview(signUpWithAppleButton)
        self.view.addSubview(signUpWithEmailButton)
        self.view.addSubview(switchAccountType)
        self.signUpWithEmailButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        self.signUpWithAppleButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        self.switchAccountType.addTarget(self, action: #selector(switchAccountTypePressed), for: .touchUpInside)
        
        closeButton = UIButton(type: .custom, primaryAction: UIAction(handler: { (_) in
            self.dismiss(animated: true)
        }))
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark" ), for: .normal)
        closeButton.tintColor = .label
        self.view.addSubview(closeButton)

    }
    
    func setupAutolayout() {
        
        NSLayoutConstraint(item: titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 0.3, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.80, constant: 0).isActive = true
        NSLayoutConstraint(item: titleLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true

        NSLayoutConstraint(item: subTitleLabel, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: subTitleLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.65, constant: 0).isActive = true
        NSLayoutConstraint(item: subTitleLabel, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        
        NSLayoutConstraint(item: signUpWithEmailButton, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signUpWithAppleButton, attribute: .centerX, relatedBy: .equal, toItem: titleLabel, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: signUpWithEmailButton, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 0.6, constant: 0).isActive = true
        NSLayoutConstraint(item: signUpWithAppleButton, attribute: .top, relatedBy: .equal, toItem: signUpWithEmailButton, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        
        NSLayoutConstraint(item: switchAccountType, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: switchAccountType, attribute: .top, relatedBy: .equal, toItem: signUpWithAppleButton, attribute: .bottom, multiplier: 1, constant: 15).isActive = true

        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15)
            ])
    }
    
    @objc func signUpButtonPressed(sender:UIButton) {
        
        if sender.tag == 0 {
            //Apple Button Pressed
        } else if sender.tag == 1 {
            //Email Button Pressed
            if isInSignupMode {
                let signupvc = SignUpFieldsViewController(title: "Sign Up", fields: [TFInputFieldType.Name, TFInputFieldType.Username], signupType: .SignUpPage1)
                self.navigationController?.pushViewController(signupvc, animated: true)
            } else {
                let signupvc = SignUpFieldsViewController(title: "Login", fields: [TFInputFieldType.Email, TFInputFieldType.Password], signupType: .Login)
                self.navigationController?.pushViewController(signupvc, animated: true)
            }
        }
        
    }
    
    @objc func switchAccountTypePressed() {
        //Switch to login if on sign up or reverse
        var accountConfig = self.switchAccountType.configuration
        var signAppleConfig = self.signUpWithAppleButton.configuration
        var loginEmailConfig = self.signUpWithEmailButton.configuration
        
        var titleText:String = ""
        var subtitleText:String = ""

        if isInSignupMode {
            isInSignupMode = false
            accountConfig?.title = "Don’t have an account? Sign Up"
            signAppleConfig?.title = "Login With Apple"
            loginEmailConfig?.title = "Login with Email"
            
            titleText = "Sign Into MovieCollector"
            subtitleText = "Add movies, update your profile, and more"
        } else {
            isInSignupMode = true
            accountConfig?.title = "Already have an account? Login"
            signAppleConfig?.title = "Signup With Apple"
            loginEmailConfig?.title = "Signup with Email"
            
            titleText = "Sign Up for Movie Collector"
            subtitleText = "Create a profile to save your movies and tv shows"
        }
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.subtype = CATransitionSubtype.fromTop
        self.titleLabel.text = titleText
        self.subTitleLabel.text = subtitleText
        self.switchAccountType.configuration = accountConfig
        self.signUpWithAppleButton.configuration = signAppleConfig
        self.signUpWithEmailButton.configuration = loginEmailConfig
        animation.duration = 0.35
        self.titleLabel.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        self.subTitleLabel.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        self.signUpWithAppleButton.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        self.switchAccountType.layer.add(animation, forKey: CATransitionType.fade.rawValue)
        self.signUpWithEmailButton.layer.add(animation, forKey: CATransitionType.fade.rawValue)
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

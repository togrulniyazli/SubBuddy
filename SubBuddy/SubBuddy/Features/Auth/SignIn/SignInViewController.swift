//
//  SignInViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 11.02.26.
//

import UIKit
import SnapKit
import FirebaseAuth

final class SignInViewController: UIViewController {
    
    private let viewModel = SignInViewModel()
    private let primaryColor = UIColor(named: "appPrimaryColor") ?? .systemRed
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = UIColor(named: "appPrimaryColor")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Control your subscriptions, track spending and manage payments effortlessly with SubBuddy."
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var passwordField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        
        let eyeButton = UIButton(type: .system)
        eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        eyeButton.tintColor = .systemGray
        eyeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        eyeButton.addTarget(
            self,
            action: #selector(togglePasswordVisibility),
            for: .touchUpInside
        )
        
        tf.rightView = eyeButton
        tf.rightViewMode = .always
        
        return tf
    }()
    
    private let forgotPasswordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Forgot Password?", for: .normal)
        btn.setTitleColor(UIColor(named: "appPrimaryColor"), for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    private let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.backgroundColor = UIColor(named: "appPrimaryColor")
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 26
        return btn
    }()
    
    private lazy var bottomLabel: UILabel = {
        
        let label = UILabel()
        
        let text = NSMutableAttributedString(
            string: "Don't have an account? ",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        text.append(
            NSAttributedString(
                string: "Sign Up",
                attributes: [
                    .foregroundColor: UIColor(named: "appPrimaryColor")!,
                    .font: UIFont.systemFont(ofSize: 16, weight: .bold)
                ]
            )
        )
        
        label.attributedText = text
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(signUpTapped)
        )
        
        label.addGestureRecognizer(tap)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupActions()
        
        if let savedEmail = UserDefaults.standard.string(forKey: "lastUsedEmail") {
            emailField.text = savedEmail
        }
        
        setupKeyboardObservers()
        enableKeyboardDismissOnTap()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(signInButton)
        contentView.addSubview(bottomLabel)
    }
    
    private func setupConstraints() {

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
        }

        emailField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }

        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(30)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }

        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func setupActions() {
        
        forgotPasswordButton.addTarget(
            self,
            action: #selector(openForgot),
            for: .touchUpInside
        )
        
        signInButton.addTarget(
            self,
            action: #selector(didTapSignIn),
            for: .touchUpInside
        )
    }
    
    @objc private func signUpTapped() {
        navigationController?.pushViewController(
            SignUpViewController(),
            animated: true
        )
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        
        passwordField.isSecureTextEntry.toggle()
        
        let imageName = passwordField.isSecureTextEntry
        ? "eye.slash"
        : "eye"
        
        sender.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
    }
    
    @objc private func openForgot() {
        
        navigationController?.pushViewController(
            ForgotPasswordViewController(),
            animated: true
        )
    }
    
    @objc private func didTapSignIn() {
        
        guard
            let email = emailField.text,
            let password = passwordField.text
        else { return }
        
        viewModel.signIn(
            email: email,
            password: password
        ) { [weak self] result in
            
            guard let self else { return }
            
            switch result {
            case .success:
                guard let user = Auth.auth().currentUser else {
                    self.showAlert(title: "Error", message: "User not found")
                    return
                }
                
                user.reload { [weak self] _ in
                    
                    guard let self else { return }
                    
                    guard let refreshedUser = Auth.auth().currentUser else {
                        self.showAlert(title: "Error", message: "User not found")
                        return
                    }
                    
                    if !refreshedUser.isEmailVerified {
                        
                        let alert = UIAlertController(
                            title: "Email not verified",
                            message: "Please verify your email before signing in. Check your inbox.",
                            preferredStyle: .alert
                        )
                        
                        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: .default
                        ))
                        
                        self.present(alert, animated: true)
                        return
                    }
                    
                    UserService.shared.checkUserProfileExists { [weak self] result in
                        
                        guard let self else { return }
                        
                        switch result {
                            
                        case .success(let exists):
                            
                            if exists {
                                let tabBar = MainTabBarController()
                                
                                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                                   let window = windowScene.windows.first {
                                    
                                    window.rootViewController = tabBar
                                    window.makeKeyAndVisible()
                                }
                                
                            } else {
                                self.navigationController?.pushViewController(
                                    CompleteProfileViewController(),
                                    animated: true
                                )
                            }
                            
                        case .failure(let error):
                            self.showAlert(title: "Error", message: error.localizedDescription)
                        }
                    }
                }
                
            case .failure(let error):

                let nsError = error as NSError
                var message = "Something went wrong. Please try again."

                switch nsError.code {

                case AuthErrorCode.wrongPassword.rawValue,
                     AuthErrorCode.userNotFound.rawValue,
                     AuthErrorCode.invalidCredential.rawValue,
                     17004:

                    message = "Invalid email or password."

                case AuthErrorCode.invalidEmail.rawValue:
                    message = "Please enter a valid email address."

                case AuthErrorCode.networkError.rawValue:
                    message = "Network error. Check your internet connection."

                default:
                    message = "Something went wrong. Please try again."
                }

                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: message,
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default
                ))

                self.present(alert, animated: true)
            }
        }
    }
    
    private func showAlert(
        title: String,
        message: String
    ) {
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(alert, animated: true)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = frame.height
        scrollView.verticalScrollIndicatorInsets.bottom = frame.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
}

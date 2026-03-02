//
//  SignUpViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 11.02.26.
//

import UIKit
import SnapKit
import FirebaseAuth

final class SignUpViewController: UIViewController {
    
    private let viewModel = SignUpViewModel()
    
    private let primaryColor = UIColor(named: "appPrimaryColor") ?? .systemRed
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.textColor = UIColor(named: "appPrimaryColor")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Access your account to track subscriptions, manage payments and keep control with ease."
        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    private let facebookButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "facebook")
        config.title = " Facebook"
        config.baseBackgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.08)
        
        let btn = UIButton(configuration: config)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    private let googleButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "google")
        config.title = " Google"
        config.baseBackgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.08)
        
        let btn = UIButton(configuration: config)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        return btn
    }()
    
    private lazy var socialStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            facebookButton,
            googleButton
        ])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    private let leftLine: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray4
        return v
    }()
    
    private let rightLine: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray4
        return v
    }()
    
    private let orLabel: UILabel = {
        let label = UILabel()
        label.text = "Or"
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private lazy var orStack: UIStackView = {
        
        let stack = UIStackView(arrangedSubviews: [
            leftLine,
            orLabel,
            rightLine
        ])
        
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        
        leftLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(rightLine)
        }
        
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        return stack
    }()
    
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email / Phone Number"
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
        
        eyeButton.setImage(
            UIImage(systemName: "eye.slash"),
            for: .normal
        )
        
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
    
    private lazy var confirmPasswordField: UITextField = {
        
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.isSecureTextEntry = true
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        
        let eyeButton = UIButton(type: .system)
        
        eyeButton.setImage(
            UIImage(systemName: "eye.slash"),
            for: .normal
        )
        
        eyeButton.tintColor = .systemGray
        
        eyeButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        eyeButton.addTarget(
            self,
            action: #selector(toggleConfirmPasswordVisibility),
            for: .touchUpInside
        )
        
        tf.rightView = eyeButton
        tf.rightViewMode = .always
        
        return tf
    }()
    
    
    private let createAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.backgroundColor = UIColor(named: "appPrimaryColor")
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 26
        return btn
    }()
    
    
    private lazy var bottomLabel: UILabel = {
        
        let label = UILabel()
        
        let text = NSMutableAttributedString(
            string: "Already have account? ",
            attributes: [
                .foregroundColor: UIColor.secondaryLabel
            ]
        )
        
        text.append(
            NSAttributedString(
                string: "Sign In",
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
            action: #selector(signInTapped)
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
        contentView.addSubview(socialStack)
        contentView.addSubview(orStack)
        contentView.addSubview(emailField)
        contentView.addSubview(passwordField)
        contentView.addSubview(confirmPasswordField)
        contentView.addSubview(createAccountButton)
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
        
        socialStack.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        orStack.snp.makeConstraints { make in
            make.top.equalTo(socialStack.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(30)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(orStack.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(25)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        bottomLabel.snp.makeConstraints { make in
            make.top.equalTo(createAccountButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func setupActions() {
        
        createAccountButton.addTarget(
            self,
            action: #selector(createAccountTapped),
            for: .touchUpInside
        )
    }
    
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        
        passwordField.isSecureTextEntry.toggle()
        
        let imageName = passwordField.isSecureTextEntry
        ? "eye.slash"
        : "eye"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func toggleConfirmPasswordVisibility(_ sender: UIButton) {
        
        confirmPasswordField.isSecureTextEntry.toggle()
        
        let imageName = confirmPasswordField.isSecureTextEntry
        ? "eye.slash"
        : "eye"
        
        sender.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc private func signInTapped() {
        
        navigationController?.pushViewController(
            SignInViewController(),
            animated: true
        )
    }
    
    @objc private func createAccountTapped() {
        
        guard
            let email = emailField.text,
            let password = passwordField.text,
            let confirm = confirmPasswordField.text
        else {
            return
        }

        guard !email.isEmpty else {
            showAlert(
                title: "Error",
                message: "Email cannot be empty"
            )
            return
        }

        guard !password.isEmpty else {
            showAlert(
                title: "Error",
                message: "Password cannot be empty"
            )
            return
        }

        guard password == confirm else {
            showAlert(
                title: "Error",
                message: "Passwords do not match"
            )
            return
        }

        viewModel.signUp(
            email: email,
            password: password,
            confirmPassword: confirm
        ) { [weak self] result in

            guard let self else { return }

            switch result {

            case .success:

                guard let user = Auth.auth().currentUser else {

                    self.showAlert(
                        title: "Error",
                        message: "User not found"
                    )

                    return
                }

                user.sendEmailVerification { error in

                    DispatchQueue.main.async {

                        if let error {

                            self.showAlert(
                                title: "Verification Failed",
                                message: error.localizedDescription
                            )

                            return
                        }

                        let alert = UIAlertController(
                            title: "Verify your email",
                            message: "A verification link has been sent to your email. Please verify your email before signing in.",
                            preferredStyle: .alert
                        )

                        alert.addAction(UIAlertAction(
                            title: "OK",
                            style: .default
                        ) { _ in

                            self.navigationController?.pushViewController(
                                SignInViewController(),
                                animated: true
                            )
                        })

                        self.present(alert, animated: true)
                    }
                }

            case .failure(let error):

                let nsError = error as NSError

                var message = error.localizedDescription

                if nsError.code == AuthErrorCode.emailAlreadyInUse.rawValue {

                    message = "This email is already in use. Please sign in instead."
                }

                self.showAlert(
                    title: "Sign Up Failed",
                    message: message
                )
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


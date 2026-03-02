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
        let stack = UIStackView(arrangedSubviews: [facebookButton, googleButton])
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
        let stack = UIStackView(arrangedSubviews: [leftLine, orLabel, rightLine])
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
        contentView.addSubview(forgotPasswordButton)
        contentView.addSubview(signInButton)
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

        forgotPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(30)
        }

        signInButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordButton.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
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

                let alert = UIAlertController(
                    title: "Sign In Failed",
                    message: error.localizedDescription,
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



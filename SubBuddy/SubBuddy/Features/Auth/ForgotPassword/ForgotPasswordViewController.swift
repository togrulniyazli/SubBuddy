//
//  ForgotPasswordViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 11.02.26.
//

import UIKit
import SnapKit

final class ForgotPasswordViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password"
        label.textColor = UIColor(named: "appPrimaryColor")
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Don’t worry! Enter your email address to reset your password and regain access to your account."
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email Address"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.autocorrectionType = .no
        tf.clearButtonMode = .whileEditing
        
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private let continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
        btn.backgroundColor = UIColor(named: "appPrimaryColor")
        btn.layer.cornerRadius = 26
        return btn
    }()
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = ""
        
        setupUI()
        setupConstraints()
        setupActions()
        enableKeyboardDismissOnTap()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(emailField)
        view.addSubview(continueButton)
        
        continueButton.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(30)
        }
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc private func continueTapped() {
        
        view.endEditing(true)
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title: "Error", message: "Please enter your email address.")
            return
        }
        
        setLoading(true)
        
        AuthService.shared.resetPassword(email: email) { [weak self] result in
            guard let self = self else { return }
            
            self.setLoading(false)
            
            switch result {
            case .success:
                self.showAlert(
                    title: "Email Sent",
                    message: "Password reset link has been sent to your email."
                )
            case .failure(let error):
                self.showAlert(
                    title: "Error",
                    message: error.localizedDescription
                )
            }
        }
    }
    
    private func setLoading(_ isLoading: Bool) {
        continueButton.isEnabled = !isLoading
        emailField.isEnabled = !isLoading
        
        if isLoading {
            activityIndicator.startAnimating()
            continueButton.setTitle("", for: .normal)
        } else {
            activityIndicator.stopAnimating()
            continueButton.setTitle("Continue", for: .normal)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

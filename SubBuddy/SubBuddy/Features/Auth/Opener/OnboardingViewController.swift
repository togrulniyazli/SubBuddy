//
//  OnboardingViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 11.02.26.
//

import UIKit
import SnapKit

final class OnboardingViewController: UIViewController {
    
    private let gradientLayer = CAGradientLayer()
        
    private let calendarImageView: UIImageView = {
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 140,
            weight: .regular,
            scale: .large)
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "calendar.circle.fill",withConfiguration:config)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    private let bellImageView: UIImageView = {
        
        let config = UIImage.SymbolConfiguration(
            pointSize: 44,
            weight: .bold,
            scale: .large)
        
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bell.fill",withConfiguration: config)
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "SubBuddy"
        label.textColor = .white
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.alpha = 0
        return label
    }()
    
    private let signInButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign In", for: .normal)
        btn.backgroundColor = .white
        btn.setTitleColor(
            UIColor(named: "appPrimaryColor"),
            for: .normal)
        btn.layer.cornerRadius = 28
        btn.alpha = 0
        return btn
    }()
    
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.alpha = 0
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradient()
        setupUI()
        setupConstraints()
        setupActions()
        enableKeyboardDismissOnTap()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareInitialState()
        startAnimation()
    }
        
    private func setupGradient() {
        
        let color = UIColor(named: "appPrimaryColor") ?? .systemRed
        gradientLayer.colors = [
            color.cgColor,
            color.withAlphaComponent(0.8).cgColor]
        view.layer.insertSublayer(gradientLayer,at: 0)
    }
    
    
    private func setupUI() {
        
        view.addSubview(calendarImageView)
        view.addSubview(bellImageView)
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    
    private func setupConstraints() {
        
        calendarImageView.snp.makeConstraints { make in
            make.center.equalToSuperview().offset(-80)
            make.size.equalTo(160)
        }
        
        bellImageView.snp.makeConstraints { make in
            make.size.equalTo(44)
            make.right.equalTo(calendarImageView.snp.right).offset(8)
            make.bottom.equalTo(calendarImageView.snp.bottom).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(calendarImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(56)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-80)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(signInButton.snp.top).offset(-16)
        }
    }
    
    
    private func prepareInitialState() {
        
        calendarImageView.transform =
        CGAffineTransform(translationX: -view.bounds.width,y: 0)
        
        bellImageView.transform =
        CGAffineTransform(translationX: view.bounds.width,y: 0)
        
        signInButton.transform =
        CGAffineTransform(translationX: 0,y: 200)
        
        signUpButton.transform =
        CGAffineTransform(translationX: 0,y: 200)
    }
    
    private func startAnimation() {
        
        UIView.animate(withDuration: 0.8) {
            
            self.calendarImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.8,delay: 0.1) {
            
            self.bellImageView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.5,delay: 0.2) {
            
            self.titleLabel.alpha = 1
        }
        
        UIView.animate(withDuration: 0.9,delay: 0.3) {
            
            self.signInButton.alpha = 1
            self.signUpButton.alpha = 1
            
            self.signInButton.transform = .identity
            self.signUpButton.transform = .identity
        }
    }
    
    
    private func setupActions() {
        
        signInButton.addTarget(
            self,
            action: #selector(openSignIn),
            for: .touchUpInside
        )
        
        signUpButton.addTarget(
            self,
            action: #selector(openSignUp),
            for: .touchUpInside
        )
    }
    
    @objc private func openSignIn() {
        
        navigationController?.pushViewController(
            SignInViewController(),
            animated: true
        )
    }
    
    @objc private func openSignUp() {
        
        navigationController?.pushViewController(
            SignUpViewController(),
            animated: true
        )
    }
}

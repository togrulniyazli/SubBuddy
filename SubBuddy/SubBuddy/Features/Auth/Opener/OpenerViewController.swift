//
//  OpenerViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 11.02.26.
//

import UIKit
import SnapKit

final class OpenerViewController: UIViewController {
    
    private let gradientLayer = CAGradientLayer()
    
    private let iconContainer = UIView()
    
    private let calendarImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "calendar")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
        return iv
    }()
    
    private let bellImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bell.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.alpha = 0
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
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 28
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        btn.alpha = 0
        return btn
    }()
    
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Create Account", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.alpha = 0
        return btn
    }()
    
    private var calendarCenterConstraint: Constraint?
    private var bellCenterConstraint: Constraint?
    
    private var signInBottomConstraint: Constraint?
    private var signUpBottomConstraint: Constraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradient()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateEntrance()
    }
    
    
    
    private func setupGradient() {
        
        let primary = UIColor(named: "appPrimaryColor") ?? .systemRed
        
        gradientLayer.colors = [
            primary.withAlphaComponent(1).cgColor,
            primary.withAlphaComponent(0.8).cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    
    private func setupUI() {
        
        view.addSubview(iconContainer)
        
        iconContainer.addSubview(calendarImage)
        iconContainer.addSubview(bellImage)
        
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
    }
    
    
    
    private func setupConstraints() {
        
        iconContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-120)
            make.size.equalTo(140)
        }
        
        calendarImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(90)
            calendarCenterConstraint = make.centerX.equalToSuperview().offset(-120).constraint
        }
        
        bellImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(40)
            bellCenterConstraint = make.centerX.equalToSuperview().offset(120).constraint
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        signInButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.height.equalTo(56)
            signInBottomConstraint = make.bottom.equalToSuperview().offset(120).constraint
        }
        
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            signUpBottomConstraint = make.bottom.equalToSuperview().offset(70).constraint
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
    
    
    private func animateEntrance() {
        
        view.layoutIfNeeded()
        
        calendarCenterConstraint?.update(offset: -20)
        bellCenterConstraint?.update(offset: 20)
        
        signInBottomConstraint?.update(offset: -80)
        signUpBottomConstraint?.update(offset: -40)
        
        UIView.animate(
            withDuration: 0.9,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.6
        ) {
            
            self.calendarImage.alpha = 1
            self.bellImage.alpha = 1
            self.titleLabel.alpha = 1
            
            self.signInButton.alpha = 1
            self.signUpButton.alpha = 1
            
            self.view.layoutIfNeeded()
        }
    }
    
    
    @objc private func openSignIn() {
        let vc = SignInViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func openSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

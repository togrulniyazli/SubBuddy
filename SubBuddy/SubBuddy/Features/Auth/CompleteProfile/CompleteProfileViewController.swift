//
//  CompleteProfileViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 18.02.26.
//

import UIKit
import SnapKit

final class CompleteProfileViewController: UIViewController {

    private let viewModel = CompleteProfileViewModel()
    private let primaryColor = UIColor(named: "appPrimaryColor") ?? .systemRed


    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.keyboardDismissMode = .onDrag
        return scroll
    }()

    private let contentView = UIView()


    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Complete Profile"
        label.textColor = UIColor(named: "appPrimaryColor")
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private let firstNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let lastNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.backgroundColor = UIColor(named: "appPrimaryColor")?.withAlphaComponent(0.05)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Birth Date"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let birthDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.maximumDate = Date()
        return picker
    }()

    private let continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Continue", for: .normal)
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
        enableKeyboardDismissOnTap()
    }


    private func setupUI() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        contentView.addSubview(titleLabel)
        contentView.addSubview(firstNameField)
        contentView.addSubview(lastNameField)
        contentView.addSubview(birthDateLabel)
        contentView.addSubview(birthDatePicker)
        contentView.addSubview(continueButton)
    }


    private func setupConstraints() {

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
        }

        firstNameField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }

        lastNameField.snp.makeConstraints { make in
            make.top.equalTo(firstNameField.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
        }

        birthDateLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
        }

        birthDatePicker.snp.makeConstraints { make in
            make.top.equalTo(birthDateLabel.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(30)
        }

        continueButton.snp.makeConstraints { make in
            make.top.equalTo(birthDatePicker.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(40)
        }
    }


    private func setupActions() {
        continueButton.addTarget(
            self,
            action: #selector(didTapContinue),
            for: .touchUpInside
        )
    }

    @objc private func didTapContinue() {

        guard
            let firstName = firstNameField.text,
            let lastName = lastNameField.text
        else { return }

        let birthDate = birthDatePicker.date

        viewModel.saveProfile(
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate
        ) { [weak self] result in

            guard let self else { return }

            switch result {

            case .success:
                SceneDelegate.shared?.switchToMainTab()

            case .failure(let error):
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}

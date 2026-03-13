//
//  ProfileViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 24.02.26.
//

import UIKit
import SnapKit
import Kingfisher
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

final class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let viewModel = ProfileViewModel()
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
    private let backButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .label
        return btn
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle.fill")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 44
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 14
        return s
    }()
    
    private func makeRow(icon: String, title: String, isDestructive: Bool = false) -> UIControl {
        let row = UIControl()
        row.backgroundColor = .clear
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = isDestructive ? .systemRed : .label
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 18, weight: .regular)
        titleLabel.textColor = isDestructive ? .systemRed : .label
        
        row.addSubview(iconView)
        row.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(16)
            make.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(14)
        }
        
        return row
    }
    
    private lazy var accountSettingsRow = makeRow(icon: "person", title: "Account Settings")
    private lazy var subscriptionRow     = makeRow(icon: "doc.text", title: "Subscription Management")
    private lazy var paymentRow          = makeRow(icon: "creditcard", title: "Payment Methods")
    private lazy var notificationRow     = makeRow(icon: "bell", title: "Notification Preferences")
    private lazy var privacyRow          = makeRow(icon: "shield", title: "Privacy & Security")
    private lazy var helpRow             = makeRow(icon: "headphones", title: "Help & Support")
    private lazy var legalRow            = makeRow(icon: "doc", title: "Legal & Terms")
    private lazy var logoutRow           = makeRow(icon: "rectangle.portrait.and.arrow.right", title: "Log Out", isDestructive: true)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        setupUI()
        setupConstraints()
        setupBindings()
        setupActions()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.load()
    }
    
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backButton)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        
        contentView.addSubview(stack)
        
        stack.addArrangedSubview(accountSettingsRow)
        stack.addArrangedSubview(subscriptionRow)
        stack.addArrangedSubview(paymentRow)
        stack.addArrangedSubview(notificationRow)
        stack.addArrangedSubview(privacyRow)
        
        let divider1 = divider()
        stack.addArrangedSubview(divider1)
        
        stack.addArrangedSubview(helpRow)
        stack.addArrangedSubview(legalRow)
        stack.addArrangedSubview(logoutRow)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalToSuperview().inset(24)
            make.width.height.equalTo(88)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.top).offset(10)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(24)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel.snp.left)
            make.right.equalToSuperview().inset(24)
        }
        
        stack.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
    private func setupBindings() {
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            
            self.nameLabel.text = self.viewModel.fullName.isEmpty ? "—" : self.viewModel.fullName
            self.emailLabel.text = self.viewModel.email.isEmpty ? "—" : self.viewModel.email
            
            let placeholder = UIImage(systemName: "person.crop.circle.fill")
            
            if let url = URL(string: self.viewModel.profileImageURL),
               !self.viewModel.profileImageURL.isEmpty {
                self.avatarImageView.kf.setImage(with: url, placeholder: placeholder)
            } else {
                self.avatarImageView.image = placeholder
            }
        }
        
        viewModel.onError = { [weak self] message in
            self?.showAlert(title: "Error", message: message)
        }
        
        viewModel.onLogout = { [weak self] in
            SceneDelegate.shared?.switchToSignIn()
        }
    }
    
    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        avatarImageView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        )
        
        logoutRow.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }
    
    private func divider() -> UIView {
        let v = UIView()
        v.backgroundColor = .systemGray4
        v.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return v
    }
    
    
    @objc private func backTapped() {
        tabBarController?.selectedIndex = 0
    }
    
    @objc private func logoutTapped() {
        viewModel.logout()
    }
    
    @objc private func avatarTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            sheet.addAction(UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
                self?.openPicker(.camera)
            })
        }
        
        sheet.addAction(UIAlertAction(title: "Gallery", style: .default) { [weak self] _ in
            self?.openPicker(.photoLibrary)
        })
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }
    
    private func openPicker(_ source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = false
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = (info[.editedImage] as? UIImage) ?? (info[.originalImage] as? UIImage)
        if let image {
            avatarImageView.image = image
            uploadProfileImage(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func uploadProfileImage(_ image: UIImage) {
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference()
        
        let fileName = "\(userID)_\(UUID().uuidString).jpg"
        let profileRef = storageRef.child("profile_images/\(fileName)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        profileRef.putData(imageData, metadata: metadata) { [weak self] _, error in
            
            guard let self else { return }
            
            if let error = error {
                self.showAlert(title: "Upload Error", message: error.localizedDescription)
                return
            }
            
            profileRef.downloadURL { url, error in
                
                if let error = error {
                    self.showAlert(title: "URL Error", message: error.localizedDescription)
                    return
                }
                
                guard let url else {
                    self.showAlert(title: "URL Error", message: "Profile image URL is missing.")
                    return
                }
                
                UserService.shared.updateProfileImageURL(url.absoluteString) { result in
                    
                    switch result {
                        
                    case .success:
                        self.viewModel.load()
                        
                    case .failure(let error):
                        self.showAlert(title: "Save Error", message: error.localizedDescription)
                    }
                }
            }
        }
    }
}

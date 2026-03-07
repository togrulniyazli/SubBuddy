//
//  PromoAppView.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import UIKit
import SnapKit
import Kingfisher

final class PromoAppView: UIView {
    
    var onTap: (() -> Void)?
    
    private let iconContainer = UIView()
    private let iconView = UIImageView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    private let starIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "star.fill"))
        iv.tintColor = .systemOrange
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        iconContainer.backgroundColor = UIColor.systemGray5
        iconContainer.layer.cornerRadius = 22
        iconContainer.clipsToBounds = true
        
        iconView.contentMode = .scaleAspectFit
        
        addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        
        addSubview(nameLabel)
        addSubview(starIcon)
        addSubview(ratingLabel)
        addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        
        iconContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(iconContainer.snp.width)
        }
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(10)
            make.left.equalToSuperview()
        }
        
        starIcon.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.width.height.equalTo(14)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(starIcon)
            make.left.equalTo(starIcon.snp.right).offset(4)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(starIcon.snp.bottom).offset(6)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configure(with app: AppModel) {
        nameLabel.text = app.name
        ratingLabel.text = "\(app.rating)"
        priceLabel.text = "$\(String(format: "%.2f", app.price))"
        
        if let url = URL(string: app.iconURL) {
            iconView.kf.setImage(with: url)
        }
    }
    
    @objc private func handleTap() {
        onTap?()
    }
}

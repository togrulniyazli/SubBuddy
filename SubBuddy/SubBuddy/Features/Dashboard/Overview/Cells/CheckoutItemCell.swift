//
//  CheckoutItemCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import UIKit
import SnapKit
import Kingfisher

final class CheckoutItemCell: UICollectionViewCell {
    
    static let identifier = "CheckoutItemCell"
    
    var onRemove: (() -> Void)?
    
    
    private let iconView = UIImageView()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    private let planLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        return l
    }()
    
    private let removeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .systemGray
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    private func setupUI() {
        
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(planLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(removeButton)
        
        iconView.backgroundColor = .systemGray6
        iconView.layer.cornerRadius = 16
        iconView.clipsToBounds = true
        iconView.contentMode = .scaleAspectFit
    }
    
    
    private func setupConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        planLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.left.equalTo(nameLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.bottom.equalTo(iconView)
            make.left.equalTo(nameLabel)
        }
        
        removeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    
    private func setupActions() {
        removeButton.addTarget(
            self,
            action: #selector(removeTapped),
            for: .touchUpInside
        )
    }
    
    @objc private func removeTapped() {
        onRemove?()
    }
    
    
    func configure(with item: CartItem) {
        nameLabel.text = item.app.name
        planLabel.text = item.plan.rawValue
        
        let price = item.price
        priceLabel.text = String(format: "$%.2f", price)
        
        if let url = URL(string: item.app.iconURL) {
            iconView.kf.setImage(with: url)
        }
    }
}

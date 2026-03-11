//
//  CartItemCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import UIKit
import SnapKit
import Kingfisher

final class CartItemCell: UICollectionViewCell {
    
    static let identifier = "CartItemCell"
    
    var onRemove: (() -> Void)?
    var onCheck: (() -> Void)?
    
    
    private let checkBox: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "square"), for: .normal)
        b.tintColor = .systemGray
        return b
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 14
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    private let planButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitleColor(.label, for: .normal)
        b.backgroundColor = .systemGray6
        b.layer.cornerRadius = 10
        b.titleLabel?.font = .systemFont(ofSize: 14)
        b.isUserInteractionEnabled = false
        return b
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .bold)
        return l
    }()
    
    private let removeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .systemGray2
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
        
        removeButton.addTarget(self,
                               action: #selector(removeTapped),
                               for: .touchUpInside)
        
        checkBox.addTarget(self,
                           action: #selector(checkTapped),
                           for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        contentView.addSubview(checkBox)
        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(planButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(removeButton)
    }
    
    private func setupConstraints() {
        
        checkBox.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(checkBox.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        planButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalTo(nameLabel)
            make.height.equalTo(28)
            make.width.equalTo(110)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(planButton.snp.bottom).offset(6)
            make.left.equalTo(nameLabel)
        }
        
        removeButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    
    func configure(with item: CartItem) {
        nameLabel.text = item.app.name
        priceLabel.text = "$\(String(format: "%.2f", item.price))"
        planButton.setTitle(item.plan.rawValue, for: .normal)
        
        if let url = URL(string: item.app.iconURL) {
            iconView.kf.setImage(with: url)
        }
    }
    
    
    func setChecked(_ checked: Bool) {
        let image = checked
        ? UIImage(systemName: "checkmark.square.fill")
        : UIImage(systemName: "square")
        
        checkBox.setImage(image, for: .normal)
    }
    
    
    @objc private func removeTapped() {
        onRemove?()
    }
    
    @objc private func checkTapped() {
        onCheck?()
    }
}

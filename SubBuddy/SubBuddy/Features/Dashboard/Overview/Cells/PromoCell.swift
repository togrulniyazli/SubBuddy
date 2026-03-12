//
//  PromoCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 02.03.26.
//

import UIKit
import SnapKit

final class PromoCell: UICollectionViewCell {
    
    var onButtonTap: (() -> Void)?
    
    static let identifier = "PromoCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    private let actionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.systemRed, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 14
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        return btn
    }()
    
    private let promoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 24
        contentView.clipsToBounds = true
        contentView.backgroundColor =
        UIColor(named: "appPrimaryColor") ?? .systemRed
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(actionButton)
        contentView.addSubview(promoImageView)
        
        actionButton.addTarget(
                    self,
                    action: #selector(buttonTapped),
                    for: .touchUpInside
                )
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    @objc private func buttonTapped() {
            onButtonTap?()
        }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(20)
            make.right.equalTo(promoImageView.snp.left).offset(-12)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.left.equalTo(titleLabel)
            make.height.equalTo(38)
            make.width.greaterThanOrEqualTo(140)
        }
        
        promoImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(16)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.45)
        }
    }
    
    func configure(with model: PromoModel) {
        titleLabel.text = model.title
        actionButton.setTitle(model.buttonTitle, for: .normal)
        promoImageView.image = UIImage(named: model.imageName)
    }
}

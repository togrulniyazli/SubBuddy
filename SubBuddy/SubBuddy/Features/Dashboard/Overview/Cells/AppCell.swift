//
//  AppCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit
import SnapKit
import Kingfisher

final class AppCell: UICollectionViewCell {
    
    static let identifier = "AppCell"
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .secondarySystemBackground
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        contentView.addSubview(cardView)
        
        cardView.addSubview(iconImageView)
        cardView.addSubview(nameLabel)
        cardView.addSubview(ratingLabel)
        cardView.addSubview(priceLabel)
        
        
    }
    
    private func setupConstraints() {
        
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(6)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
    }


    func configure(with app: AppModel) {
        iconImageView.kf.setImage(
            with: URL(string: app.iconURL)
        )

        nameLabel.text = app.name
        ratingLabel.text = "⭐ \(app.rating)"
        priceLabel.text = "$\(String(format: "%.2f", app.price))"
    }
}

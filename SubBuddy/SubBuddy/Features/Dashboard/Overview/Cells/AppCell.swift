//
//  AppCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit
import SnapKit

final class AppCell: UICollectionViewCell {

    static let identifier = "AppCell"

    private let iconContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 24
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupUI() {
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)

        contentView.addSubview(nameLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(priceLabel)
    }

    private func setupConstraints() {

        iconContainer.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(iconContainer.snp.width)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(70)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconContainer.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }

        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(6)
            make.left.equalToSuperview()
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(4)
            make.left.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    func configure(with app: AppModel) {
        iconImageView.image = UIImage(named: app.iconName)
        nameLabel.text = app.name
        ratingLabel.text = "⭐ \(app.rating)"
        priceLabel.text = "$\(String(format: "%.2f", app.price))"
    }
}

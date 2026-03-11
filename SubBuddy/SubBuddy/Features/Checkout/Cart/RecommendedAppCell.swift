//
//  RecommendedAppCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import UIKit
import SnapKit
import Kingfisher

final class RecommendedAppCell: UICollectionViewCell {

    static let identifier = "RecommendedAppCell"

    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        iv.layer.cornerRadius = 16
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textAlignment = .center
        l.numberOfLines = 2
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(iconView)
        contentView.addSubview(nameLabel)

        iconView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(100)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(6)
            make.left.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with app: AppModel) {
        nameLabel.text = app.name

        if let url = URL(string: app.iconURL) {
            iconView.kf.setImage(with: url)
        }
    }
}

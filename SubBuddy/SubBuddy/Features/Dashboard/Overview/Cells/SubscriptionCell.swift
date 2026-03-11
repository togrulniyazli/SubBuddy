//
//  SubscriptionCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import UIKit
import SnapKit

final class SubscriptionCell: UICollectionViewCell {
    
    static let identifier = "SubscriptionCell"
    
    private let containerView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 16
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.systemGray5.cgColor
        return v
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        return l
    }()
    
    private let arrowImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        iv.tintColor = .systemGray3
        return iv
    }()
    
    private let calendarIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "calendar")
        iv.tintColor = .systemGray
        return iv
    }()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let packageIcon: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "cube.box")
        iv.tintColor = .systemGray
        return iv
    }()
    
    private let planLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let statusDot: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        return v
    }()
    
    private let statusLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(iconView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(arrowImage)
        containerView.addSubview(calendarIcon)
        containerView.addSubview(dateLabel)
        containerView.addSubview(packageIcon)
        containerView.addSubview(planLabel)
        containerView.addSubview(statusDot)
        containerView.addSubview(statusLabel)
    }
    
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        iconView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(16)
            make.width.height.equalTo(36)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(12)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalToSuperview().offset(-16)
        }
        
        calendarIcon.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(14)
            make.left.equalTo(iconView)
            make.size.equalTo(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarIcon)
            make.left.equalTo(calendarIcon.snp.right).offset(8)
        }
        
        packageIcon.snp.makeConstraints { make in
            make.top.equalTo(calendarIcon.snp.bottom).offset(8)
            make.left.equalTo(iconView)
            make.size.equalTo(16)
        }
        
        planLabel.snp.makeConstraints { make in
            make.centerY.equalTo(packageIcon)
            make.left.equalTo(packageIcon.snp.right).offset(8)
        }
        
        statusDot.snp.makeConstraints { make in
            make.top.equalTo(packageIcon.snp.bottom).offset(14)
            make.left.equalTo(iconView)
            make.size.equalTo(10)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(statusDot)
            make.left.equalTo(statusDot.snp.right).offset(8)
        }
    }
    
    
    func configure(with sub: Subscription) {
        iconView.image = nil
        nameLabel.text = sub.app.name
        planLabel.text = sub.plan
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        let start = formatter.string(from: sub.startDate)
        let end = formatter.string(from: sub.endDate)
        
        dateLabel.text = "\(start) - \(end)"
        
        if let url = URL(string: sub.app.iconURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    self.iconView.image = UIImage(data: data)
                }
            }.resume()
        }
        
        if sub.isEndingSoon {
            statusLabel.text = "Subscription ending soon"
            statusDot.backgroundColor = .systemOrange
            
        } else {
            let remaining = Calendar.current.dateComponents(
                [.day],
                from: Date(),
                to: sub.endDate
            ).day ?? 0
            
            if remaining <= 10 {
                statusLabel.text = "Ending soon"
                statusDot.backgroundColor = .systemOrange
            } else {
                statusLabel.text = "Active"
                statusDot.backgroundColor = .systemGreen
            }
        }
    }
}

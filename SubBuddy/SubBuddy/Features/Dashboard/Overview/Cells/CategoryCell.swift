//
//  CategoryCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {
    
    static let identifier = "CategoryCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byClipping
        return label
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
        containerView.addSubview(titleLabel)
    }
    
    private func setupConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(containerView).inset(10)
            make.left.right.equalTo(containerView).inset(18)
        }
    }
    
    func configure(with category: AppCategory, isSelected: Bool) {
        titleLabel.text = category.rawValue
        if isSelected {
            containerView.backgroundColor = UIColor(named: "appPrimaryColor")
            containerView.layer.borderColor = UIColor.clear.cgColor
            titleLabel.textColor = .white
        } else {
            
            containerView.backgroundColor = .clear
            containerView.layer.borderColor = UIColor.label.cgColor
            titleLabel.textColor = .label
        }
    }
}

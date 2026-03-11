//
//  PaymentMethodCell.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import UIKit
import SnapKit

final class PaymentMethodCell: UICollectionViewCell {
    
    static let identifier = "PaymentMethodCell"
    
    private let iconView = UIImageView()
    
    private let numberLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .medium)
        l.textColor = .label
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
        
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 14
        
        addSubview(iconView)
        addSubview(numberLabel)
        
        iconView.contentMode = .scaleAspectFit
    }
    
    private func setupConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
        
        numberLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(type: String, number: String, selected: Bool) {
        iconView.image = UIImage(named: type)
        numberLabel.text = number
        
        if selected {
            layer.borderWidth = 2
            layer.borderColor = UIColor(named: "appPrimaryColor")?.cgColor
        } else {
            layer.borderWidth = 0
        }
    }
}

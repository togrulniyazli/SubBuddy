//
//  PromoSectionView.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import UIKit
import SnapKit

final class PromoSectionView: UIView {
    
    var openApp: ((AppModel) -> Void)?
    
    private let iconView = UIImageView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private let arrowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        btn.tintColor = .systemGray
        return btn
    }()
    
    private let gridStack = UIStackView()
    
    private var apps: [AppModel] = []
    private var allApps: [AppModel] = []
    private var sectionTitle: String = ""
    
    init(icon: String, title: String, apps: [AppModel]) {
        super.init(frame: .zero)
        
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = UIColor(named: "appPrimaryColor")
        
        titleLabel.text = title
        sectionTitle = title.lowercased()
        
        self.apps = apps
        self.allApps = apps
        
        setupUI()
        setupConstraints()
        configureApps()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        
        layer.cornerRadius = 20
        backgroundColor = UIColor.secondarySystemBackground
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(arrowButton)
        addSubview(gridStack)
        
        gridStack.axis = .horizontal
        gridStack.spacing = 16
        gridStack.distribution = .fillEqually
        gridStack.alignment = .top
    }
    
    private func setupConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.width.height.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.left.equalTo(iconView.snp.right).offset(8)
        }
        
        arrowButton.snp.makeConstraints { make in
            make.centerY.equalTo(iconView)
            make.right.equalToSuperview().inset(16)
        }
        
        gridStack.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func configureApps() {
        
        gridStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        apps.prefix(2).forEach { app in
            
            let view = PromoAppView()
            view.configure(with: app)
            
            view.onTap = { [weak self] in
                self?.openApp?(app)
            }
            
            gridStack.addArrangedSubview(view)
        }
    }
    
    
    func filter(text: String) {
        let query = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        if query.isEmpty {
            apps = allApps
            self.isHidden = false
            configureApps()
            return
        }
        
        let filtered = allApps.filter {
            $0.name.lowercased().contains(query)
        }
        
        if filtered.isEmpty {
            self.isHidden = true
        } else {
            self.isHidden = false
            apps = filtered
            configureApps()
        }
    }
}

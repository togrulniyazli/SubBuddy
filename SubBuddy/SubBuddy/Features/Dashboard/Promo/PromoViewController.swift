//
//  PromoViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//
import UIKit
import SnapKit

final class PromoViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Promo"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let bagButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bag.fill"), for: .normal)
        btn.tintColor = .label
        btn.backgroundColor = UIColor.systemGray5
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    private let cartCountLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemRed
        label.textColor = .white
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search..."
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No apps found"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let welcomingOfferSection = PromoSectionView(
        icon: "figure.wave",
        title: "Welcoming Offer",
        apps: [
            MockApps.all[0],
            MockApps.all[3]
        ]
    )
    
    private let fullYearSection = PromoSectionView(
        icon: "calendar",
        title: "Save on Premium",
        apps: [
            MockApps.all[3],
            MockApps.all[5]
        ]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        
        setupUI()
        setupConstraints()
        setupTapGesture()
        setupActions()
        
        updateCartBadge()
        
        CartManager.shared.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateCartBadge()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartBadge()
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(bagButton)
        bagButton.addSubview(cartCountLabel)
        
        contentView.addSubview(searchBar)
        contentView.addSubview(emptyLabel)
        
        contentView.addSubview(welcomingOfferSection)
        contentView.addSubview(fullYearSection)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(8)
            make.left.equalToSuperview().inset(16)
        }
        
        bagButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(44)
        }
        
        cartCountLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-4)
            make.right.equalToSuperview().offset(4)
            make.width.height.equalTo(20)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        welcomingOfferSection.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
        }
        
        fullYearSection.snp.makeConstraints { make in
            make.top.equalTo(welcomingOfferSection.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(contentView).offset(-20)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupActions() {
        
        welcomingOfferSection.openApp = { [weak self] app in
            let vc = AppDetailViewController(app: app)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        fullYearSection.openApp = { [weak self] app in
            let vc = AppDetailViewController(app: app)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        bagButton.addTarget(self,
                            action: #selector(openCart),
                            for: .touchUpInside)
    }
    
    private func updateCartBadge() {
        let count = CartManager.shared.itemCount
        if count == 0 {
            cartCountLabel.isHidden = true
        } else {
            
            cartCountLabel.isHidden = false
            cartCountLabel.text = "\(count)"
        }
    }
    
    @objc private func openCart() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDismissKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleDismissKeyboard() {
        view.endEditing(true)
    }
}

extension PromoViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        emptyLabel.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        welcomingOfferSection.filter(text: searchText)
        fullYearSection.filter(text: searchText)
        
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if query.isEmpty {
            
            welcomingOfferSection.isHidden = false
            fullYearSection.isHidden = false
            emptyLabel.isHidden = true
            return
        }
        
        let allHidden =
        welcomingOfferSection.isHidden &&
        fullYearSection.isHidden
        
        emptyLabel.isHidden = !allHidden
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            
            welcomingOfferSection.isHidden = false
            fullYearSection.isHidden = false
            emptyLabel.isHidden = true
        }
    }
}

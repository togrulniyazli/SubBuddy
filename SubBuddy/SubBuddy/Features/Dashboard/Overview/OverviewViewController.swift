//
//  OverviewViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit
import SnapKit

final class OverviewViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let viewModel = OverviewViewModel()
    private var categories: [AppCategory] = AppCategory.allCases
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Discover"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let notificationButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "bag.fill"), for: .normal)
        btn.tintColor = .label
        btn.backgroundColor = UIColor.systemGray5
        btn.layer.cornerRadius = 22
        return btn
    }()
    
    private let cartBadgeLabel: UILabel = {
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
        sb.placeholder = "Search apps"
        sb.searchBarStyle = .minimal
        sb.autocapitalizationType = .none
        return sb
    }()
    
    private let bestSellerLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Seller"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See All", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.setTitleColor(UIColor(named: "appPrimaryColor"), for: .normal)
        return btn
    }()
    
    private let promoCollectionView = PromoCollectionView()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No apps found"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    private lazy var appsCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let itemWidth = (UIScreen.main.bounds.width - totalSpacing) / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing, bottom: 16, right: spacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.keyboardDismissMode = .onDrag
        cv.isScrollEnabled = false
        cv.register(AppCell.self, forCellWithReuseIdentifier: AppCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        searchBar.delegate = self
        
        setupUI()
        setupConstraints()
        bindViewModel()
        viewModel.selectCategory(.all)
        
        seeAllButton.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
        
        hideKeyboardOnTap()
        
        promoCollectionView.onPromoTap = { [weak self] index in
            self?.openPromo(index: index)
        }
        
    }
    
    private func openPromo(index: Int) {
        
        guard let tabBar = self.tabBarController else { return }
        
        tabBar.selectedIndex = 1
        
        if let nav = tabBar.viewControllers?[1] as? UINavigationController,
           let promoVC = nav.viewControllers.first as? PromoViewController {
            
            promoVC.selectedPromoIndex = index
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateCartBadge()
    }
    
    @objc private func cartTapped() {
        let vc = CartViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateCartBadge() {
        let count = CartManager.shared.items.count
        if count == 0 {
            cartBadgeLabel.isHidden = true
            return
        }
        cartBadgeLabel.isHidden = false
        cartBadgeLabel.text = "\(count)"
    }
    
    private func updateCollectionHeight() {
        
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (UIScreen.main.bounds.width - totalSpacing) / 2
        let cellHeight = width * 1.5
        
        let count = viewModel.numberOfItems()
        let rows = ceil(CGFloat(count) / 2.0)
        let height = rows * cellHeight + (rows - 1) * spacing + 32
        
        appsCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
        
        view.layoutIfNeeded()
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(notificationButton)
        notificationButton.addSubview(cartBadgeLabel)
        contentView.addSubview(searchBar)
        contentView.addSubview(promoCollectionView)
        contentView.addSubview(bestSellerLabel)
        contentView.addSubview(seeAllButton)
        contentView.addSubview(categoryCollectionView)
        contentView.addSubview(appsCollectionView)
        contentView.addSubview(emptyLabel)
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
        
        notificationButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerLabel)
            make.right.equalToSuperview().inset(16)
            make.width.height.equalTo(44)
        }
        
        cartBadgeLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationButton).offset(-4)
            make.right.equalTo(notificationButton).offset(4)
            make.width.height.greaterThanOrEqualTo(20)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
        
        promoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(180)
        }
        
        bestSellerLabel.snp.makeConstraints { make in
            make.top.equalTo(promoCollectionView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        seeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(bestSellerLabel)
            make.right.equalToSuperview().inset(16)
        }
        
        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(bestSellerLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        appsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(contentView)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    private func bindViewModel() {
        
        viewModel.onUpdate = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                self.appsCollectionView.reloadData()
                self.appsCollectionView.layoutIfNeeded()
                self.updateCollectionHeight()
                self.categoryCollectionView.reloadData()
                
                if let index = self.categories.firstIndex(of: self.viewModel.selectedCategory) {
                    
                    let indexPath = IndexPath(item: index, section: 0)
                    
                    self.categoryCollectionView.selectItem(
                        at: indexPath,
                        animated: true,
                        scrollPosition: .centeredHorizontally
                    )
                    
                    self.categoryCollectionView.scrollToItem(
                        at: indexPath,
                        at: .centeredHorizontally,
                        animated: true
                    )
                }
                
                let isEmpty = self.viewModel.numberOfItems() == 0
                self.emptyLabel.isHidden = !isEmpty
                self.appsCollectionView.isHidden = isEmpty
            }
        }
    }
    
    private func hideKeyboardOnTap() {
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboardTapped)
        )
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTapped() {
        
        guard searchBar.isFirstResponder else { return }
        
        view.endEditing(true)
        
        if searchBar.text?.isEmpty ?? true {
            restoreLayout()
        }
    }
    
    private func restoreLayout() {
        
        promoCollectionView.isHidden = false
        bestSellerLabel.isHidden = false
        seeAllButton.isHidden = false
        
        categoryCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(bestSellerLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        appsCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(contentView)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.appsCollectionView.reloadData()
            self.updateCollectionHeight()
        }
    }
    
    @objc private func seeAllTapped() {
        
        let apps = viewModel.bestSellerApps()
        let vc = BestSellerViewController(apps: apps)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func searchLayout() {
        
        promoCollectionView.isHidden = true
        bestSellerLabel.isHidden = true
        seeAllButton.isHidden = true
        
        categoryCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        appsCollectionView.snp.remakeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalTo(contentView)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.appsCollectionView.reloadData()
            self.updateCollectionHeight()
        }
    }
}



extension OverviewViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        }
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CategoryCell.identifier,
                for: indexPath
            ) as! CategoryCell
            
            let category = categories[indexPath.item]
            let isSelected = category == viewModel.selectedCategory
            cell.configure(with: category, isSelected: isSelected)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppCell.identifier,
            for: indexPath
        ) as! AppCell
        
        let app = viewModel.app(at: indexPath.item)
        cell.configure(with: app)
        
        return cell
    }
}

extension OverviewViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == categoryCollectionView {
            let category = categories[indexPath.item]
            
            viewModel.selectCategory(category)
            
            categoryCollectionView.reloadData()
            appsCollectionView.reloadData()
            appsCollectionView.layoutIfNeeded()
            updateCollectionHeight()
            
            return
        }
        
        if collectionView == appsCollectionView {
            let app = viewModel.app(at: indexPath.item)
            let vc = AppDetailViewController(app: app)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension OverviewViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty ?? true) {
            searchLayout()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearch(text: searchText)
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            restoreLayout()
        } else {
            searchLayout()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text?.isEmpty ?? true {
            restoreLayout()
        }
    }
}

extension OverviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            let text = categories[indexPath.item].rawValue
            let width = text.size(withAttributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .medium)
            ]).width + 40
            
            return CGSize(width: width, height: 40)
        }
        
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (UIScreen.main.bounds.width - totalSpacing) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
}

//
//  CartViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 06.03.26.
//

import UIKit
import SnapKit

final class CartViewController: UIViewController {
    
    
    private let viewModel = CartViewModel.shared
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let emptyLabel: UILabel = {
        let l = UILabel()
        l.text = "Your cart is empty"
        l.font = .systemFont(ofSize: 18, weight: .semibold)
        l.textAlignment = .center
        l.textColor = .secondaryLabel
        l.isHidden = true
        return l
    }()
    
    private let recommendedLabel: UILabel = {
        let l = UILabel()
        l.text = "Recommended for you"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        return l
    }()
    
    private let recommendedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let bottomBar = UIView()
    
    private let allItemCheck: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "square"), for: .normal)
        return b
    }()
    
    private let allItemLabel: UILabel = {
        let l = UILabel()
        l.text = "All Item"
        return l
    }()
    
    private let checkoutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Checkout", for: .normal)
        btn.backgroundColor = UIColor(named: "appPrimaryColor")
        btn.tintColor = .white
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Cart"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupCollection()
        
        allItemCheck.addTarget(self,
                               action: #selector(selectAllTapped),
                               for: .touchUpInside)
        
        checkoutButton.addTarget(self,
                                 action: #selector(checkoutTapped),
                                 for: .touchUpInside)
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadUI()
            }
        }
        
        reloadUI()
    }
    
    
    @objc private func checkoutTapped() {
        
        let selectedItems = viewModel.selectedItems
        
        guard !selectedItems.isEmpty else {
            let alert = UIAlertController(
                title: "No Apps Selected",
                message: "Please select at least one app to continue checkout.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            
            return
        }
        
        let vc = CheckoutViewController(items: selectedItems)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func reloadUI() {
        
        itemsCollectionView.reloadData()
        
        let isEmpty = viewModel.itemCount == 0
        
        emptyLabel.isHidden = !isEmpty
        itemsCollectionView.isHidden = isEmpty
        
        updateSelectAllUI()
    }
    
    
    @objc private func selectAllTapped() {
        
        if viewModel.allSelected {
            viewModel.clearSelection()
        } else {
            viewModel.selectAll()
        }
        updateSelectAllUI()
    }
    
    private func updateSelectAllUI() {
        let imageName = viewModel.allSelected
        ? "checkmark.square.fill"
        : "square"
        
        allItemCheck.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        view.addSubview(bottomBar)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(itemsCollectionView)
        contentView.addSubview(emptyLabel)
        contentView.addSubview(recommendedLabel)
        contentView.addSubview(recommendedCollectionView)
        
        bottomBar.addSubview(allItemCheck)
        bottomBar.addSubview(allItemLabel)
        bottomBar.addSubview(checkoutButton)
    }
    
    
    private func setupCollection() {
        
        itemsCollectionView.backgroundColor = .clear
        recommendedCollectionView.backgroundColor = .clear
        
        itemsCollectionView.register(
            CartItemCell.self,
            forCellWithReuseIdentifier: CartItemCell.identifier
        )
        
        recommendedCollectionView.register(
            RecommendedAppCell.self,
            forCellWithReuseIdentifier: RecommendedAppCell.identifier
        )
        
        itemsCollectionView.dataSource = self
        itemsCollectionView.delegate = self
        
        recommendedCollectionView.dataSource = self
        recommendedCollectionView.delegate = self
    }
    
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        bottomBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(90)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        itemsCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(360)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(itemsCollectionView)
        }
        
        recommendedLabel.snp.makeConstraints { make in
            make.top.equalTo(itemsCollectionView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        recommendedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendedLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(160)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        allItemCheck.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        allItemLabel.snp.makeConstraints { make in
            make.left.equalTo(allItemCheck.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
    }
}


extension CartViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if collectionView == itemsCollectionView {
            return viewModel.itemCount
        }
        
        return MockApps.all.count
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        
        if collectionView == itemsCollectionView {
            
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CartItemCell.identifier,
                for: indexPath
            ) as? CartItemCell else { return UICollectionViewCell() }
            
            let item = viewModel.item(at: indexPath.row)
            
            cell.configure(with: item)
            cell.setChecked(viewModel.isSelected(at: indexPath.row))
            
            cell.onRemove = { [weak self] in
                self?.viewModel.removeApp(at: indexPath.row)
            }
            
            cell.onCheck = { [weak self] in
                self?.viewModel.toggleSelect(at: indexPath.row)
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RecommendedAppCell.identifier,
            for: indexPath
        ) as? RecommendedAppCell else {
            return UICollectionViewCell()
        }
        
        let app = MockApps.all[indexPath.row]
        cell.configure(with: app)
        
        return cell
    }
}


extension CartViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == itemsCollectionView {
            return CGSize(width: UIScreen.main.bounds.width - 32, height: 120)
        }
        
        return CGSize(width: 120, height: 140)
    }
}


extension CartViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == recommendedCollectionView {
            
            let app = MockApps.all[indexPath.row]
            let vc = AppDetailViewController(app: app)
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

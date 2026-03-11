//
//  MySubViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import UIKit
import SnapKit

final class MySubViewController: UIViewController {
    
    
    private let viewModel = MySubViewModel()
    
    
    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search subscriptions..."
        sb.searchBarStyle = .minimal
        return sb
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You don’t have any subscriptions yet."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My Subscriptions"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupCollection()
        
        searchBar.delegate = self
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.reloadUI()
            }
        }
        
        MySubManager.shared.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.viewModel.reload()
            }
        }
        
        reloadUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reload()
    }
    
    
    private func setupUI() {
        
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(emptyLabel)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(hideKeyboard)
        )
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    private func setupConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.right.equalToSuperview().inset(40)
        }
    }
    
    
    private func setupCollection() {
        
        collectionView.backgroundColor = .clear
        
        collectionView.register(
            SubscriptionCell.self,
            forCellWithReuseIdentifier: SubscriptionCell.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func reloadUI() {
        
        collectionView.reloadData()
        
        if viewModel.totalCount == 0 {
            
            emptyLabel.text = "You don’t have any subscriptions yet."
            emptyLabel.isHidden = false
            collectionView.isHidden = true
            return
        }
        
        if viewModel.count == 0 {
            
            emptyLabel.text = "No subscriptions found."
            emptyLabel.isHidden = false
            collectionView.isHidden = true
            return
        }
        
        emptyLabel.isHidden = true
        collectionView.isHidden = false
    }
    
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}

extension MySubViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {viewModel.count}
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SubscriptionCell.identifier,
            for: indexPath
        ) as? SubscriptionCell else {
            return UICollectionViewCell()
        }
        
        let item = viewModel.item(at: indexPath.row)
        
        cell.configure(with: item)
        
        return cell
    }
}

extension MySubViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        
        let sub = viewModel.item(at: indexPath.row)
        
        if sub.isEndingSoon {

                let alert = UIAlertController(
                    title: "Subscription Ending",
                    message: "This subscription is already ending.",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .default
                ))

                present(alert, animated: true)

                return
            }
        
        let sheet = UIAlertController(
            title: sub.app.name,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        sheet.addAction(UIAlertAction(
            title: "Stop Subscription",
            style: .destructive
        ) { [weak self] _ in
            
            guard let self = self else { return }
            
            MySubManager.shared.stopSubscription(for: sub.app)
            
            self.viewModel.reload()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        
        sheet.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        
        present(sheet, animated: true)
    }
}

extension MySubViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: view.frame.width - 32, height: 170)
    }
}

extension MySubViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar,textDidChange searchText: String) {
        
        viewModel.search(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

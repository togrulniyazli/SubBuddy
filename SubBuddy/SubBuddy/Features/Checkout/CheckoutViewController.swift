//
//  CheckoutViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 07.03.26.
//

import UIKit
import SnapKit

final class CheckoutViewController: UIViewController {
    
    private let viewModel: CheckoutViewModel
    
    init(items: [CartItem]) {
        self.viewModel = CheckoutViewModel(items: items)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let dividerView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        return v
    }()
    
    private let paymentLabel: UILabel = {
        let l = UILabel()
        l.text = "Payment Methods"
        l.font = .systemFont(ofSize: 22, weight: .bold)
        return l
    }()
    
    private let paymentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private let totalLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 26, weight: .bold)
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
    
    private var selectedPaymentIndex: Int?
    
    private let cardNumbers: [String] = [
        "**** **** **** \(Int.random(in: 1000...9999))",
        "**** **** **** \(Int.random(in: 1000...9999))"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Checkout"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        setupCollection()
        
        checkoutButton.addTarget(self,
                                 action: #selector(checkoutTapped),
                                 for: .touchUpInside)
        
        updateTotalPrice()
    }
    
    private func setupUI() {
        
        view.addSubview(appsCollectionView)
        view.addSubview(dividerView)
        view.addSubview(paymentLabel)
        view.addSubview(paymentCollectionView)
        view.addSubview(totalLabel)
        view.addSubview(checkoutButton)
    }
    
    private func setupCollection() {
        
        appsCollectionView.backgroundColor = .clear
        paymentCollectionView.backgroundColor = .clear
        
        appsCollectionView.register(
            CheckoutItemCell.self,
            forCellWithReuseIdentifier: CheckoutItemCell.identifier
        )
        
        paymentCollectionView.register(
            PaymentMethodCell.self,
            forCellWithReuseIdentifier: PaymentMethodCell.identifier
        )
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        paymentCollectionView.dataSource = self
        paymentCollectionView.delegate = self
    }
    
    private func updateTotalPrice() {
        totalLabel.text = String(format: "$%.2f", viewModel.totalPrice)
    }
    
    @objc
    private func checkoutTapped() {
        
        if viewModel.items.isEmpty {
            let alert = UIAlertController(
                title: "Cart Empty",
                message: "Please select apps from cart.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        if selectedPaymentIndex == nil {
            let alert = UIAlertController(
                title: "Select Payment Method",
                message: "Please choose a card to continue.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        for item in viewModel.items {
            if MySubManager.shared.contains(app: item.app) {
                let alert = UIAlertController(
                    title: "Already Subscribed",
                    message: "\(item.app.name) is already in your subscriptions.",
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
                
                return
            }
        }
        
        MySubManager.shared.addSubscriptions(viewModel.items)
        
        CartManager.shared.removeItems(viewModel.items)
        
        let alert = UIAlertController(
            title: "Subscription Activated",
            message: "Your subscription has been activated. Please check the MySub section for details.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            
            self.navigationController?.popToRootViewController(animated: true)
            self.tabBarController?.selectedIndex = 2
        })
        
        present(alert, animated: true)
    }
    
    private func setupConstraints() {
        
        appsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(300)
        }
        
        dividerView.snp.makeConstraints { make in
            make.top.equalTo(appsCollectionView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        paymentLabel.snp.makeConstraints { make in
            make.top.equalTo(dividerView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
        }
        
        paymentCollectionView.snp.makeConstraints { make in
            make.top.equalTo(paymentLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(160)
        }
        
        totalLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
        }
        
        checkoutButton.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(160)
            make.height.equalTo(50)
        }
    }
}

extension CheckoutViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,numberOfItemsInSection section: Int) -> Int {
        if collectionView == appsCollectionView {
            return viewModel.items.count
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath)-> UICollectionViewCell {
        if collectionView == appsCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CheckoutItemCell.identifier,
                for: indexPath
            ) as? CheckoutItemCell else { return UICollectionViewCell() }
            
            let item = viewModel.items[indexPath.row]
            
            cell.configure(with: item)
            
            cell.onRemove = { [weak self] in
                guard let self else { return }
                
                self.viewModel.removeItem(at: indexPath.row)
                self.appsCollectionView.reloadData()
                self.updateTotalPrice()
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentMethodCell.identifier,
            for: indexPath
        ) as? PaymentMethodCell else { return UICollectionViewCell() }
        
        let type = indexPath.row == 0 ? "visa" : "masterCard"
        
        cell.configure(
            type: type,
            number: cardNumbers[indexPath.row],
            selected: selectedPaymentIndex == indexPath.row
        )
        
        return cell
    }
}

extension CheckoutViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAt indexPath: IndexPath) {
        if collectionView == paymentCollectionView {
            
            selectedPaymentIndex = indexPath.row
            paymentCollectionView.reloadData()
        }
    }
}

extension CheckoutViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath)-> CGSize {
        if collectionView == appsCollectionView {
            return CGSize(width: view.frame.width - 32, height: 90)
        }
        
        return CGSize(width: view.frame.width - 32, height: 70)
    }
}

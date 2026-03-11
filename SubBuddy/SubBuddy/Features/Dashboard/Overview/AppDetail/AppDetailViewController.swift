//
//  AppDetailViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 05.03.26.
//

import UIKit
import SnapKit
import Kingfisher

final class AppDetailViewController: UIViewController {
    
    private let viewModel: AppDetailViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    private let heroIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 28, weight: .bold)
        l.textColor = .label
        return l
    }()
    
    private let ratingPill: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .semibold)
        l.textAlignment = .center
        l.backgroundColor = .systemGray6
        l.layer.cornerRadius = 12
        l.clipsToBounds = true
        return l
    }()
    
    private let reviewsLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 14, weight: .medium)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let descriptionLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 15)
        l.numberOfLines = 0
        return l
    }()
    
    private let planStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 12
        sv.distribution = .fillEqually
        return sv
    }()
    
    private let standardButton = UIButton(type: .system)
    private let familyButton = UIButton(type: .system)
    private let studentButton = UIButton(type: .system)
    
    private let priceContainer = UIView()
    
    private let oldPriceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.textColor = .secondaryLabel
        return l
    }()
    
    private let priceLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 28, weight: .bold)
        return l
    }()
    
    private let addToCartButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add To Cart", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        btn.tintColor = .white
        btn.backgroundColor = UIColor(named: "appPrimaryColor") ?? .systemRed
        btn.layer.cornerRadius = 14
        return btn
    }()
    
    init(app: AppModel) {
        self.viewModel = AppDetailViewModel(app: app)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupConstraints()
        configure()
        
        applyPlanSelectionUI()
        updatePriceUI()
        refreshSubscriptionState()
        
        addToCartButton.addTarget(self,
                                  action: #selector(addToCartTapped),
                                  for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshSubscriptionState()
    }
    
    private func refreshSubscriptionState() {
        
        if MySubManager.shared.contains(app: viewModel.app) {
            
            addToCartButton.setTitle("Subscribed", for: .normal)
            addToCartButton.backgroundColor = .systemGray
            addToCartButton.isEnabled = false
            
            return
        }
        
        if CartManager.shared.contains(app: viewModel.app) {
            
            addToCartButton.setTitle("In Cart", for: .normal)
            addToCartButton.backgroundColor = .systemGray
            addToCartButton.isEnabled = false
            
            return
        }
        
        
        addToCartButton.setTitle("Add To Cart", for: .normal)
        addToCartButton.backgroundColor = UIColor(named: "appPrimaryColor")
        addToCartButton.isEnabled = true
    }
    
    
    @objc private func addToCartTapped() {
        
        if MySubManager.shared.contains(app: viewModel.app) {
            let alert = UIAlertController(
                title: "Already Subscribed",
                message: "You already have an active subscription for this app.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let added = CartManager.shared.add(
            app: viewModel.app,
            plan: viewModel.selectedPlan,
            price: viewModel.currentPrice()
        )
        
        if !added {
            let alert = UIAlertController(
                title: "Already in Cart",
                message: "This app is already in your cart.",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(
            title: "Added to Cart",
            message: "\(viewModel.app.name) added to your cart",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        view.addSubview(priceContainer)
        
        scrollView.addSubview(contentView)
        
        contentView.addSubview(heroImageView)
        heroImageView.addSubview(heroIconView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(ratingPill)
        contentView.addSubview(reviewsLabel)
        contentView.addSubview(descriptionLabel)
        
        contentView.addSubview(planStackView)
        
        planStackView.addArrangedSubview(standardButton)
        planStackView.addArrangedSubview(familyButton)
        planStackView.addArrangedSubview(studentButton)
        
        priceContainer.addSubview(oldPriceLabel)
        priceContainer.addSubview(priceLabel)
        priceContainer.addSubview(addToCartButton)
        
        scrollView.alwaysBounceVertical = true
        
        setupPlanButton(standardButton, title: "Standard", action: #selector(standardTapped))
        setupPlanButton(familyButton, title: "Family", action: #selector(familyTapped))
        setupPlanButton(studentButton, title: "Student", action: #selector(studentTapped))
    }
    
    private func setupPlanButton(_ button: UIButton, title: String, action: Selector) {
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.addTarget(self, action: action, for: .touchUpInside)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(priceContainer.snp.top)
        }
        
        priceContainer.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        heroImageView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(260)
        }
        
        heroIconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(64)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        ratingPill.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.left.equalTo(titleLabel.snp.right).offset(12)
            make.height.equalTo(24)
        }
        
        reviewsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewsLabel.snp.bottom).offset(14)
            make.left.right.equalToSuperview().inset(16)
        }
        
        planStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(24)
        }
        
        oldPriceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(oldPriceLabel.snp.bottom).offset(4)
            make.left.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
        }
        
        addToCartButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(52)
            make.width.equalTo(190)
        }
    }
    
    
    private func configure() {
        
        titleLabel.text = viewModel.titleText
        ratingPill.text = viewModel.ratingText
        reviewsLabel.text = viewModel.reviewsText
        descriptionLabel.text = viewModel.descriptionText
        
        heroIconView.kf.setImage(with: URL(string: viewModel.app.iconURL))
    }
    
    
    private func applyPlanSelectionUI() {
        let selectedColor = UIColor(named: "appPrimaryColor") ?? .systemRed
        func style(_ button: UIButton, selected: Bool) {
            if selected {
                button.backgroundColor = selectedColor
                button.setTitleColor(.white, for: .normal)
                button.layer.borderColor = UIColor.clear.cgColor
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.label, for: .normal)
                button.layer.borderColor = UIColor.label.cgColor
            }
        }
        
        style(standardButton, selected: viewModel.selectedPlan == .standard)
        style(familyButton, selected: viewModel.selectedPlan == .family)
        style(studentButton, selected: viewModel.selectedPlan == .student)
    }
    
    private func updatePriceUI() {
        let price = viewModel.currentPrice()
        priceLabel.text = "$\(String(format: "%.2f", price))"
        if viewModel.shouldShowOriginalPrice() {
            let original = viewModel.originalPrice()
            let attr = NSAttributedString(
                string: "$\(String(format: "%.2f", original))",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            
            oldPriceLabel.attributedText = attr
            oldPriceLabel.isHidden = false
        } else {
            
            oldPriceLabel.isHidden = true
        }
    }
    
    @objc private func standardTapped() {
        viewModel.selectPlan(.standard)
        applyPlanSelectionUI()
        updatePriceUI()
    }
    
    @objc private func familyTapped() {
        viewModel.selectPlan(.family)
        applyPlanSelectionUI()
        updatePriceUI()
    }
    
    @objc private func studentTapped() {
        viewModel.selectPlan(.student)
        applyPlanSelectionUI()
        updatePriceUI()
    }
}

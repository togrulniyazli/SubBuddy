//
//  OverviewViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 28.02.26.
//

import UIKit
import SnapKit

final class OverviewViewController: UIViewController {

    private let viewModel = OverviewViewModel()
    private var categories: [AppCategory] = AppCategory.allCases


    private let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search apps"
        sb.searchBarStyle = .minimal
        sb.autocapitalizationType = .none
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


    private lazy var categoryCollectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.register(CategoryCell.self,
                    forCellWithReuseIdentifier: CategoryCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()


    private lazy var appsCollectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

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
        cv.register(AppCell.self,
                    forCellWithReuseIdentifier: AppCell.identifier)
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
        hideKeyboardOnTap()
    }


    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(categoryCollectionView)
        view.addSubview(appsCollectionView)
        view.addSubview(emptyLabel)
    }

    private func setupConstraints() {

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview().inset(12)
        }

        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }

        appsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview()
        }

        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            guard let self = self else { return }

            self.appsCollectionView.reloadData()

            let isEmpty = self.viewModel.numberOfItems() == 0
            self.emptyLabel.isHidden = !isEmpty
            self.appsCollectionView.isHidden = isEmpty
        }
    }


    private func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboardTapped))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboardTapped() {
        view.endEditing(true)
    }
}
extension OverviewViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        if collectionView == categoryCollectionView {
            return categories.count
        }

        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        if collectionView == categoryCollectionView {
            view.endEditing(true)
            let category = categories[indexPath.item]
            viewModel.selectCategory(category)
            categoryCollectionView.reloadData()
        }
    }
}
extension OverviewViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

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
extension OverviewViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearch(text: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//
//  BestSellerViewController.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 04.03.26.
//

import UIKit
import SnapKit

final class BestSellerViewController: UIViewController {
    
    private let apps: [AppModel]
    
    init(apps: [AppModel]) {
        self.apps = apps
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 16
        let totalSpacing = spacing * 3
        let width = (UIScreen.main.bounds.width - totalSpacing) / 2
        
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing, bottom: 16, right: spacing)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(AppCell.self,
                    forCellWithReuseIdentifier: AppCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Best Sellers"
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension BestSellerViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        let app = apps[indexPath.item]
        
        let vc = AppDetailViewController(app: app)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BestSellerViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AppCell.identifier,
            for: indexPath
        ) as! AppCell
        
        let app = apps[indexPath.item]
        cell.configure(with: app)
        
        return cell
    }
}

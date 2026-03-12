//
//  PromoCollectionView.swift
//  SubBuddy
//
//  Created by Toğrul Niyazlı on 02.03.26.
//

import UIKit
import SnapKit

final class PromoCollectionView: UIView {
    
    var onPromoTap: ((Int) -> Void)?
    
    private var promos: [PromoModel] = [
        PromoModel(
            title: "Welcoming Offer!",
            buttonTitle: "Discover More",
            imageName: "promo1"
        ),
        PromoModel(
            title: "Save on Premium",
            buttonTitle: "Learn More",
            imageName: "promo2"
        )
    ]
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear
        cv.isPagingEnabled = true
        cv.register(PromoCell.self,
                    forCellWithReuseIdentifier: PromoCell.identifier)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) { fatalError() }
}

extension PromoCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        promos.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PromoCell.identifier,
            for: indexPath
        ) as! PromoCell
        
        cell.configure(with: promos[indexPath.item])
        
        cell.onButtonTap = { [weak self] in
            self?.onPromoTap?(indexPath.item)
        }
        
        return cell
    }
}
extension PromoCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: UIScreen.main.bounds.width - 64,
            height: 180
        )
    }
}

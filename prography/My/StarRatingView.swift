//
//  StarRateFillterView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class StarRatingView: UIView {
    
    private lazy var containerStackView = UIStackView(
        arrangedSubviews: [selectedStarRatingView, fillterView]
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.isUserInteractionEnabled = true

    }
    
    private lazy var selectedStarRatingView = SelectedStarRatingView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectedStarRatingViewDidTap))
        $0.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - Fillter(All 버튼 클릭시 노출되는 필터)
    
    private lazy var fillterView = FillterView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.starRateFillterCollectionView.delegate = self
        $0.isHidden = true
    }
    
    init() {
        super.init(frame: .zero)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StarRatingView {
    
    func configureLayout() {
        let selectedStarRatingViewLayoutConstraints: [NSLayoutConstraint] = [
            selectedStarRatingView.heightAnchor.constraint(equalToConstant: 64)
        ]
        
        NSLayoutConstraint.activate(selectedStarRatingViewLayoutConstraints)
        
        addSubview(containerStackView)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.topAnchor.constraint(equalTo: topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
    }
    
    @objc func selectedStarRatingViewDidTap() {
        fillterView.isHidden.toggle()
    }
}

extension StarRatingView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        fillterView.isHidden = true
        let starRate = collectionView.cellForItem(at: indexPath)?.tag
        selectedStarRatingView.starRate = starRate!
    }
}

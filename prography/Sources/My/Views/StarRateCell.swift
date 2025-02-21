//
//  StarRateCell.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class StarRateCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private var allFillterButtonDescriptionLabel = UILabel().configure {
        $0.font = .pretendard(size: 16, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "All"
        $0.textColor = .black
        $0.isHidden = true
    }
    
    private var starStackView = UIStackView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = 4
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(starRate: Int) {
        
        guard starRate != -1 else {
            allFillterButtonDescriptionLabel.isHidden = false
            starStackView.isHidden = true
            return
        }
        
        Array(0...4).forEach { _ in
            starStackView.addArrangedSubview(StarImageView(isFilled: false))
        }
        starStackView.addArrangedSubview(UIView())
        guard starRate != 0 else {
            return
        }
        
        for i in 1...5 {
            if i <= starRate {
                (starStackView.arrangedSubviews[i - 1] as? StarImageView)?.isFilled = true
            }
        }
    }
}

// MARK: - Helper

private extension StarRateCell {
    
    func configureLayout() {
        contentView.addSubview(starStackView)
        
        let starStackViewLayoutConstraints: [NSLayoutConstraint] = [
            starStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            starStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            starStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(starStackViewLayoutConstraints)
        
        contentView.addSubview(allFillterButtonDescriptionLabel)
        
        let allFillterButtonDescriptionLabelLayoutConstraints: [NSLayoutConstraint] = [
            allFillterButtonDescriptionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            allFillterButtonDescriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            allFillterButtonDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ]
        NSLayoutConstraint.activate(allFillterButtonDescriptionLabelLayoutConstraints)
    }
}

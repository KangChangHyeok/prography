//
//  SelectedStarRateView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class SelectedStarRatingView: UIView {
    
    private lazy var containerStackView = UIStackView(arrangedSubviews: [allFillterLabel, starRateView]).configure {
        $0.axis = .horizontal
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alignment = .center
    }
    
    private let allFillterLabel = UILabel().configure {
        $0.text = "All"
        $0.font = .pretendard(size: 16, weight: .bold)
        $0.textColor = .black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let starRateView = StarRateView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = false
    }
    
    private let menuImageView = UIImageView().configure {
        $0.image = .init(named: "Menu")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var starRate = -1 {
        didSet {
            set(starRate)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureLayout()
        set(-1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.masksToBounds = true
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        backgroundColor = .white
    }
    
    private func configureLayout() {
        addSubview(menuImageView)
        
        let menuImageViewLayoutConstraints: [NSLayoutConstraint] = [
            menuImageView.heightAnchor.constraint(equalToConstant: 24),
            menuImageView.widthAnchor.constraint(equalToConstant: 24),
            menuImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            menuImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(menuImageViewLayoutConstraints)
        
        addSubview(containerStackView)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            containerStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerStackView.trailingAnchor.constraint(lessThanOrEqualTo: menuImageView.leadingAnchor),
            containerStackView.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
        
    }
    
    func set(_ starRate: Int) {
        guard starRate != -1 else {
            allFillterLabel.isHidden = false
            starRateView.isHidden = true
            return
        }
        allFillterLabel.isHidden = true
        starRateView.isHidden = false
        starRateView.set(rate: starRate)
    }
}

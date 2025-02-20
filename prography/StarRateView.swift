//
//  StarRateView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class StarRateView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = 4
        self.axis = .horizontal
        for _ in 1...5 {
            self.addArrangedSubview(StarImageView(isFilled: false))
        }
    }
    
    func set(rate: Int) {
        self.arrangedSubviews.enumerated().forEach { index, view in
            if rate == 0 {
                (view as? StarImageView)?.isFilled = false
            }
            
            if index <= rate - 1 {
                (view as? StarImageView)?.isFilled = true
            } else {
                (view as? StarImageView)?.isFilled = false
            }
        }
    }
    
    func set(width: CGFloat, height: CGFloat) {
        for index in 0...4 {
            (self.arrangedSubviews[index] as? StarImageView)?.size = CGSize(width: width, height: height)
        }
    }
    
    func set(image: UIImage?) {
        for index in 0...4 {
            (self.arrangedSubviews[index] as? StarImageView)?.starImage = image
        }
    }
}

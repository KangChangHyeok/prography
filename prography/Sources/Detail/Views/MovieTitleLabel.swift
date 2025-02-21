//
//  MovieTitleLabel.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class MovieTitleLabel: UILabel {
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(title: String, rate: Double) {
        let attributedString = NSMutableAttributedString(string: title + "/ \(rate)")
        attributedString.addAttribute(.font, value: UIFont.pretendard(size: 45, weight: .bold), range: (title as NSString).range(of: title))
        attributedString.addAttribute(.font, value: UIFont.pretendard(size: 16, weight: .semibold), range: (title as NSString).range(of: rate.description))
        self.attributedText = attributedString
    }
}


private extension MovieTitleLabel {
    
    func configure() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLines = 0
        self.textAlignment = .left
        self.textColor = .black
    }
}

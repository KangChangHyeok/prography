//
//  CategoryTabBar.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class CategoryTabBar: UIView {
    
    private lazy var containerStackView = UIStackView(
        arrangedSubviews: [nowPlayingButton, popularButton, topRatedButton]
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }
    
    var nowPlayingButton = UIButton().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .pretendard(size: 14, weight: .bold)
        $0.setTitleColor(.categoryUnSelected, for: .normal)
        $0.setTitleColor(.main, for: .selected)
        $0.setTitle("Now Playing", for: .normal)
        $0.isSelected = true
    }
    
    var popularButton = UIButton().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .pretendard(size: 14, weight: .bold)
        $0.setTitleColor(.categoryUnSelected, for: .normal)
        $0.setTitleColor(.main, for: .selected)
        $0.setTitle("Popular", for: .normal)
    }
    
    var topRatedButton = UIButton().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.titleLabel?.font = .pretendard(size: 14, weight: .bold)
        $0.setTitleColor(.categoryUnSelected, for: .normal)
        $0.setTitleColor(.main, for: .selected)
        $0.setTitle("Top Rated", for: .normal)
    }
    
    var highlightBar = UIView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .main
    }
    
    var highLightBarConstraints: [NSLayoutConstraint]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(containerStackView)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
        
        addSubview(highlightBar)
        
        let highlightBarLayoutConstraints: [NSLayoutConstraint] = [
            highlightBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            highlightBar.heightAnchor.constraint(equalToConstant: 3),
            highlightBar.centerXAnchor.constraint(equalTo: nowPlayingButton.centerXAnchor),
            highlightBar.widthAnchor.constraint(equalToConstant: 81)
        ]
        self.highLightBarConstraints = highlightBarLayoutConstraints
        NSLayoutConstraint.activate(highlightBarLayoutConstraints)
    }
}

#Preview {
    CategoryTabBar()
}

//
//  StarRateView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class StarRateView: UIStackView {
    
    var currentRate: Int = 0
    
    init(isEdit: Bool) {
        super.init(frame: .zero)
        configure(isEdit: isEdit)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(isEdit: Bool) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = 4
        self.axis = .horizontal
        for _ in 1...5 {
            self.addArrangedSubview(StarImageView(isFilled: false))
        }
        
        if isEdit {
            configureGesture()
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
    
    func set(isEdit: Bool) {
            self.isUserInteractionEnabled = isEdit
    }
    
    private func configureGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            self.addGestureRecognizer(tapGesture)
            self.isUserInteractionEnabled = true
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
            let touchLocation = gesture.location(in: self)
            
            // 터치한 별을 찾기
            for (index, view) in self.arrangedSubviews.enumerated() {
                if view.frame.contains(touchLocation) {
                    set(rate: index + 1)
                    self.currentRate = index + 1
                    break
                }
            }
        }
}

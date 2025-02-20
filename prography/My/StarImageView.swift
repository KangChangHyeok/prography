//
//  StarImageView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class StarImageView: UIImageView {
    
    var starImage: UIImage? {
        didSet {
            configure(image: starImage)
        }
    }
    
    var size: CGSize = .init(width: 16, height: 16) {
        didSet {
            configure(size: size)
        }
    }
    
    var isFilled: Bool = false {
        didSet {
            configure(isFilled: isFilled)
        }
    }
    
    init(isFilled: Bool) {
        super.init(frame: .zero)
        configure(filled: isFilled)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(filled: Bool) {
        self.image = filled ? .redStar : .grayStar
        self.translatesAutoresizingMaskIntoConstraints = false
        
        let layoutConstraints: [NSLayoutConstraint] = [
            self.widthAnchor.constraint(equalToConstant: 16),
            self.heightAnchor.constraint(equalToConstant: 16)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configure(isFilled: Bool) {
        self.image = isFilled ? .redStar : .grayStar
    }
    
    private func configure(size: CGSize) {
        
        NSLayoutConstraint.deactivate(self.constraints)
        
        let layoutConstraints: [NSLayoutConstraint] = [
            self.widthAnchor.constraint(equalToConstant: size.width),
            self.heightAnchor.constraint(equalToConstant: size.height)
        ]
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func configure(image: UIImage?) {
        self.image = image
    }
}

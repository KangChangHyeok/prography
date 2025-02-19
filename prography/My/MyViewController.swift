//
//  MyViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class MyViewController: UIViewController {
    
    private var starRatingView = StarRatingView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        configureLayout()
    }
}

private extension MyViewController {
    
    func configureLayout() {
        view.addSubview(starRatingView)
        
        let starRatingViewLayoutConstraints: [NSLayoutConstraint] = [
            starRatingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            starRatingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            starRatingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(starRatingViewLayoutConstraints)
    }
}

#Preview {
    MyViewController()
}

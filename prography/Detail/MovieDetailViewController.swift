//
//  MovieDetailViewController.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    private lazy var containerScrollView = UIScrollView().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
    }
    
    private var movieImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = .redStar
    }
    
    private lazy var movieImageGradientView = UIView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let bottomGradient = CAGradientLayer()
        bottomGradient.frame = .init(x: 0, y: 0, width: view.frame.width, height: 247)
        bottomGradient.colors = [
            UIColor.systemBackground.withAlphaComponent(0).cgColor,
            UIColor.movieImageBackground.cgColor
            ]
        $0.layer.addSublayer(bottomGradient)
    }
    
    private var movieStarRateView = StarRateView().configure {
        $0.set(width: 40, height: 40)
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let movieDescriptionView = MovieDescriptionView()
    
    private let commentView = CommentView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configure()
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.navigationItem.titleView = UIImageView(image: .init(named: "Logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonDidTap))
    }
    
    private func configureLayout() {
        
        containerScrollView.addSubview(movieImageGradientView)
        
        let movieImageGradientViewLayoutConstraints: [NSLayoutConstraint] = [
            movieImageGradientView.topAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.topAnchor),
            movieImageGradientView.leadingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.leadingAnchor),
            movieImageGradientView.trailingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.trailingAnchor),
            movieImageGradientView.heightAnchor.constraint(equalToConstant: 247)
        ]
        
        NSLayoutConstraint.activate(movieImageGradientViewLayoutConstraints)
        
        
        containerScrollView.addSubview(movieImageView)
        
        let movieImageViewLayoutConstraints: [NSLayoutConstraint] = [
            movieImageView.topAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.topAnchor),
            movieImageView.leadingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.leadingAnchor),
            movieImageView.trailingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.trailingAnchor),
            movieImageView.heightAnchor.constraint(equalToConstant: 247)
        ]
        
        NSLayoutConstraint.activate(movieImageViewLayoutConstraints)
        
        containerScrollView.addSubview(movieStarRateView)
        
        let movieStarRateViewLayoutConstraints: [NSLayoutConstraint] = [
            movieStarRateView.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 10),
            movieStarRateView.centerXAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.centerXAnchor)
        ]
        containerScrollView.addSubview(movieDescriptionView)
        
        NSLayoutConstraint.activate(movieStarRateViewLayoutConstraints)
        
        let movieDescriptionViewLayoutConstraints: [NSLayoutConstraint] = [
            movieDescriptionView.topAnchor.constraint(equalTo: movieStarRateView.bottomAnchor, constant: 23.5),
            movieDescriptionView.leadingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            movieDescriptionView.trailingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.trailingAnchor, constant: -16)
        ]
        
        NSLayoutConstraint.activate(movieDescriptionViewLayoutConstraints)
        
        containerScrollView.addSubview(commentView)
        
        let commentViewLayoutConstraints: [NSLayoutConstraint] = [
            commentView.topAnchor.constraint(equalTo: movieDescriptionView.bottomAnchor, constant: 13.5),
            commentView.leadingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.trailingAnchor),
            commentView.bottomAnchor.constraint(equalTo: containerScrollView.contentLayoutGuide.bottomAnchor ,constant: -10)
        ]
        
        NSLayoutConstraint.activate(commentViewLayoutConstraints)
        
        view.addSubview(containerScrollView)
        let containerScrollViewLayoutConstraints: [NSLayoutConstraint] = [
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            containerScrollView.contentLayoutGuide.widthAnchor.constraint(equalToConstant: view.frame.width)
        ]
        
        NSLayoutConstraint.activate(containerScrollViewLayoutConstraints)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        containerScrollView.setContentOffset(.init(x: 0, y: containerScrollView.contentSize.height - containerScrollView.bounds.height), animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 0 {
            view.endEditing(true)
        }
    }
}

#Preview {
    MovieDetailViewController()
}

//
//  MovieDetailViewController.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit
import Combine

final class MovieDetailViewController: UIViewController {
    
    private var viewModel: MovieDetailViewModel
    private var cancelables = Set<AnyCancellable>()
    
    private lazy var containerScrollView = UIScrollView().configure {
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
    }
    
    private var movieImageView = UIImageView().configure {
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false
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
    
    private var movieStarRateView = StarRateView(isEdit: true).configure {
        $0.set(width: 40, height: 40)
        $0.spacing = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let movieDescriptionView = MovieDescriptionView()
    
    private let commentView = CommentView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var menuButton = UIButton().configure {
        $0.setImage(.menu, for: .normal)
        $0.showsMenuAsPrimaryAction = true
        $0.menu = menu
    }
    
    lazy var editAction = UIAction(title: "수정하기", image: nil) { _ in
        print("📝 수정하기 선택됨")
    }
    
    lazy var deleteAction = UIAction(title: "삭제하기", image: nil, attributes: .destructive) { [weak self] _ in
        
        CoreDataManager.shared.deleteData(movieID: self?.viewModel.state.movieID ?? 0)
        self?.presentCheckAlert(title: "삭제되었습니다.", completion: { _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }
    
    lazy var menu = UIMenu(title: "", children: [editAction, deleteAction])
    
    
    
    init(viewModel: MovieDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configure()
        bindStates()
        viewModel.send(.viewDidLoad)
    }
    
    private func configure() {
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        self.navigationItem.titleView = UIImageView(image: .init(named: "Logo"))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonDidTap))
        tabBarController?.tabBar.isHidden = true
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
    
    func bindStates() {
        viewModel.state.$movieDetail
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetail in
                self?.bind(movieDetail)
            }
            .store(in: &cancelables)
        
        viewModel.state.$review
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] review in
                self?.bind(review)
            }
            .store(in: &cancelables)
    }
    
    func bind(_ movieDetail: MovieDetailDTO?) {
        guard let movieDetail else { return }
        let posterPathURL = URL(string: "https://image.tmdb.org/t/p/w200" + movieDetail.posterPath)
        
        Task {
            let (data, _) = try await URLSession.shared.data(from: posterPathURL!)
            let movieImage = UIImage(data: data)
            movieImageView.image = movieImage
        }
        
        movieDescriptionView.bind(title: movieDetail.title, rate: movieDetail.voteAverage / 2, genres: movieDetail.genres.map { $0.name }, description: movieDetail.overview)
    }
    
    func bind(_ review: Review?) {
        guard let review else { return }
        movieStarRateView.set(isEdit: false)
        movieStarRateView.set(rate: Int(review.rate))
        commentView.bind(review.comment, date: review.date)
        self.navigationItem.rightBarButtonItem = .init(customView: menuButton)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        containerScrollView.setContentOffset(.init(x: 0, y: containerScrollView.contentSize.height - containerScrollView.bounds.height), animated: true)
    }
    
    @objc private func saveButtonDidTap() {
        guard (commentView.commentTextView.text != "후기를 작성해주세요.") || (commentView.commentTextView.text.isEmpty != false) else {
            print("코멘트를 작성해 주세요.")
            return
        }
        
        CoreDataManager.shared.saveData(
            movieID: viewModel.state.movieID,
            movieImage: movieImageView.image?.pngData(),
            movieTitle: viewModel.state.movieDetail?.title,
            rate: Int(trunc(viewModel.state.movieDetail!.voteAverage / 2)),
            comment: commentView.commentTextView.text
        )
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.velocity(in: scrollView).y > 0 {
            view.endEditing(true)
        }
    }
}

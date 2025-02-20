//
//  MovieDescriptionView.swift
//  prography
//
//  Created by kangChangHyeok on 19/02/2025.
//

import UIKit

final class MovieDescriptionView: UIView {
    
    private let titleLabel = MovieTitleLabel().configure {
        $0.textColor = .black
        $0.set(title: "Title", rate: 4.8)
    }
    
    private lazy var genreCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: genreCollectionViewLayout()
    ).configure {
        $0.bounces = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }
    
    private var genreDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    private var descriptionLabel = UILabel().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 24
        paragraphStyle.maximumLineHeight = 24
        
        let attributedString = NSAttributedString(
            string: """
        너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자, 세계 수호 통합 부대(약칭 세.수.통)에 의해 극비 소집된다. 소중한 것을 잃은 분노와 복수심에 불타는 섀도우는 소닉의 초고속 스피드와 너클즈의 최강 펀치를 단 단숨에 제압해버린다. 세상을 지배하려는 닥터 로보트닉과 그의 할아버지 제럴드 박사는 섀도우의 엄청난 힘 카오스 에너지를 이용해 인류를 정복하려고 하는데… 너클즈, 테일즈와 함께 평화로운 일상을 보내던 초특급 히어로 소닉. 연구 시설에 50년간 잠들어 있던 사상 최강의 비밀 병기 \"섀도우\"가 탈주하자, 세계 수호 통합 부대(약칭 세.수.통)에 의해 극비 소집된다. 소중한 것을 잃은 분노와 복수심에 불타는 섀도우는 소닉의 초고속 스피드와 너클즈의 최강 펀치를 단 단숨에 제압해버린다. 세상을 지배하려는 닥터 로보트닉과 그의 할아버지 제럴드 박사는 섀도우의 엄청난 힘 카오스 에너지를 이용해 인류를 정복하려고 하는데…
        """,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: UIFont.pretendard(size: 16, weight: .medium)
            ]
        )
        $0.attributedText = attributedString
    }
    
    init() {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        configureLayout()
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func genreCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(40), heightDimension: .absolute(16))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 3.33
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureLayout() {
        self.addSubview(titleLabel)
        
        let titleLabelLayoutConstraints: [NSLayoutConstraint] = [
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(titleLabelLayoutConstraints)
        
        self.addSubview(genreCollectionView)
        
        let genreCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            genreCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            genreCollectionView.heightAnchor.constraint(equalToConstant: 16),
            genreCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(genreCollectionViewLayoutConstraints)
        
        self.addSubview(descriptionLabel)
        
        let descriptionLabelLayoutConstraints: [NSLayoutConstraint] = [
            descriptionLabel.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(descriptionLabelLayoutConstraints)
    }
    
    func configureDataSource() {
        let cellRegistaration = UICollectionView.CellRegistration<GenreCell, Int> { cell, indexPath, item in
            
        }
        
        genreDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: genreCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistaration, for: indexPath, item: itemIdentifier)
        })
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([0])
        snapShot.appendItems(Array(0..<4))
        genreDataSource.apply(snapShot)
    }
}


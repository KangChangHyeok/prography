//
//  ViewController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class HomeViewController: UIViewController {
    
    enum Metric {
        static let categoryTabBarHeight = CGFloat(64)
        static let pageHeight = Screen.height - (Screen.statusBarHeight + Screen.navigationBarHeight + Screen.tabBarHeight +  Screen.bottomInset + categoryTabBarHeight)
        static let floatingPointTolerance = 0.1
    }
    
    private lazy var outerScrollView = UIScrollView().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = false
        $0.delegate = self
    }
    
    private lazy var containerStackView = UIStackView(arrangedSubviews: [bannerCollectionView, categoryTabBar, pageViewController.view]).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private lazy var bannerCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: bannerCollectionViewLayout()
    ).configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
        $0.delegate = self
    }
    
    private var bannerDataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    private lazy var categoryTabBar = CategoryTabBar().configure {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.nowPlayingButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
        $0.popularButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
        $0.topRatedButton.addTarget(self, action: #selector(CategoryButtonDidTap), for: .touchUpInside)
    }
    
    private lazy var pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal).configure {
        $0.dataSource = self
        $0.delegate = self
        self.addChild($0)
        $0.willMove(toParent: self)
        $0.setViewControllers([pages[0]], direction: .forward, animated: false)
    }
    private lazy var categoryButtons = [categoryTabBar.nowPlayingButton, categoryTabBar.popularButton, categoryTabBar.topRatedButton]
    
    private var selectedCategoryTag = 0
    private var pages: [MovieListViewController] = [NowPlayingViewController(), PopularViewController(), TopRatedViewController()]
    
    private lazy var innerScrollViews = [pages[0].movieCollectionView, pages[1].movieCollectionView, pages[2].movieCollectionView]
    
    var innerScrollingDownDueToOuterScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureLayout()
        configureDataSource()
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapShot.appendSections([0])
        snapShot.appendItems(Array(0..<5))
        bannerDataSource.apply(snapShot, animatingDifferences: false)
        innerScrollViews.forEach {
            $0.delegate = self
        }
    }
}

private extension HomeViewController {
    
    func configureLayout() {
        view.addSubview(outerScrollView)
        
        let containerScrollViewLayoutConstraints: [NSLayoutConstraint] = [
            outerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            outerScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            outerScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            outerScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        outerScrollView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate(containerScrollViewLayoutConstraints)
        
        let containerStackViewLayoutConstraints: [NSLayoutConstraint] = [
            containerStackView.topAnchor.constraint(equalTo: outerScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: outerScrollView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: outerScrollView.contentLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: outerScrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
            
        ]
        
        NSLayoutConstraint.activate(containerStackViewLayoutConstraints)
        
        let bannerCollectionViewLayoutConstraints: [NSLayoutConstraint] = [
            bannerCollectionView.heightAnchor.constraint(equalToConstant: 221)
        ]
        NSLayoutConstraint.activate(bannerCollectionViewLayoutConstraints)
        
        let categoryTabBarLayoutConstraints: [NSLayoutConstraint] = [
            categoryTabBar.heightAnchor.constraint(equalToConstant: Metric.categoryTabBarHeight)
        ]
        NSLayoutConstraint.activate(categoryTabBarLayoutConstraints)
        
        print()
        
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let pageViewLayoutConstraints: [NSLayoutConstraint] = [
            pageViewController.view.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            pageViewController.view.heightAnchor.constraint(equalToConstant: Metric.pageHeight - 16)
        ]
        NSLayoutConstraint.activate(pageViewLayoutConstraints)
        
    }

    func bannerCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(316), heightDimension: .absolute(205))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 8, leading: 0, bottom: 8, trailing: 0)
        section.interGroupSpacing = 8
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BannerCell, Int> { cell, _, commentID in
            cell.bind(title: "Title", description: "Description")
        }
        
        bannerDataSource = UICollectionViewDiffableDataSource<Int, Int>(collectionView: bannerCollectionView) { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
    }
    
    @objc func CategoryButtonDidTap(sender: UIButton) {
        highlightBarAnimation(sender: sender)
        
        guard let index = categoryButtons.firstIndex(where: { $0 === sender }) else { return }
        
        if selectedCategoryTag < sender.tag {
            pageViewController.setViewControllers([pages[index]], direction: .forward, animated: true)
        } else {
            pageViewController.setViewControllers([pages[index]], direction: .reverse, animated: true)
        }
        selectedCategoryTag = sender.tag
    }
    
    func highlightBarAnimation(sender: UIButton) {
        categoryButtons.forEach {
            guard $0 === sender else {
                $0.isSelected = false
                return
            }
            $0.isSelected = true
        }
        NSLayoutConstraint.deactivate(self.categoryTabBar.highLightBarConstraints ?? [])
        guard let titleLabel = sender.titleLabel else { return }
        let senderPosition = view.convert(titleLabel.frame, from: categoryTabBar)
        let constraints: [NSLayoutConstraint] = [
            categoryTabBar.highlightBar.bottomAnchor.constraint(equalTo: categoryTabBar.bottomAnchor, constant: -10),
            categoryTabBar.highlightBar.heightAnchor.constraint(equalToConstant: 3),
            categoryTabBar.highlightBar.centerXAnchor.constraint(equalTo: sender.centerXAnchor),
            categoryTabBar.highlightBar.widthAnchor.constraint(equalToConstant: senderPosition.width - 4)
        ]
        NSLayoutConstraint.activate(constraints)
        self.categoryTabBar.highLightBarConstraints = constraints
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! MovieListViewController) else { return nil }
        let previousIndex = index - 1
        
        guard previousIndex < 0 else {
            return pages[previousIndex]
        }
        return nil
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController as! MovieListViewController) else { return nil }

        let nextIndex = index + 1
        if nextIndex == pages.count {
            return nil
        }
        return pages[nextIndex]
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed else { return }
        guard let currentViewController = pageViewController.viewControllers?.first else { return }
        guard let index = pages.firstIndex(of: currentViewController as! MovieListViewController) else { return }
        highlightBarAnimation(sender: categoryButtons[index])
    }
}

extension HomeViewController: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // more, less 스크롤 방향의 기준: 새로운 콘텐츠로 스크롤링하면 more, 이전 콘텐츠로 스크롤링하면 less
        // ex) more scroll 한다는 의미: 손가락을 아래에서 위로 올려서 새로운 콘텐츠를 확인한다
        
        let outerScroll = outerScrollView == scrollView
        let innerScroll = !outerScroll
        let moreScroll = scrollView.panGestureRecognizer.translation(in: scrollView).y < 0
        let lessScroll = !moreScroll
        let innerScrollView = innerScrollViews[selectedCategoryTag]
        
        // outer scroll이 스크롤 할 수 있는 최대값 (이 값을 sticky header 뷰가 있다면 그 뷰의 frame.maxY와 같은 값으로 사용해도 가능)
        let outerScrollMaxOffsetY = outerScrollView.contentSize.height - outerScrollView.frame.height
        let innerScrollMaxOffsetY = innerScrollView.contentSize.height - innerScrollView.frame.height
        
        // 1. outer scroll을 more 스크롤
        // 만약 outer scroll을 more scroll 다 했으면, inner scroll을 more scroll
        if outerScroll && moreScroll {
            guard outerScrollMaxOffsetY < outerScrollView.contentOffset.y + Metric.floatingPointTolerance else { return }
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            // innerScrollView를 모두 스크롤 한 경우 stop
            guard innerScrollView.contentOffset.y < innerScrollMaxOffsetY else { return }
            
            innerScrollView.contentOffset.y = innerScrollView.contentOffset.y + outerScrollView.contentOffset.y - outerScrollMaxOffsetY
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        // 2. outer scroll을 less 스크롤
        // 만약 inner scroll이 less 스크롤 할게 남아 있다면 inner scroll을 less 스크롤
        if outerScroll && lessScroll {
            guard innerScrollView.contentOffset.y > 0 && outerScrollView.contentOffset.y < outerScrollMaxOffsetY else { return }
            innerScrollingDownDueToOuterScroll = true
            defer { innerScrollingDownDueToOuterScroll = false }
            
            // outer scroll에서 스크롤한 만큼 inner scroll에 적용
            innerScrollView.contentOffset.y = max(innerScrollView.contentOffset.y - (outerScrollMaxOffsetY - outerScrollView.contentOffset.y), 0)
            
            // outer scroll은 스크롤 되지 않고 고정
            outerScrollView.contentOffset.y = outerScrollMaxOffsetY
        }
        
        // 3. inner scroll을 less 스크롤
        // inner scroll을 모두 less scroll한 경우, outer scroll을 less scroll
        if innerScroll && lessScroll {
            defer { innerScrollView.lastOffsetY = innerScrollView.contentOffset.y }
            guard innerScrollView.contentOffset.y < 0 && outerScrollView.contentOffset.y > 0 else { return }
            
            // innerScrollView의 bounces에 의하여 다시 outerScrollView가 당겨질수 있으므로 bounces로 다시 되돌아가는 offset 방지
            guard innerScrollView.lastOffsetY > innerScrollView.contentOffset.y else { return }
            
            let moveOffset = outerScrollMaxOffsetY - abs(innerScrollView.contentOffset.y) * 3
            guard moveOffset < outerScrollView.contentOffset.y else { return }
            
            outerScrollView.contentOffset.y = max(moveOffset, 0)
        }
        
        // 4. inner scroll을 more 스크롤
        // outer scroll이 아직 more 스크롤할게 남아 있다면, innerScroll을 그대로 두고 outer scroll을 more 스크롤
        if innerScroll && moreScroll {
            guard
                outerScrollView.contentOffset.y + Metric.floatingPointTolerance < outerScrollMaxOffsetY,
                !innerScrollingDownDueToOuterScroll
            else { return }
            // outer scroll를 more 스크롤
            let minOffetY = min(outerScrollView.contentOffset.y + innerScrollView.contentOffset.y, outerScrollMaxOffsetY)
            let offsetY = max(minOffetY, 0)
            outerScrollView.contentOffset.y = offsetY
            
            // inner scroll은 스크롤 되지 않아야 하므로 0으로 고정
            innerScrollView.contentOffset.y = 0
        }
    }
}

#Preview {
    HomeViewController()
}

private struct AssociatedKeys {
    static var lastOffsetY = "lastOffsetY"
}

extension UIScrollView {
    var lastOffsetY: CGFloat {
        get {
            (objc_getAssociatedObject(self, &AssociatedKeys.lastOffsetY) as? CGFloat) ?? contentOffset.y
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.lastOffsetY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

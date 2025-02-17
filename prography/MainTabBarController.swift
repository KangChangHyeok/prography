//
//  MainTabBarController.swift
//  prography
//
//  Created by kangChangHyeok on 17/02/2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let HomeNavController = createNavController(
            for: HomeViewController(),
            title: "Home",
            imageName: "House",
            selectedImageName: "RedHouse"
        )
        let MyNavController = createNavController(
            for: MyViewController(),
            title: "My",
            imageName: "Star",
            selectedImageName: "RedStar"
        )
        self.tabBar.unselectedItemTintColor = .black
        self.tabBar.tintColor = .init(hex: "D81D45")
        self.tabBar.backgroundColor = .init(hex: "f2f2f7")
        viewControllers = [HomeNavController, MyNavController]
    }
    
    func createNavController(
        for rootViewController: UIViewController,
        title: String,
        imageName: String,
        selectedImageName: String
    ) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.view.backgroundColor = .white
        navController.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName),
            selectedImage: UIImage(named: selectedImageName)
        )
        let imageView = UIImageView(image: .init(named: "Logo"))
        imageView.frame = .init(origin: .init(x: 0, y: 0), size: .init(width: 144, height: 24))
        navController.navigationBar.topItem?.titleView = imageView
        return navController
    }
}

#Preview {
    MainTabBarController()
}

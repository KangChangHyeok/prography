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
        viewControllers = [HomeNavController, MyNavController]
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .init(hex: "f2f2f7")
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.shadowColor = .clear
        
        UITabBar.appearance().tintColor = .main
        UITabBar.appearance().unselectedItemTintColor = .black
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
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

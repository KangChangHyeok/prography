//
//  Screen.swift
//  prography
//
//  Created by kangChangHyeok on 18/02/2025.
//

import UIKit

public struct Screen {
    
    // MARK: - 기기 세로길이
    
    public static var height: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.height
    }
    
    // MARK: - 기기 가로길이

    public static var width: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return window.screen.bounds.width
    }
    
    public static var statusBarHeight: CGFloat {
        guard let window = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        guard let height = window.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height else {
            return 0
        }
        return height
    }
    
    // MARK: 네비게이션 바 높이
    
    public static var navigationBarHeight: CGFloat {
        return UINavigationController().navigationBar.frame.height
    }
    
    // MARK: 탭 바 높이
    
    public static var tabBarHeight: CGFloat {
        return UITabBarController().tabBar.frame.height
    }
    
    public static var safeAreaBottom: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let widowScene = scenes.first as? UIWindowScene
        let window = widowScene?.windows.first
        return (window?.safeAreaInsets.bottom)!
    }
    
    // MARK: 디바이스의 위쪽 여백 (Safe Area 위쪽 여백)
    // ** 위쪽 여백의 전체 높이 : topInset = statusBarHeight + navigationBarHeight(존재하는 경우) **
    
    public static var topInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window?.safeAreaInsets.top ?? 0
    }
    
    // MARK: 디바이스의 아래쪽 여백 (Safe Area 아래쪽 여백)
    // ** 아래쪽 여백의 전체 높이 : bottomInset + tabBarHeight(존재하는 경우) **
    
    public static var bottomInset: CGFloat {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        return window?.safeAreaInsets.bottom ?? 0
    }
}

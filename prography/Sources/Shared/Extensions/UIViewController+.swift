//
//  UIViewController+.swift
//  prography
//
//  Created by kangChangHyeok on 21/02/2025.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let checkAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        alert.addAction(cancelAction)
        alert.addAction(checkAction)
        present(alert, animated: true)
    }
    
    func presentCheckAlert(title: String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let checkAction = UIAlertAction(title: "확인", style: .default, handler: completion)
        alert.addAction(checkAction)
        present(alert, animated: true)
    }
}



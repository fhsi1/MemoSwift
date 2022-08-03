//
//  UIViewController+Alert.swift
//  MemoSwift
//
//  Created by Yujean Cho on 2022/08/03.
//

import UIKit

// UIViewController 를 상속하는 모든 클래스에서 사용할 수 있도록 extension 으로 추가
extension UIViewController {
    func alert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

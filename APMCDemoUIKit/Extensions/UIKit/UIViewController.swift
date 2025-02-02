//
//  UIViewController.swift
//  APMCDemo
//
//  Created by Gabor Shaio on 2025-02-02.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(_ message: String, title: String? = nil, okText: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = .accent
        alert.addAction(UIAlertAction(title: okText, style: .default, handler: nil))

        self.present(alert, animated: true)
    }

    func showAlert(_ message: String, title: String? = nil, okText: String = "OK") async {
        await withCheckedContinuation { cont in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.view.tintColor = .accent
            alert.addAction(UIAlertAction(title: okText, style: .default) { _ in
                cont.resume()
            })
            self.present(alert, animated: true)
        }
    }
}

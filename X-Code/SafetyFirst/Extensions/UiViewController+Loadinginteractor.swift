//
//  UiViewController+Loadinginteractor.swift
//  SafetyFirst
//
//  Created by Erwin Warkentin on 17.11.20.
//

import UIKit

extension UIViewController {
    func showLoadingIndicator() {
        let loadingView = UIView(frame: self.view.frame)

        let activityIndicator = UIActivityIndicatorView(style: .large)
        let textLabel = UILabel()
        textLabel.text = "Loading..."

        let stackView = UIStackView(arrangedSubviews: [activityIndicator, textLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        loadingView.backgroundColor = UIColor(named: "customGray")?.withAlphaComponent(0.85)
        loadingView.tag = 999

        loadingView.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])

        DispatchQueue.main.async {
            activityIndicator.startAnimating()
            self.view.addSubview(loadingView)
        }
    }

    func hideLoadingIndicator() {
        DispatchQueue.main.async {
            for v in self.view.subviews {
                if v.tag == 999 {
                    v.removeFromSuperview()
                }
            }
        }
    }
}

//
//  ViewController.swift
//  BottomSheetDemo
//
//  Created by Kang Minsang on 2023/05/23.
//

import UIKit

final class ViewController: UIViewController {
    private let button: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        button.setTitle("Show BottomSheet", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureButton()
    }
}

extension ViewController {
    private func configureUI() {
        self.view.addSubview(self.button)
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func configureButton() {
        self.button.addAction(UIAction(handler: { [weak self] _ in
            self?.showBottomSheet()
        }), for: .touchUpInside)
    }
    
    private func showBottomSheet() {
        // MARK: Show BottomSheetViewController
        print("Show BottomSheetViewController")
    }
}

//
//  UIView+Extension.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

extension UIView {
    func fillContainer() {
        guard let superview = self.superview else { return }

        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leftAnchor.constraint(equalTo: superview.leftAnchor),
            self.rightAnchor.constraint(equalTo: superview.rightAnchor),
        ])
    }

    func centerToContainer() {
        guard let superview = self.superview else { return }

        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}

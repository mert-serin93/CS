//
//  ViewSetup.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import Foundation

protocol ViewSetup {
    func setupUI()
    func addSubviews()
    func setupViews()
    func setupConstraints()
    func setupAccessibilityIdentifiers()
}

extension ViewSetup {
    func setupUI() {
        addSubviews()
        setupViews()
        setupConstraints()
        setupAccessibilityIdentifiers()
    }
}

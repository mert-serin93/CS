//
//  DashboardView.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardViewDelegate: AnyObject{
    func showDetail(with viewModel: CreditScoreResponseModel)
}

class DashboardView: UIView {

    private lazy var circleView = CircleView(delegate: self)

    private unowned let delegate: DashboardViewDelegate

    private var state: DashboardViewController.State = .loading{
        didSet {
            circleView.update(with: state)
        }
    }

    init(delegate: DashboardViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    func update(with state: DashboardViewController.State?) {
        guard let state = state else { return }
        self.state = state
    }
}

//MARK: - ViewSetup

extension DashboardView: ViewSetup {
    func addSubviews() {
        [circleView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })
    }

    func setupViews() {
        backgroundColor = .white
    }

    func setupConstraints() {
        circleView.centerToContainer()
        NSLayoutConstraint.activate([
            circleView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -75),
            circleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -75),
        ])
    }

    func setupAccessibilityIdentifiers() {}
}

//MARK: CircleView Delegate methods

extension DashboardView: CircleViewDelegate {
    func onTappedDetailButton(with viewModel: CreditScoreResponseModel) {
        delegate.showDetail(with: viewModel)
    }
}

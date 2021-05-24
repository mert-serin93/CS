//
//  DashboardDetailView.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardDetailViewDelegate: AnyObject{}

class DashboardDetailView: UIView {

    private unowned let delegate: DashboardDetailViewDelegate

    private lazy var stackView: UIStackView = {
        var s = UIStackView()
        s.axis = .vertical
        s.alignment = .top
        s.distribution = .equalSpacing
        s.directionalLayoutMargins = .init(top: 20, leading: 20, bottom: 0, trailing: 20)
        s.isLayoutMarginsRelativeArrangement = true
        s.spacing = 20
        return s
    }()

    private lazy var titleLabel = UILabel()
    private lazy var detailLabel = UILabel()
    private lazy var scoreLabel = UILabel()

    private var viewModel: CreditScoreResponseModel? {
        didSet{
            setupAfterViewModel()
        }
    }

    private var state: DashboardViewController.State = .loading {
        didSet {
            switch state {
            case .loaded(let viewModel):
                self.viewModel = viewModel
            case .loading:
                break
            case .error(_):
                break
            }
        }
    }

    init(delegate: DashboardDetailViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)

        setupUI()
    }

    required init?(coder: NSCoder) { nil }

    func update(with state: DashboardViewController.State?) {
        guard let state = state else { return }
        self.state = state
    }

    private func setupAfterViewModel() {
        guard let viewModel = viewModel else { return }

        titleLabel.text = String(format: NSLocalizedString("Credit ref: %@", comment: ""),
                                 arguments: [viewModel.creditReportInfo.clientRef])
        detailLabel.text = String(format: NSLocalizedString("Status: %@", comment: ""),
                                  arguments: [viewModel.creditReportInfo.status])
        scoreLabel.text = String(format: NSLocalizedString("Score: %@", comment: ""),
                                 arguments: ["\(viewModel.creditReportInfo.score)"])
    }
}

//MARK: - ViewSetup

extension DashboardDetailView: ViewSetup {
    func addSubviews() {
        [stackView].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        })

        [titleLabel, detailLabel, scoreLabel].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        })
    }

    func setupViews() {
        backgroundColor = .white
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }

    func setupAccessibilityIdentifiers() {
        stackView.accessibilityLabel = "CreditDetailStackView"
        titleLabel.accessibilityLabel = "CreditDetailTitleLabel"
        detailLabel.accessibilityLabel = "CreditDetailDetailLabel"
        scoreLabel.accessibilityLabel = "CreditDetailScoreLabel"
    }
}

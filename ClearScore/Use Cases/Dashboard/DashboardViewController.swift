//
//  DashboardViewController.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardViewControllerDelegate: AnyObject {
    func showDetail(with viewModel: CreditScoreResponseModel)
}

class DashboardViewController: UpdatableViewController<DashboardViewController.State> {

    enum State {
        case loading
        case loaded(CreditScoreResponseModel)
        case error(Error)
    }

    private unowned let delegate: DashboardViewControllerDelegate!

    private var dashboardView: DashboardView!{
        didSet{
            self.view = dashboardView
        }
    }

    init(delegate: DashboardViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle : nil)

        title = NSLocalizedString("Dashboard", comment: "Dashboard view controller title")
    }

    required init?(coder: NSCoder) { nil }

    override func loadView() {
        dashboardView = DashboardView(delegate: self)
        dashboardView.update(with: .loading)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func update(with state: State?) {
        super.update(with: state)
        dashboardView.update(with: state)
    }
}

extension DashboardViewController: DashboardViewDelegate {
    func showDetail(with viewModel: CreditScoreResponseModel) {
        delegate?.showDetail(with: viewModel)
    }
}

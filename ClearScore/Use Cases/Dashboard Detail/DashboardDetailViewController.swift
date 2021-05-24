//
//  DashboardViewController.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardDetailViewControllerDelegate: AnyObject {}

class DashboardDetailViewController: UpdatableViewController<DashboardViewController.State> {

    enum State {
        case loading
        case loaded(CreditScoreResponseModel)
        case error(Error)
    }

    private unowned let delegate: DashboardDetailViewControllerDelegate!

    private var dashboardDetailView: DashboardDetailView!{
        didSet{
            self.view = dashboardDetailView
        }
    }

    init(delegate: DashboardDetailViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle : nil)

        title = NSLocalizedString("Detail", comment: "Dashboard Detail NavBar Title")
    }

    required init?(coder: NSCoder) { nil }

    override func loadView() {
        dashboardDetailView = DashboardDetailView(delegate: self)
        dashboardDetailView.update(with: .loading)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func update(with state: DashboardViewController.State?) {
        super.update(with: state)
        dashboardDetailView.update(with: state)
    }
}

extension DashboardDetailViewController: DashboardDetailViewDelegate {}

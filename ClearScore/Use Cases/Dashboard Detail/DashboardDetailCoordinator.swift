//
//  DashboardDetailCoordinator.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardDetailCoordinatorDelegate: AnyObject {}

class DashboardDetailCoordinator: Coordinator{

    private unowned let delegate: DashboardDetailCoordinatorDelegate!
    private var interactor: DashboardDetailInteractor!
    private let viewModel: CreditScoreResponseModel
    private var navigationController: UINavigationController!
    private lazy var dashboardDetailViewController = DashboardDetailViewController(delegate: self)

    init(delegate: DashboardDetailCoordinatorDelegate, viewModel: CreditScoreResponseModel, navigationController: UINavigationController?) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.navigationController = navigationController
    }

    @discardableResult
    func start(_ router: CoordinatorRouter?) -> UIViewController? {
        interactor = DashboardDetailInteractor(output: self)

        if let navController = navigationController {
            navController.pushViewController(dashboardDetailViewController, animated: true)
        } else {
            navigationController = UINavigationController(rootViewController: dashboardDetailViewController)
        }

        dashboardDetailViewController.update(with: .loaded(viewModel))

        return navigationController
    }

}

extension DashboardDetailCoordinator: DashboardDetailViewControllerDelegate {}

extension DashboardDetailCoordinator: DashboardDetailInteractorOutput {
    func errorResponse(error: Error, endpoint: Endpoint) {
        //TO-DO handle error state
    }

}

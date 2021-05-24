//
//  DashboardCoordinator.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol DashboardCoordinatorDelegate: AnyObject {}

class DashboardCoordinator: Coordinator{

    private unowned let delegate: DashboardCoordinatorDelegate!
    private var interactor: DashboardInteractor!
    private var navigationController: UINavigationController!
    private lazy var dashboardViewController = DashboardViewController(delegate: self)
    private var dashboardDetailCoordinator: DashboardDetailCoordinator?

    init(delegate: DashboardCoordinatorDelegate, navigationController: UINavigationController?) {
        self.delegate = delegate
        self.navigationController = navigationController
    }

    @discardableResult
    func start(_ router: CoordinatorRouter?) -> UIViewController? {
        interactor = DashboardInteractor(output: self)

        if let navController = navigationController {
            navController.pushViewController(dashboardViewController, animated: true)
        } else {
            navigationController = UINavigationController(rootViewController: dashboardViewController)
        }

        navigationController.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        interactor.fetchCreditScore()

        return navigationController
    }

}

extension DashboardCoordinator: DashboardViewControllerDelegate {
    func showDetail(with viewModel: CreditScoreResponseModel) {
        dashboardDetailCoordinator = DashboardDetailCoordinator(delegate: self, viewModel: viewModel, navigationController: navigationController)
        dashboardDetailCoordinator?.start(nil)
    }
}

extension DashboardCoordinator: DashboardDetailCoordinatorDelegate {

}

extension DashboardCoordinator: DashboardInteractorOutput {
    func errorResponse(error: Error, endpoint: Endpoint) {
        //TO-DO handle error state
    }

    func creditScoreFetched(response: CreditScoreResponseModel) {
        dashboardViewController.update(with: .loaded(response))
    }
}

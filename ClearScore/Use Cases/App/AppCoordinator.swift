//
//  AppCoordinator.swift
//
//  Created by Mert Serin on 2021-05-24.
//

import UIKit

protocol CoordinatorRouter {}

protocol InteractorOutput: AnyObject {
    func errorResponse(error: Error, endpoint: Endpoint)
}

protocol Coordinator {
    @discardableResult
    func start(_ router: CoordinatorRouter?) -> UIViewController?
}

class UpdatableViewController<ViewModel>: UIViewController {
    func start(with _: ViewModel?) {
        if !isViewLoaded { loadViewIfNeeded() }
    }

    func update(with _: ViewModel?) {
        if !isViewLoaded { loadViewIfNeeded() }
    }
}

protocol AppCoordinatorDelegate: AnyObject {
    func keyWindowChanged(_ window: UIWindow)
}

class AppCoordinator: NSObject, Coordinator {
    private weak var delegate: AppCoordinatorDelegate?
    private var window: UIWindow{
        get{
           return UIApplication.shared.windows.filter {$0.isKeyWindow}.first!
        }set{
            delegate?.keyWindowChanged(newValue)
        }

    }

    private var rootCoordinator: Coordinator?

    init(delegate: AppCoordinatorDelegate) {
        self.delegate = delegate

        super.init()

    }

    @discardableResult
    func start(_: CoordinatorRouter?) -> UIViewController? {
        rootCoordinator = DashboardCoordinator(delegate: self, navigationController: nil)

        window.rootViewController = rootCoordinator?.start(nil)
        window.makeKeyAndVisible()

        defer {
            delegate?.keyWindowChanged(window)
        }

        return window.rootViewController
    }


    // MARK: - Navigation

    private func revealNewWindow(with rootViewController: UIViewController?,
                                 withSnapshot snapShot: UIView) {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        let oldRootViewController = window.rootViewController

        rootViewController?.view.addSubview(snapShot)
        newWindow.rootViewController = rootViewController
        newWindow.makeKeyAndVisible()

        // common completion closure
        let internalCompleted = { [weak self] in
            // dismiss any presented view controller to remove the retian cycle with the old window
            oldRootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
            self?.window = newWindow
            self?.delegate?.keyWindowChanged(newWindow)
        }

        UIView.animate(withDuration: 0.2, animations: {
            snapShot.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: snapShot.frame.width, height: snapShot.frame.height)
        }) { done in

            if done {
                snapShot.removeFromSuperview()
                internalCompleted()
            }
        }
    }

    private func presentNewWindow(with rootViewController: UIViewController?) {
        let newWindow = UIWindow(frame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        let oldRootViewController = window.rootViewController

        newWindow.rootViewController = rootViewController
        newWindow.makeKeyAndVisible()
        rootViewController?.setNeedsStatusBarAppearanceUpdate()

        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            newWindow.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        }) { done in
            if done {
                oldRootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
                self.window = newWindow
                self.delegate?.keyWindowChanged(newWindow)
            }
        }
    }

    func update(_ router: CoordinatorRouter?) -> UIViewController? {
        return nil
    }
}

extension AppCoordinator: DashboardCoordinatorDelegate {
    
}

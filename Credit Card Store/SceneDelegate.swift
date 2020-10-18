//
//  SceneDelegate.swift
//  Credit Card Store
//
//  Created by Alperen Duran on 8.08.2020.
//  Copyright © 2020 Alperen Duran. All rights reserved.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var bag: DisposeBag?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.bag = .init()
        let controller = CardListViewController(with: cardListViewModel)
        let navigationController = NavigationController(root: controller)
        let authorization = AuthorizeViewController(with: authorizeViewModel)
        window.rootViewController = authorization
        window.makeKeyAndVisible()
        
        Current.authorization.authorizeObservable
            .subscribe(onNext: { isAuthorized in
                window.rootViewController = isAuthorized
                    ? navigationController
                    : authorization
                window.makeKeyAndVisible()
            })
            .disposed(by: bag!)
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        Current.authorization.authorizeObserver.onNext(false)
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        Current.authorization.authorizeObserver.onNext(false)
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard
            userActivity.activityType == NSStringFromClass(AddNewCardIntentIntent.self)
        else { return }
        
        guard let window = window else { return }
        let controller = CardListViewController(with: cardListViewModel)
        let navigationController = NavigationController(root: controller)
        let datasource = AddCardNavigationDatasource(viewModel: addCardViewModel)
        let addNewCardViewController = AddCardViewController(with: datasource)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        controller.show(addNewCardViewController, sender: nil)
    }
}

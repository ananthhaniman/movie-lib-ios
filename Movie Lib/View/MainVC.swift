//
//  ViewController.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-22.
//

import UIKit

class MainVC: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constant.backgroundColor
        setupVCs()
    }
    
    // MARK: - Delare Tab Bar Controllers
    private func setupVCs() {
        viewControllers = [
            createNavController(for: MovieVC(), title: "Search", image: UIImage(named: "Search")!),
            createNavController(for: FavoriteVC(), title: "Favorites", image: UIImage(named: "FavoriteIcon")!),
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        if #available(iOS 11.0, *) {
            navController.navigationBar.prefersLargeTitles = true
        }
        rootViewController.navigationItem.title = title
        return navController
    }
    
}


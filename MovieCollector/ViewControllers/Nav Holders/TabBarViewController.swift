//
//  TabBarViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/22/20.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            self.viewControllers = [initialTabBar, middleTabBar, finalTabBar]
    }
    
    
    lazy public var initialTabBar: BrowseNavigationController = {
           
           let initialTabBar = BrowseNavigationController()
           
           let title = "Browse"
           
           let defaultImage = UIImage(systemName: "film")
           
           let selectedImage = UIImage(systemName: "film.fill")

           let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
           
           initialTabBar.tabBarItem = tabBarItem

           return initialTabBar
       }()
    
    lazy public var middleTabBar: SearchNavigationController = {
           
           let middleTabBar = SearchNavigationController()
           
           let title = "Search"
           
           let defaultImage = UIImage(systemName: "magnifyingglass.circle")
           
           let selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")

           let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
           
           middleTabBar.tabBarItem = tabBarItem

           return middleTabBar
       }()
    
       
       lazy public var finalTabBar: ProfileNavigationController = {
           
           let finalTabBar = ProfileNavigationController()
        
            let title = "Profile"
           
           let defaultImage = UIImage(systemName: "person")
           
           let selectedImage = UIImage(systemName: "person.fill")
           
           let tabBarItem = UITabBarItem(title: title, image: defaultImage, selectedImage: selectedImage)
           
           finalTabBar.tabBarItem = tabBarItem
           
           return finalTabBar
       }()


}

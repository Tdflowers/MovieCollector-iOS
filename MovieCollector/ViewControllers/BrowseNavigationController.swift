//
//  BrowseNavigationController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/28/20.
//

import UIKit

class BrowseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let bvc = BrowseViewController()
        self.setViewControllers([bvc], animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SearchNavigationController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/11/21.
//

import UIKit

class ProfileNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pvc = ProfileViewController(isCurrentUser: true, userId: nil)
        self.setViewControllers([pvc], animated: false)
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

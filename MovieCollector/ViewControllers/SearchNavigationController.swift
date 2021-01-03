//
//  SearchNavigationController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 1/2/21.
//

import UIKit

class SearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let svc = SearchViewController()
        
        self.setViewControllers([svc], animated: false)
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

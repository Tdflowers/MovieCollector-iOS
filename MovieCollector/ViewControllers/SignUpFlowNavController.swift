//
//  SignUpFlowNavController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 9/9/22.
//

import UIKit

class SignUpFlowNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let lvc = LoginViewController()
        self.setViewControllers([lvc], animated: false)
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

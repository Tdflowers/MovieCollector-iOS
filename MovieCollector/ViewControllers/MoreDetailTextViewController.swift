//
//  MoreDetailTextViewController.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 12/30/20.
//

import UIKit

class MoreDetailTextViewController: UIViewController {
    
    var detailText:String = ""
    var navigationTitle = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = navigationTitle
        
        view.backgroundColor = .systemBackground
        
        let detailTextView = UITextView.init()
        detailTextView.isEditable = false
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.backgroundColor = .clear
        detailTextView.font = UIFont(name: "AvenirNext-Regular", size: 14)
    
        detailTextView.text = detailText
        
        self.view.addSubview(detailTextView)
        
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: -20),
            detailTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            detailTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95),
            detailTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
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

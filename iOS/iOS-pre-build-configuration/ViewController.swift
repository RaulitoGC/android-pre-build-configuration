//
//  ViewController.swift
//  iOS-pre-build-configuration
//
//  Created by Raul Guzman on 26/08/22.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let customColor = UIColor(named: "CustomBrownColor")!.resolvedColor(with: UITraitCollection(userInterfaceStyle: .unspecified))
        logoImage.tintColor = customColor
    
    }

}

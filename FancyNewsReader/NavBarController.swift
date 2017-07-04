//
//  NavBarController.swift
//  Awesome Notes
//
//  Created by Abdul-Mujib Aliu on 5/7/17.
//  Copyright © 2017 Abdul-Mujib Aliu. All rights reserved.
//

import UIKit


class NavBarController: UINavigationController {
    
    let transparentPixel = UIImage.imageWithColor(color: UIColor.clear)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //Make color of title
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.navigationBar.tintColor = .white
    
    
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

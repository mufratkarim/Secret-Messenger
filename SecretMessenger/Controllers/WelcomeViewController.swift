//
//  WelcomeViewController.swift
//  SecretMessenger
//
//  Created by Mufrat Karim Aritra on 10/3/23.
//  Copyright © 2023 Lego Code. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fullText = titleLabel.text!
        var charIndex = 0.0
        titleLabel.text = ""
        for word in fullText {
            charIndex += 1
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { Timer in
                self.titleLabel.text?.append(word)
            }
        }
        
        
    }
    
    
}

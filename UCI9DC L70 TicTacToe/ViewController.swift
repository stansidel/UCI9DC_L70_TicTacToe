//
//  ViewController.swift
//  UCI9DC L70 TicTacToe
//
//  Created by Stanislav Sidelnikov on 29/02/16.
//  Copyright © 2016 Stanislav Sidelnikov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var crossNoughtsButtons: [UIButton]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for button in crossNoughtsButtons {
            button.alpha = 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTap(sender: UIButton) {
        print("Tapped \(sender.tag)")
        sender.setImage(UIImage(named: "cross.png"), forState: .Normal)
        UIView.animateWithDuration(0.5) { () -> Void in
            sender.alpha = 1.0
        }
    }

}


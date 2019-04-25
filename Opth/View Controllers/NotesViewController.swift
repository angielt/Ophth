//
//  NotesViewController.swift
//  Opth
//
//  Created by Nomuna Batmandakh on 4/23/19.
//  Copyright © 2019 Angie Ta. All rights reserved.
//

import UIKit
import os.log

class NotesViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    


    // MARK: - Navigation

     @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
     }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    }

}

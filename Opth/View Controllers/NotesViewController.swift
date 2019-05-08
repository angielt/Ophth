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
    @IBOutlet var notesText: UITextView!
    
    var subtopic: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesText.becomeFirstResponder()
        notesText.delegate = self as? UITextViewDelegate
        
        let userDefaults = UserDefaults.standard
        if let note = userDefaults.string(forKey: subtopic!) {
            notesText.text = note
        }

        notesText.reloadInputViews()
    }

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
        let userDefaults = UserDefaults.standard
        userDefaults.set(notesText.text, forKey: subtopic!)
    }

}

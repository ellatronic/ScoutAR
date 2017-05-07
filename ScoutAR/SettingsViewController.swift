//
//  SettingsViewController.swift
//  ScoutAR
//
//  Created by Ella on 5/4/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var licenseTextView: UITextView!

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
}

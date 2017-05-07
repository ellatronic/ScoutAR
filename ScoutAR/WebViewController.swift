//
//  WebViewController.swift
//  ScoutAR
//
//  Created by Ella on 4/27/17.
//  Copyright © 2017 Ellatronic. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var backButton: UIButton!
    var venueID: String?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        view.addSubview(webView)
        guard let id = venueID  else { return }
        if let url = URL(string: "https://foursquare.com/v/\(id)?ref=U0H3VHFNJFUGNIMPPZWEM5YQ5SLY2TLCBQNWZBYKYVYVX5AL") {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

//
//  ViewController.swift
//  CustomSegueDemo
//
//  Created by Timothy Moose on 6/13/18.
//  Copyright © 2018 it.swiftkick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationVC = segue.destination as! UINavigationController
        let rootVC = navigationVC.viewControllers.first!
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hide))
        rootVC.navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func showProgrammatically(_ sender: Any) {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "Child")
        let segue = BottomCardSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
    }
}


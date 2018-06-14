//
//  ViewController.swift
//  CustomSegueDemo
//
//  Created by Timothy Moose on 6/13/18.
//  Copyright © 2018 it.swiftkick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func showProgramatically(_ sender: Any) {
        let childVC = storyboard!.instantiateViewController(withIdentifier: "Child")
        let segue = CustomSegue(identifier: nil, source: self, destination: childVC)
        prepare(for: segue, sender: nil)
        segue.perform()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segue = segue as! CustomSegue
        segue.height = 200
        let navigationVC = segue.destination as! UINavigationController
        let rootVC = navigationVC.viewControllers.first!
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(hide))
        rootVC.navigationItem.rightBarButtonItem = doneButton
    }

    @objc private func hide() {
        dismiss(animated: true, completion: nil)
    }
}


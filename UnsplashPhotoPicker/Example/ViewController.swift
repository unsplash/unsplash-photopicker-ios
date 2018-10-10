//
//  ViewController.swift
//  Example
//
//  Created by Bichon, Nicolas on 2018-10-08.
//  Copyright © 2018 Unsplash. All rights reserved.
//

import UIKit
import UnsplashPhotoPicker

class ViewController: UIViewController {

    @IBAction func presentUnsplashPhotoPicker(sender: AnyObject?) {
        let unsplashPhotoPicker = UnsplashPhotoPicker()

        present(unsplashPhotoPicker, animated: true, completion: nil)
    }

}


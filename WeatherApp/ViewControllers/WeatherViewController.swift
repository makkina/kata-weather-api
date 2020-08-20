//
//  ViewController.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
    }
    
    @IBAction func cityButtonPressed(_ sender: CityButtonView) {
        // TODO:
    }
    
    private func setupInitialView() {
        loader.stopAnimating()
        weatherLabel.isHidden = false
        weatherLabel.text = "°C"
        weatherImageView.image = UIImage(systemName: "sun.min")
    }
}

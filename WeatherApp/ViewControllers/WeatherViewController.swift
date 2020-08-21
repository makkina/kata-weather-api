//
//  ViewController.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    var viewModel: WeatherViewModel = WeatherViewModel(
        weatherModel: nil,
        weatherClient: WeatherClient(networkClient: NetworkClient())
    )
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        viewModel.delegate = self
    }
    
    @IBAction func cityButtonPressed(_ sender: CityButtonView) {
        if loader.isHidden {
            viewModel.fetchWeather(city: sender.currentTitle!)
        }
    }
    
    private func setupInitialView() {
        loader.stopAnimating()
        weatherLabel.isHidden = false
        weatherLabel.text = "°C"
        weatherImageView.image = UIImage(systemName: "sun.min")
    }
}

// MARK: - WeatherViewModelDelegate

extension WeatherViewController: WeatherViewModelDelegate {
    
    func willLoadData() {
        loader.startAnimating()
        weatherLabel.isHidden = true
    }
    
    func didLoadData() {
        loader.stopAnimating()
        weatherLabel.isHidden = viewModel.weatherLabelIsHidden
        weatherLabel.text = viewModel.weatherLabelText
        weatherImageView.image = UIImage(systemName: viewModel.weatherConditionName)
    }
}

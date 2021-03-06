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
        weatherClient: WeatherClient(
            networkClient: NetworkClient()
        )
    )
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    @IBAction func cityButtonPressed(_ sender: CityButtonView) {
        if loader.isHidden {
            viewModel.fetchWeather(city: sender.currentTitle!)
        }
    }
}

// MARK: - WeatherViewModelDelegate

extension WeatherViewController: WeatherViewModelDelegate {
    
    func willLoadData() {
        loader.startAnimating()
        weatherLabel.isHidden = viewModel.weatherLabelIsHidden
    }
    
    func didLoadData() {
        loader.stopAnimating()
        weatherLabel.isHidden = viewModel.weatherLabelIsHidden
        weatherLabel.text = viewModel.weatherLabelText
        weatherImageView.image = UIImage(systemName: viewModel.weatherConditionName)
    }
}

//
//  CityButtonView.swift
//  WeatherApp
//
//  Created by Makkina on 20/08/2020.
//  Copyright © 2020 Makkina. All rights reserved.
//

import Foundation
import UIKit

class CityButtonView: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 10
        self.accessibilityIdentifier = "weatherButton \(self.tag)"
    }
}

//
//  WetherViewController.swift
//  Weather
//
//  Created by Afzaal Ahmad on 9/18/23.
//

import Foundation
import UIKit
import Combine

final class WeatherViewController: UIViewController {
    
    //MARK: outlets
    @IBOutlet private weak var weatherImageView: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherCitiLabel: UILabel!
    @IBOutlet private weak var weatherFullDayLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var notifyLabel: UILabel!

    //MARK: private properties
    
    private let viewModel: WeatherViewModel
    private var bindingCancellable: AnyCancellable?
    
    // MARK: Life Cycle
    
    init?(coder: NSCoder, viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a user.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewDidLoad()
    }
    
    // MARK: Public Methods
    
    private func setupUI() {
        title = viewModel.screenTitle
    }
    
    private func bindViewModel() {
        bindingCancellable = viewModel.output.sink { [weak self] viewState in
            self?.render(viewState)
        }
    }
    
    private func render(_ state: WeatherViewState) {
        switch state {
        case .loading(true):
            notifyLabel.text = ""
            temperatureLabel.text = ""
            weatherCitiLabel.text = ""
            weatherFullDayLabel.text = ""
            weatherDescriptionLabel.text = ""
            activityIndicatorView.startAnimating()
            
        case .loading(false):
            activityIndicatorView.stopAnimating()
            
        case let .message(message):
            notifyLabel.text = message
            temperatureLabel.text = ""
            weatherCitiLabel.text = ""
            weatherFullDayLabel.text = ""
            weatherDescriptionLabel.text = ""
            
        case let .weather(content):
            notifyLabel.text = ""
            temperatureLabel.text = content.temperature
            weatherCitiLabel.text = content.weatherCitiName
            weatherFullDayLabel.text = content.fullDayTemperature
            weatherDescriptionLabel.text = content.description
            if let url = content.weatherIconUrl {
                weatherImageView.loadImage(with: url)
            }
        }
    }
}

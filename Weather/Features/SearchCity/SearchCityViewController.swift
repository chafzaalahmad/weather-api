//
//  SearchCityViewController.swift
//  Weather
//
//  Created by Afzaal Ahmad on 11/7/23.
//

import UIKit
import Combine
import SwiftUI

final class SearchCityViewController: UIViewController {
 
    //MARK: private properties
 
    var searchCityContentViewController:  UIHostingController<SearchCityContentView>?
    
    private let viewModel: SearchCityViewModel
    private var bindingCancellable: AnyCancellable?
    
    private let searchCityData = SearchCityData(searchCities: [])
    
    // MARK: Life Cycle
    
    init?(coder: NSCoder, viewModel: SearchCityViewModel) {
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
        self.configureSearchCityContentView(cities: [])
    }
    
    private func configureSearchCityContentView(cities: [SeachCityRowViewModel]) {
                
        let hostingController = UIHostingController.init(rootView: SearchCityContentView(viewModel: self.viewModel, data: searchCityData))
        
        self.searchCityContentViewController = hostingController
                        
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
                
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
    }
    
    
    private func bindViewModel() {
        bindingCancellable = viewModel.output.sink { [weak self] viewState in
            self?.render(viewState)
        }
    }
    
    private func render(_ state: SearchCityViewState) {
        switch state {
            case .message(let message):
                self.presentAlert(withTitle: "Error", message: message)
            case .showRows(let rows):
            self.searchCityContentViewController?.rootView = SearchCityContentView(viewModel: self.viewModel, data: SearchCityData(searchCities: rows))
        }
    }
}

//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 04.04.2023.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) { // проверяем содержет ли массив данный элемент с помощью Hashable, Equatable
                cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    private var apiInfo: RMGetAllLocationResponse.Info?
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    init (){
        
    }
    public func location(at index: Int) -> RMLocation?{
        guard index < locations.count, index >= 0 else { return nil}
        return locations[index]
    }
    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequest, expecting: RMGetAllLocationResponse.self) { [weak self] responce in
            switch responce {
            case .success(let model):
                self?.locations = model.results
                self?.apiInfo = model.info
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(_):
                print("Failed to fetch locations")
            }
        }
    }
}

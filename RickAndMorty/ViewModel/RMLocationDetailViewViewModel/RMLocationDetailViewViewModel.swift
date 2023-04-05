import Foundation

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}
final class RMLocationDetailViewViewModel {
    
    private let endpointURL: URL?
    private var dataTupel: (location: RMLocation, character: [RMCharacter])? {
        didSet {
            createCellViewModel()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public  weak var delegate: RMLocationDetailViewViewModelDelegate?
    public private (set) var cellViewModels: [SectionType] = [] // public только для чтения, а для записи private
    
    private func createCellViewModel() {
        guard let dataTupel = dataTupel else {
            return
        }
        let location = dataTupel.location
        let character = dataTupel.character
        var createdString = ""
        if let createdDate =  RMCharacterInfoCollectionViewCellViewModel.dateFormater.date(from: location.created ) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormater.string(from: createdDate)
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(titel: "Location Name", value: location.name),
                .init(titel: "Type", value: location.type),
                .init(titel: "D  imension", value: location.dimension),
                .init(titel: "Created", value: createdString)
            ]),
            .characters(viewModel: character.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageURL: URL(string: $0.image)
                )
            }))
        ]
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTupel = dataTupel else {
            return nil
        }
        let character = dataTupel.character[index]
        return character
    }
    
    
    //MARK: - Init
    init (endpointURL: URL?){
        self.endpointURL = endpointURL
    }
    
    public func fetchEpisodeData(){
        guard let url = endpointURL, let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.fetchRelatedCharacters(location: data )
            case .failure(_):
                print("Failed to get data for episode")
            }
        }
    }
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterURL: [URL] = location.residents.compactMap({
            return URL(string: $0)
        })
        let requests: [RMRequest] = characterURL.compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup() // позволяет сформировать параллейние запросы и получит уведомлении о завершении операции
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter() // входим в группу
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let data):
                    characters.append(data)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main){
            self.dataTupel = (location: location, character: characters)
        }
    }
}


import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject{
    func didLoadInitialCharacters()
    func didLoadMoreCharacters()
    func didSelectCharacter(_ character: RMCharacter) // урок 9
}

/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters{
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image)
                )
                cellViewModel.append(viewModel)
               
            }
        }
    }
    
    private var cellViewModel: [RMCharacterCollectionViewCellViewModel] = []
    private var isLoadingListViewCharacters = false
    private var apiInfo: RMGetAllCharacterResponse.Info? = nil
    
    /// Fetch initial set of characters (20)
    public func fetchCharacter(){
        RMService.shared.execute(.listCharacterRequest, expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            switch result {
            case .success(let responceModel):
                let results = responceModel.results
                let info = responceModel.info
                self?.characters = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(){
        isLoadingListViewCharacters = true
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString),
              let request = RMRequest(url: url) else {
            isLoadingListViewCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllCharacterResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responceModel):
                strongSelf.cellViewModel.removeAll()
                let newResults = responceModel.results
                let info = responceModel.info
                strongSelf.characters.append(contentsOf: newResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters()
                    strongSelf.isLoadingListViewCharacters = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingListViewCharacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}
// MARK: CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else { fatalError("Unsupported cell") }
        cell.configure(with: cellViewModel[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) // убирает выделение нажатой ячейки
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
       }
        footer.startAnimating()
        return footer
    }// создаем
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else { // если мы не дожны показывать футер то задем размер 0
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }// задаем размер футера
}
// MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // вызывается когда страница прокрученна до конца
        guard shouldShowLoadMoreIndicator,
              !isLoadingListViewCharacters else { return }
        
        let ofset = scrollView.contentOffset.y
        let totalContentHeight = scrollView.contentSize.height
        let totalScrollViewHeight = scrollView.frame.size.height
        
        if ofset >= totalContentHeight - totalScrollViewHeight - 120 {
            fetchAdditionalCharacters()
        }
        
    }
}

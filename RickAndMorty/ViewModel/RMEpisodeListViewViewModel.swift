
import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject{
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes()
    func didSelectEpisodes(_ episode: RMEpisode)
}

/// View Model to handle episode  list view logic
final class RMEpisodeListViewViewModel: NSObject {
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemOrange,
        .systemGreen,
        .systemPink,
        .systemPurple,
        .systemMint,
        .systemRed,
        .systemYellow
    ]
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemBlue)
                cellViewModel.append(viewModel) // здесь возможна ошибка 24 видео 2 минута
            }
        }
    }
    
    private var cellViewModel: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    private var isLoadingListViewCharacters = false
    private var apiInfo: RMGetAllEpisodesResponse .Info? = nil
    
    /// Fetch initial set of characters (20)
    public func fetchEpisodes(){
        RMService.shared.execute(.listEpisodeRequest, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responceModel):
                let results = responceModel.results
                let info = responceModel.info
                self?.episodes =  results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
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
                                 expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responceModel):
                strongSelf.cellViewModel.removeAll()
                let newResults = responceModel.results
                let info = responceModel.info
                strongSelf.episodes.append(contentsOf: newResults)
                strongSelf.apiInfo = info
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes()
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
extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError("Unsupported cell") }
        cell.configure(with: cellViewModel[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) // убирает выделение нажатой ячейки
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisodes(selection)
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
extension RMEpisodeListViewViewModel: UIScrollViewDelegate{
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


import AppKit

extension NSCollectionViewDiffableDataSource {
  convenience init(collectionView: NSCollectionView,
                   itemProvider: @escaping NSCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.ItemProvider,
                   supplementaryViewProvider: NSCollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>.SupplementaryViewProvider?) {
    self.init(collectionView: collectionView, itemProvider: itemProvider)
    self.supplementaryViewProvider = supplementaryViewProvider
  }
}

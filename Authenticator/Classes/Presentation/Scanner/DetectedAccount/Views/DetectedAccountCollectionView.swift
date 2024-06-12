//
//  DetectedAccountCollectionView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 28.04.2024.
//

import UIKit
import RxCocoa

class DetectedAccountCollectionView: UICollectionView {
    typealias Section = DetectedAccountSection
    typealias SectionItem = DetectedAccountSection.SectionItem
    
    let didTapAddRelay = PublishRelay<Void>()
    let deleteCodeRelay = PublishRelay<String>()
    
    private lazy var detectedDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: self) { collectionView, indexPath, item  in
        switch item {
        case let .backupCode(code):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BackupCodeCollectionViewCell.self), for: indexPath) as! BackupCodeCollectionViewCell
            cell.setup(code: code) { [weak self] in
                self?.deleteCodeRelay.accept($0)
            }
            return cell
        case let .code(model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: TOTPCodeCell.self), for: indexPath) as! TOTPCodeCell
            cell.setup(model: model)
            return cell
        case let .accountInfo(model, isSaved):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AccountInfoCell.self), for: indexPath) as! AccountInfoCell
            cell.setup(model: model, isSaved: isSaved)
            return cell
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetectedAccountCollectionView {
    func setup(elements: [Section]) {
        var snapshots = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshots.appendSections(elements)
        elements.forEach { section in
            snapshots.appendItems(section.items, toSection: section)
        }
        
        detectedDataSource.applySnapshotUsingReloadData(snapshots)
    }
}

private extension DetectedAccountCollectionView {
    func initialize() {
        register(BackupCodeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BackupCodeCollectionViewCell.self))
        register(TOTPCodeCell.self, forCellWithReuseIdentifier: String(describing: TOTPCodeCell.self))
        register(AccountInfoCell.self, forCellWithReuseIdentifier: String(describing: AccountInfoCell.self))
        
        
        register(BackupCodeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: BackupCodeHeaderView.self))
        register(BackupCodeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: BackupCodeFooterView.self))
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let section = self?.detectedDataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            switch section.type {
            case .accountInfo:
                return self?.accountInfoSection()
            case .backupCodes:
                return self?.backupCodesSection(isEmpty: section.items.isEmpty)
            case .code:
                return self?.codeSection()
            }
            
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 16.scale
        configuration.scrollDirection = .vertical
        layout.configuration = configuration
        
        layout.register(BackupCodeBackgroundView.self, forDecorationViewOfKind: Self.backgroundKind)
        setCollectionViewLayout(layout, animated: true)
        
        detectedDataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard case .backupCodes = self?.detectedDataSource.sectionIdentifier(for: indexPath.section)?.type else { return nil }
            
            if kind == UICollectionView.elementKindSectionHeader {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BackupCodeHeaderView.self), for: indexPath) as? BackupCodeHeaderView
                return view
            } else if kind == UICollectionView.elementKindSectionFooter {
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BackupCodeFooterView.self), for: indexPath) as? BackupCodeFooterView
                view?.setup { [weak self] in
                    self?.didTapAddRelay.accept(())
                }
                return view
            } else {
                return nil
            }
        }
    }
}

private extension DetectedAccountCollectionView {
    func createSnapShot(for section: Section) -> NSDiffableDataSourceSectionSnapshot<SectionItem> {
        var snapshot = NSDiffableDataSourceSectionSnapshot<SectionItem>()
        snapshot.append(section.items)
        return snapshot
    }
    
    func backupCodesSection(isEmpty: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(129), heightDimension: .absolute(37))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
        let itemsGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupeSize, subitems: [itemLayout])
        
        itemsGroup.interItemSpacing = .fixed(8.scale)
        
        let section = NSCollectionLayoutSection(group: itemsGroup)
        let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: Self.backgroundKind)
        
        section.decorationItems = [sectionBackground]
        section.contentInsets = .init(top: isEmpty ? 0 : 12.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale)
        section.interGroupSpacing = 12.scale
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20.scale)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .estimated(1.0),
            heightDimension: .estimated(37.scale)
        )
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottomLeading
        )
        
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        return section
    }
    
    func codeSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(100.scale))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
        let itemGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupeSize, subitems: [itemLayout])
        
        let section = NSCollectionLayoutSection(group: itemGroup)
        return section
    }
    
    func accountInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(140.scale))
        let itemLayout = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: itemSize.heightDimension)
        let itemGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupeSize, subitems: [itemLayout])
        
        let section = NSCollectionLayoutSection(group: itemGroup)
        section.contentInsets = .init(top: 16.scale, leading: 16.scale, bottom: 16.scale, trailing: 16.scale)
        return section
    }
    
    static let backgroundKind = "background-element-kind"
}

//
//  MenuCollectionView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 08.05.2024.
//

import UIKit
import RxCocoa

class MenuCollectionView: UICollectionView {
    
    typealias Section = MenuSection
    typealias SectionItem = MenuSection.SectionItem
    
    lazy var isOnRelay = PublishRelay<Bool>()
    lazy var learnMoreAction = PublishRelay<Void>()
    lazy var selectedElement = PublishRelay<SectionItem>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var menuDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: self) { collectionView, indexPath, item in
        switch item {
        case let .action(action):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuOneLabelActionCell.self), for: indexPath) as! MenuOneLabelActionCell
            cell.setup(action: action)
            return cell
        case let .actionWithIcon(action):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuOneLabelActionWithIconCell.self), for: indexPath) as! MenuOneLabelActionWithIconCell
            cell.setup(action: action)
            return cell
        case let .biometry(type, isOn):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuBiometricCell.self), for: indexPath) as! MenuBiometricCell
            cell.setup(type: type, isOn: isOn) { [weak self] isOn in
                self?.isOnRelay.accept(isOn)
            }
            return cell
        case .setup:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MenuLearnMoreViewCell.self), for: indexPath) as! MenuLearnMoreViewCell
            cell.setup { [weak self] in
                self?.learnMoreAction.accept(())
            }
            return cell
        }
    }
}

extension MenuCollectionView {
    func setup(elements: [Section]) {
        var snapshots = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshots.appendSections(elements)
        elements.forEach { section in
            snapshots.appendItems(section.items, toSection: section)
        }
        
        menuDataSource.applySnapshotUsingReloadData(snapshots)
    }
}

extension MenuCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let element = menuDataSource.itemIdentifier(for: indexPath) {
            selectedElement.accept(element)
        }
    }
}

private extension MenuCollectionView {
    func initialize() {
        register(MenuOneLabelActionCell.self, forCellWithReuseIdentifier: String(describing: MenuOneLabelActionCell.self))
        register(MenuOneLabelActionWithIconCell.self, forCellWithReuseIdentifier: String(describing: MenuOneLabelActionWithIconCell.self))
        register(MenuBiometricCell.self, forCellWithReuseIdentifier: String(describing: MenuBiometricCell.self))
        register(MenuLearnMoreViewCell.self, forCellWithReuseIdentifier: String(describing: MenuLearnMoreViewCell.self))
        register(MenuCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: MenuCollectionHeaderView.self))
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            
            guard let sectionType = self?.menuDataSource.sectionIdentifier(for: sectionIndex)?.section else { return nil }
            
            var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
            
            configuration.showsSeparators = false
            configuration.backgroundColor = .clear
            
            let section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            
            switch sectionType {
            case .account, .about:
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25.scale)),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
                
                header.contentInsets.leading = 16.scale
                header.contentInsets.trailing = 16.scale
                
                let sectionBackground = NSCollectionLayoutDecorationItem.background(elementKind: Self.backgroundKind)
            
                sectionBackground.contentInsets = .init(
                    top: header.layoutSize.heightDimension.dimension + 16.scale,
                    leading: 16.scale,
                    bottom: 0,
                    trailing: 16.scale
                )
                
                section.boundarySupplementaryItems = [header]
                section.decorationItems = [sectionBackground]
                section.interGroupSpacing = sectionType == .account ? 24.scale : 32.scale
                section.contentInsets = .init(
                    top: header.layoutSize.heightDimension.dimension + 16.scale,
                    leading: 32.scale,
                    bottom: 24.scale,
                    trailing: 32.scale
                )
            case .setup:
                section.contentInsets = .init(
                    top: 24.scale,
                    leading: 16.scale,
                    bottom: 0,
                    trailing: 16.scale
                )
            }
            
            return section
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 24.scale
        configuration.scrollDirection = .vertical
        layout.configuration = configuration
        
        layout.register(BackupCodeBackgroundView.self, forDecorationViewOfKind: Self.backgroundKind)
        setCollectionViewLayout(layout, animated: true)
        delegate = self
        contentInset.bottom = 56.scale
        
        menuDataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionType = self?.menuDataSource.sectionIdentifier(for: indexPath.section)?.section else { return nil }
            
            switch sectionType {
            case .account, .about:
                guard kind == UICollectionView.elementKindSectionHeader else { return nil }
                
                let view = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: String(describing: MenuCollectionHeaderView.self),
                    for: indexPath
                ) as? MenuCollectionHeaderView
                
                view?.setup(type: sectionType)
                return view
            case .setup:
                return nil
            }
        }
    }
}

private extension MenuCollectionView {
    static let backgroundKind = "background-element-kind"
}

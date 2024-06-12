//
//  CreateOrEditCollectionView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 04.05.2024.
//

import UIKit
import RxCocoa

class CreateOrEditCollectionView: UICollectionView {
    typealias Section = CreateOrEditSection
    typealias SectionItem = CreateOrEditSection.SectionItem
    
    let didTapAddRelay = PublishRelay<Void>()
    let deleteCodeRelay = PublishRelay<String>()
    let fieldValueRelay = PublishRelay<[Section.FieldType: String]>()
    let needUpdateCollectionView = PublishRelay<Void>()
    private var fields: [Section.FieldType: String] = [:] {
        didSet {
            fieldValueRelay.accept(fields)
        }
    }


    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var createOrEditDataSource = UICollectionViewDiffableDataSource<Section, SectionItem>(collectionView: self) { [weak self] collectionView, indexPath, item in
        switch item {
        case let .field(type, text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CreateOrEditFieldCell.self), for: indexPath) as! CreateOrEditFieldCell
            cell.setup(type: type, text: self?.fields[type] ?? text) { [weak self] in
                self?.update(item: indexPath)
            } changeText: { [weak self] in
                self?.fields[type] = $0
            }
            return cell
        case let .backupCode(code):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BackupCodeCollectionViewCell.self), for: indexPath) as! BackupCodeCollectionViewCell
            cell.setup(code: code) { [weak self] in
                print($0)
                self?.deleteCodeRelay.accept($0)
            }
            return cell
        }
    }
}

extension CreateOrEditCollectionView {
    func setup(elements: [Section]) {
        var snapshots = NSDiffableDataSourceSnapshot<Section, SectionItem>()
        snapshots.appendSections(elements)
        elements.forEach { section in
            snapshots.appendItems(section.items, toSection: section)
        }
        
        createOrEditDataSource.apply(snapshots, animatingDifferences: false)
    }
    
    func update(item: IndexPath) {
        guard let section = createOrEditDataSource.sectionIdentifier(for: item.section) else { return }
        let snap = createOrEditDataSource.snapshot(for: section)
        createOrEditDataSource.apply(snap, to: section)
    }
}

private extension CreateOrEditCollectionView {
    func initialize() {
        register(CreateOrEditFieldCell.self, forCellWithReuseIdentifier: String(describing: CreateOrEditFieldCell.self))
        register(BackupCodeCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: BackupCodeCollectionViewCell.self))
        
        register(BackupCodeHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: BackupCodeHeaderView.self))
        register(BackupCodeFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: BackupCodeFooterView.self))
        
        register(CreateOrEditFooterFieldView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: CreateOrEditFooterFieldView.self))
        
        allowsMultipleSelection = false
        
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let section = self?.createOrEditDataSource.sectionIdentifier(for: sectionIndex) else { return nil }
            switch section.type {
            case let .field(example):
                return self?.fieldSection(example: example, layoutEnvironment: layoutEnvironment)
            case .backupCodes:
                return self?.backupCodesSection(isEmpty: section.items.isEmpty)
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 16.scale
        configuration.scrollDirection = .vertical
        layout.configuration = configuration
        
        layout.register(BackupCodeBackgroundView.self, forDecorationViewOfKind: Self.backgroundKind)
        setCollectionViewLayout(layout, animated: true)
        showsVerticalScrollIndicator = false
        
        createOrEditDataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let sectionType = self?.createOrEditDataSource.sectionIdentifier(for: indexPath.section)?.type else { return nil }
            
            switch sectionType {
            case let .field(example):
                guard kind == UICollectionView.elementKindSectionFooter, let value = example else { return nil }
                let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CreateOrEditFooterFieldView.self), for: indexPath) as? CreateOrEditFooterFieldView
                view?.setup(example: value)
                return view
            case .backupCodes:
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BackupCodeHeaderView.self), for: indexPath) as? BackupCodeHeaderView
                    return view
                case UICollectionView.elementKindSectionFooter:
                    let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: BackupCodeFooterView.self), for: indexPath) as? BackupCodeFooterView
                    view?.setup { [weak self] in
                        self?.didTapAddRelay.accept(())
                    }
                    return view
                default:
                    return nil
                }
            }
        }
    }
    
    func fieldSection(example: String?, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        var conf = UICollectionLayoutListConfiguration(appearance: .plain)
        conf.showsSeparators = false
        conf.backgroundColor = .clear
        
        let section = NSCollectionLayoutSection.list(using: conf, layoutEnvironment: layoutEnvironment)
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(20.scale)
        )
        
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottomLeading
        )
        
        section.boundarySupplementaryItems = example == nil ? [] : [sectionFooter]
        return section
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
    
    static let backgroundKind = "background-element-kind"
}

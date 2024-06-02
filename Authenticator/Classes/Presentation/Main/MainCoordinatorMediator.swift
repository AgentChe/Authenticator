//
//  MainCoordinatorMediator.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 26.05.2024.
//

import RxSwift
import RxCocoa

class MainCoordinatorMediator {
    static let shared = MainCoordinatorMediator()
    
    var selectedTab: Observable<TabView.Tab> {
        selectedTabRelay.asObservable()
    }
    
    private let selectedTabRelay = PublishRelay<TabView.Tab>()
    
    private init() {}
    
    func updateTab(tab: TabView.Tab) {
        selectedTabRelay.accept(tab)
    }
}

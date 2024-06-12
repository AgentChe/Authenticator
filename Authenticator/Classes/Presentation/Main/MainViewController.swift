//
//  MainViewController.swift
//  Printer
//
//  Created by Андрей Чернышев on 24.04.2024.
//

import UIKit
import RxSwift
import Toast_Swift

final class MainViewController: UIViewController {
    
    lazy var mainView = MainView()
    private lazy var coordinator = MainViewCoordinator(parentVC: self)
    
    private lazy var disposeBag = DisposeBag()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ToastManager.shared.style = makeToastStyle()
        rx.methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.update(selectedTab: .accounts)
            })
            .disposed(by: disposeBag)
        
        addActionsToTabs()
    }
}

// MARK: Make
extension MainViewController {
    static func make() -> MainViewController {
        let vc = MainViewController()
        vc.navigationController?.setNavigationBarHidden(true, animated: false)
        return vc
    }
}

// MARK: Private
private extension MainViewController {
    func makeToastStyle() -> ToastStyle {
        var style = ToastStyle()
        style.verticalPadding = 8.scale
        style.horizontalPadding = 16.scale
        style.messageFont = Fonts.Inter.semiBold(size: 16.scale)
        style.messageColor = Appearance.black
        style.backgroundColor = Appearance.primary
        style.cornerRadius = 16.scale
        return style
    }
    func addActionsToTabs() {
       Observable
           .merge([
               mainView.tabView.accountsItem
                   .rx.tap.map { TabView.Tab.accounts },
               
               mainView.tabView.scanItem
                   .rx.tap.map { TabView.Tab.scan },
               
               mainView.tabView.menuItem
                   .rx.tap.map { TabView.Tab.menu },
               MainCoordinatorMediator.shared.selectedTab
           ])
           .subscribe(onNext: { [weak self] tab in
               self?.update(selectedTab: tab)
           })
           .disposed(by: disposeBag)
    }
    
    func update(selectedTab: TabView.Tab) {
        coordinator.change(tab: selectedTab)
    }
}

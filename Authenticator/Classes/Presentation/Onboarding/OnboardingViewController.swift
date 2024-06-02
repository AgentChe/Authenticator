//
//  OnboardingViewController.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit
import RxSwift

final class OnboardingViewController: UIViewController {
    struct Constants {
        static let wasViewedKey = "onboarding_view_controller_was_viewed_key"
    }
    
    lazy var mainView = OnboardingView()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var viewModel = OnboardingViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocalAuthenticationManager().deletePassword()
        mainView.didFinish = { [weak self] in
            guard let self = self else {
                return
            }
            
            self.markAsViewed()
            
//            let step = self.viewModel.whatNext()
            self.goToNext(at: .password)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: Make
extension OnboardingViewController {
    static func make() -> OnboardingViewController {
        OnboardingViewController()
    }
}

// MARK: Public
extension OnboardingViewController {
    static func wasViewed() -> Bool {
        UserDefaults.standard.bool(forKey: OnboardingViewController.Constants.wasViewedKey)
    }
}

// MARK: Private
private extension OnboardingViewController {
    func markAsViewed() {
        UserDefaults.standard.setValue(true, forKey: Constants.wasViewedKey)
    }
    
    func goToNext(at step: OnboardingViewModel.Step) {
        switch step {
        case .main:
            let main = NavigationController(rootViewController: MainViewController.make())
            main.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController = main
        case .paygate:
            let vc = PaygateViewController.make { [weak self] in
                self?.goToNext(at: .main)
            }
            present(vc, animated: true)
        case .password:
            let vc = PasswordViewController.make { [weak self] in
                self?.goToNext(at: .paygate)
            }
            present(vc, animated: true)
        }
    }
}

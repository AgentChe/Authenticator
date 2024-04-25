//
//  OnboardingView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 23.08.2022.
//

import UIKit

final class OnboardingView: UIView {
    enum Step: Int {
        case welcome1, welcome2, welcome3
    }
    
    var didFinish: (() -> Void)?
    
    lazy var backgroundView = makeBackgroundView()
    lazy var pageIndicator = makePageIndicator()
    
    private lazy var contentViews: [OSlideView] = {
        [
            OWelcomeView(step: .welcome1, number: 1),
            OWelcomeView(step: .welcome2, number: 2),
            OWelcomeView(step: .welcome3, number: 3)
        ]
    }()
    
    private var step = Step.welcome1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        updatePage()
        hiddenPageIndicatorIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: OSlideViewDelegate
extension OnboardingView: OSlideViewDelegate {
    func slideViewDidNext(from step: Step) {
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            didFinish?()
            
            return
        }
        
        scroll(to: nextStep) { [weak self] in
            self?.updatePage()
            self?.hiddenPageIndicatorIfNeeded()
        }
    }
    
    func slideViewDidBack(from step: OnboardingView.Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        scroll(to: previousStep) { [weak self] in
            self?.updatePage()
            self?.hiddenPageIndicatorIfNeeded()
        }
    }
    
    func slideViewDidSkip() {
        didFinish?()
    }
}

// MARK: Private
private extension OnboardingView {
    func initialize() {
        contentViews
            .enumerated()
            .forEach { [weak self] index, view in
                view.frame.size = CGSize(width: UIScreen.main.bounds.width,
                                         height: UIScreen.main.bounds.height)
                
                view.clipsToBounds = true
                view.delegate = self
                
                if index == 0 {
                    view.frame.origin = CGPoint(x: 0, y: 0)
                    self?.addSubview(view)
                    
                    view.moveToThis()
                }
            }
    }
    
    func scroll(to newStep: Step, completion: (() -> Void)? = nil) {
        let currentIndex = step.rawValue
        let scrollToIndex = newStep.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = contentViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = contentViews[currentIndex]
        let scrollToView = contentViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 375.scale * CGFloat(direction), y: 0)
        addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 375.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.step = newStep
            
            completion?()
        })
    }
    
    func updatePage() {
        pageIndicator.page = step.rawValue + 1
    }
    
    func hiddenPageIndicatorIfNeeded() {
        let isWelcome = (step == .welcome1) || (step == .welcome2) || (step == .welcome3)
        pageIndicator.isHidden = !isWelcome
    }
}

// MARK: Make constraints
private extension OnboardingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pageIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageIndicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -159.scale : -129.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension OnboardingView {
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.image = UIImage(named: "Background")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePageIndicator() -> OPageIndicatorView {
        let view = OPageIndicatorView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

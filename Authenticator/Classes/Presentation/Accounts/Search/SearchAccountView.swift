//
//  SearchAccountView.swift
//  Authenticator
//
//  Created by Vitaliy Zagorodnov on 19.05.2024.
//
import UIKit

final class SearchAccountView: UIView {
    
    lazy var searchField = makeSearchField()
    lazy var cancelButton = makeCancelButton()
    lazy var backgroundView = makeBackgroundView()
    lazy var tableView = makeTableView()
    private lazy var emptyImage = makeEmptyIcon()
    private lazy var emptyText = makeEmptyText()
    
    private var searchConstraint: NSLayoutConstraint?
    private var cancelConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeConstraints()
        tableView.transform = CGAffineTransform(translationX: 0, y: 100.scale)
        alpha = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(isEmpty: Bool) {
        emptyImage.isHidden = !isEmpty
        emptyText.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }
    
    func showCancel(isShow: Bool, completion: (() -> Void)? = nil) {
        searchConstraint?.isActive = false
        cancelConstraint?.isActive = false
        
        searchConstraint = isShow
            ? searchField.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8.scale)
            : searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        
        cancelConstraint = isShow
            ? cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
            : cancelButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        
        searchConstraint?.isActive = true
        cancelConstraint?.isActive = true
        
        let animation = isShow ? CGAffineTransform.identity : CGAffineTransform(translationX: 0, y: 100.scale)
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
            self.tableView.transform = animation
            self.alpha = isShow ? 1 : 0
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: Make constraints
private extension SearchAccountView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let searchConstraint = searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        self.searchConstraint = searchConstraint
        NSLayoutConstraint.activate([
            searchConstraint,
            searchField.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 68.scale : 24.scale),
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale)
        ])
        
        let cancelConstraint = cancelButton.leadingAnchor.constraint(equalTo: trailingAnchor)
        self.cancelConstraint = cancelConstraint
        NSLayoutConstraint.activate([
            cancelButton.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            cancelConstraint
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16.scale),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            emptyImage.heightAnchor.constraint(equalToConstant: 100.scale),
            emptyImage.widthAnchor.constraint(equalTo: emptyImage.heightAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyImage.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 148.scale)
        ])
        
        NSLayoutConstraint.activate([
            emptyText.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 16.scale),
            emptyText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            emptyText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SearchAccountView { 
    func makeBackgroundView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "Background")
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchField() -> SearchTextField {
        let view = SearchTextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeCancelButton() -> UIButton {
        let attrs = TextAttributes()
            .font(Fonts.Inter.regular(size: 16.scale))
            .lineHeight(22.4.scale)
            .textColor(Appearance.secondary)
            .textAlignment(.right)
        let view = UIButton()
        view.setAttributedTitle("Cancel".attributed(with: attrs), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> SearchTableView {
        let view = SearchTableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        addSubview(view)
        return view
    }
    
    func makeEmptyIcon() -> UIImageView {
        let view = UIImageView(image: UIImage(named: "Search.Empty"))
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeEmptyText() -> UILabel {
        let attrs = TextAttributes()
            .font(Fonts.Inter.semiBold(size: 18.scale))
            .lineHeight(25.2.scale)
            .textColor(Appearance.white)
            .textAlignment(.center)
        
        let view = UILabel()
        view.isHidden = true
        view.attributedText = "Search.Empty".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

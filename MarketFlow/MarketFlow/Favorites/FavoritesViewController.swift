//
//  FavoritesViewController.swift
//  MarketFlow
//
//  Created by İrem Onart on 17.01.2025.
//

import UIKit
import Kingfisher

class FavoritesViewController: UIViewController {
    private let tableView = UITableView()
    
    // Favori ürünlerin listesi
    private var favoriteProducts: [Favorites] = []
    var viewModel: FavoritesViewModelProtocol?
    
    // Safe area background view
    private let safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        attachViewModel()
        setUpNavigationBar()
        viewModel?.fetchFavItems()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritesUpdate), name: .favoritesUpdated, object: nil)
    }
    
    func setUpNavigationBar() {
        // Başlığı sola yaslamak için bir UIView oluşturuyoruz
        let titleLabel = UILabel()
        titleLabel.text = "Favorites"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textAlignment = .left
        
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Title label için Auto Layout kısıtlamalarını ekliyoruz
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        ])
        
        // TitleContainer boyutu ayarlanıyor
        titleContainer.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        
        // Navigation bar'a sol tarafa ekliyoruz
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleContainer)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        
        // TableView yapılandırması
        tableView.register(FavoriteTableViewCell.self, forCellReuseIdentifier:
        FavoriteTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(safeAreaBackgroundView)
        view.addSubview(tableView)
        
        // Constraints for safe area background view
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // AutoLayout ile TableView konumlandırma
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    private func attachViewModel() {
        viewModel?.changeHandler = { [weak self] change in
            guard let self else { return }
            switch change  {
            case .didError(let message):
                showErrorPopup(message: message)
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print(self.viewModel?.favItems.count)
                }
            case .emptyPage:
                setCartEmtpyPopUp()
            default:
                return
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .favoritesUpdated, object: nil)
    }
    
    @objc private func handleFavoritesUpdate() {
        viewModel?.fetchFavItems() // Favori ürünleri yeniden yükle
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showErrorPopup(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setCartEmtpyPopUp() {
        let alertController = UIAlertController(title: "Favorites is cart", message: "Add your favorites please!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDataSource ve UITableViewDelegate
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numOfFavItems ?? 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.identifier, for: indexPath) as? FavoriteTableViewCell else {
            return UITableViewCell()
        }
        
        let product = viewModel?.indexOfUsers(for: indexPath) ?? Favorites()
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}


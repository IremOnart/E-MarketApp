//
//  ProductDetailViewController.swift
//  MarketFlow
//
//  Created by İrem Onart on 16.01.2025.
//

import UIKit
import Kingfisher
import CoreData

class ProductDetailViewController: UIViewController {
    
    // UI Elements
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Apple iPhone 14 Pro Max 256 GB"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let productDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sodales nibh pretium ipsum faucibus, a commodo tortor blandit. Duis pellentesque, purus sed gravida sagittis, tortor urna eleifend ante, a volutpat ex est vel ipsum.
        """
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Safe area background view
        private let safeAreaBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Price:"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "124124124 ₺"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var viewModel: ProductDetailViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        setupUI()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        // Ortalanmış başlık için bir UILabel oluşturuyoruz
        let titleLabel = UILabel()
        titleLabel.text = viewModel?.productTitle ?? "Product Detail"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Title view container
        let titleContainer = UIView()
        titleContainer.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: titleContainer.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainer.centerYAnchor)
        ])
        
        titleContainer.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        navigationItem.titleView = titleContainer
        
        // Geri butonunu özelleştirme
        let backButton = UIButton(type: .system)
        let backButtonImage = UIImage(systemName: "arrow.left")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        backButton.setImage(backButtonImage, for: .normal) // Sistem ikonu ve renk
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }


    
    func setupUI() {
        // Add subviews
        
        if let urlString = viewModel?.productImage, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        productTitleLabel.text = viewModel?.productTitle
        productDescriptionLabel.text = viewModel?.productDiscription
        productImageView.contentMode = .scaleAspectFill
        productImageView.clipsToBounds = true
        priceLabel.text = viewModel?.price
        
        view.addSubview(safeAreaBackgroundView)
        view.addSubview(productImageView)
        view.addSubview(productTitleLabel)
        view.addSubview(productDescriptionLabel)
        view.addSubview(priceTitleLabel) // priceTitleLabel eklendi
        view.addSubview(priceLabel)
        view.addSubview(addToCartButton)
        
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        // Constraints for safe area background view
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
                
        // Constraints
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productImageView.heightAnchor.constraint(equalToConstant: 200),
            
            productTitleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            productTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            productDescriptionLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 12),
            productDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            productDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            priceTitleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -4), // Title label yukarıda olacak
            priceTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priceLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            addToCartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addToCartButton.widthAnchor.constraint(equalToConstant: 180),
            addToCartButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func addToCartTapped() {
        // price'ı String'den Double'a çevirmeye çalışalım
        if let priceString = viewModel?.price, let price = Double(priceString) {
            // CoreData'ya yeni bir ürün ekle
            CoreDataManager.shared.addCartItem(id: viewModel?.id ?? "", name: viewModel?.productTitle ?? "", price: price)
            // Sepet güncellenirse Notification gönder (isteğe bağlı)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } else {
            print("Geçersiz fiyat değeri: \(viewModel?.productTitle ?? "")")
        }
    }

}

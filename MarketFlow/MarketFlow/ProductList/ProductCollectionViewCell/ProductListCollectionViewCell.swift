//
//  ProductListCollectionViewCell.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import UIKit
import Kingfisher
import CoreData

class ProductListCollectionViewCell: UICollectionViewCell {
    static let identifier: String = "ProductListCollectionViewCell"
    
    // UI bileşenleri
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.heightAnchor.constraint(equalToConstant: 40).isActive = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Yıldız butonu
    let starButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        button.tintColor = .white // Başlangıçta gri
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Product model (Bu modelinizi Cell'e veri sağlamak için kullanacaksınız)
    var product: MarketProductElement?
    
    // Favori durumu
    private var isFavorite: Bool = false {
        didSet {
            updateStarButtonAppearance()
        }
    }
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpShadow() // Gölgeyi eklemek için ayrı bir fonksiyon
        
        // addToCartButton'a tıklama işlevi ekle
        addToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        
        // Yıldız butonuna tıklama işlevi ekle
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI bileşenlerini düzenleme
    private func setUpUI() {
        contentView.addSubview(productImageView)
        contentView.addSubview(priceLabel)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(addToCartButton)
        contentView.addSubview(starButton) // Yıldız butonunu ekle
        
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        
        // Auto Layout ile yerleştir
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            productImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5),
            
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            productNameLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            addToCartButton.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            addToCartButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            addToCartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addToCartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            addToCartButton.heightAnchor.constraint(equalToConstant: 40),
            
            // Yıldız butonunun sağ üst köşeye yerleştirilmesi
            starButton.topAnchor.constraint(equalTo: productImageView.topAnchor, constant: 5),
            starButton.trailingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: -5),
            starButton.widthAnchor.constraint(equalToConstant: 25),
            starButton.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    private func setUpShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        backgroundColor = .clear
    }
    
    // Hücreyi doldurmak için bir fonksiyon
    func configure(with product: MarketProductElement) {
        self.product = product
        if let urlString = product.image, let url = URL(string: urlString) {
            productImageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        }
        priceLabel.text = "\(product.price ?? "") ₺"
        productNameLabel.text = product.name
        
        // Favori durumu başlatmak için
//        if let isFavoriteProduct = product.isFavorite {
//            self.isFavorite = isFavoriteProduct
//        }
    }
    
    // Add to Cart button tıklama işlevi
    @objc private func addToCartTapped() {
        guard let product = product else { return }
        if let priceString = product.price, let price = Double(priceString) {
            // CoreData'ya yeni bir ürün ekle
            CoreDataManager.shared.addCartItem(id: product.id ?? "", name: product.name ?? "", price: price)
            // Sepet güncellenirse Notification gönder
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        } else {
            print("Geçersiz fiyat değeri: \(product.price ?? "")")
        }
    }
    
    // Yıldız butonuna tıklama işlevi
    @objc private func starButtonTapped() {
        isFavorite.toggle()
        // Favori durumu değiştirilirse, güncelleme işlemi yapılabilir
//        product?.isFavorite = isFavorite
        print("Favori durumu: \(isFavorite ? "Favori" : "Favori Değil")")
    }
    
    // Yıldız butonunun rengini güncelleme
    private func updateStarButtonAppearance() {
        if isFavorite {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .orange
        } else {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .white
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        priceLabel.text = nil
        productNameLabel.text = nil
    }
}


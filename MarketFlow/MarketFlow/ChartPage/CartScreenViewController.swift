//
//  CartScreenViewController.swift
//  MarketFlow
//
//  Created by İrem Onart on 15.01.2025.
//

import UIKit

class CartScreenViewController: UIViewController {
    
    // MARK: - Properties
    private var products: [CartProduct] = [
        CartProduct(name: "Samsung s22", price: 12000, quantity: 2),
        CartProduct(name: "Lenovo PC", price: 18000, quantity: 1),
        CartProduct(name: "iPhone 12", price: 15000, quantity: 5)
    ]
    
    // MARK: - UI Elements
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "Total:"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "0 ₺"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Complete", for: .normal)
        button.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Safe area background view
        private let safeAreaBackgroundView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
    var viewModel: CartScreenViewModelProtocol? = CartScreenViewModel()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        attachViewModel()
        setUpNavigationBar()
        viewModel?.fetchCartItems()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshCart), name: .cartUpdated, object: nil)
    }
    
    private func attachViewModel() {
        viewModel?.changeHandler = { [weak self] change in
            guard let self else { return }
            switch change  {
            case .didError(let message):
                showErrorPopup(message: message)
            case .success:
                setupProducts()
                print("cart ıtems \(viewModel?.cartItems)")
                print(viewModel?.cartItems.count)
                calculateTotal()
            case .emptyPage:
                setCartEmtpyPopUp()
            default:
                return
            }
        }
    }
    
    func showErrorPopup(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func setUpNavigationBar() {
        // Başlığı sola yaslamak için bir UIView oluşturuyoruz
        let titleLabel = UILabel()
        titleLabel.text = "E-Market"
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
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(safeAreaBackgroundView)
        // Constraints for safe area background view
        NSLayoutConstraint.activate([
            safeAreaBackgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            safeAreaBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            safeAreaBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            safeAreaBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.view.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        
        // ScrollView ve StackView ekleme
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // Ana stackView'i ekliyoruz
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)

        // Empty View (StackView'e yerleştirilecek boş bir alan)
        let emptyView = UIView()
        emptyView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        // StackView ve Buton yüksekliğini ayarlıyoruz
        completeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let totalStackView = UIStackView()
        totalStackView.axis = .vertical
        totalStackView.spacing = 8
        totalStackView.addArrangedSubview(totalLabel)
        totalStackView.addArrangedSubview(totalPriceLabel)
        
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(totalStackView)
        view.addSubview(completeButton)

        // StackView ve ScrollView Constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: totalStackView.topAnchor, constant: -16) // totalStackView ile araya mesafe bırak
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // StackView genişliği ScrollView ile aynı olacak
        ])
        
        // totalStackView ve completeButton için constraints
        NSLayoutConstraint.activate([
            totalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            totalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            totalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            completeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 180),
            completeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // StackView'e emptyView ekliyoruz
        stackView.addArrangedSubview(emptyView)
        
        // Eğer stackView içinde sadece 1 eleman varsa empty ekranını göster
        if stackView.arrangedSubviews.count == 1 {
            showEmptyState()
        }
    }

    private func showEmptyState() {
        // Empty state UI ekleme işlemi
        let emptyStateLabel = UILabel()
        emptyStateLabel.text = "Empty Cart"
        emptyStateLabel.textAlignment = .center
        emptyStateLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emptyStateLabel)
    }
    
    // Tabbar'daki badge'ı günceller
    func updateBadge() {
        guard let cartItems = viewModel?.cartItems else {
            return
        }
        
        let totalQuantity = cartItems.reduce(0) { $0 + $1.quantity }
        
        if totalQuantity > 0 {
            tabBarController?.tabBar.items?[1].badgeValue = "\(totalQuantity)" // İkinci item'ı seçtiğimizi varsayıyoruz
        } else {
            tabBarController?.tabBar.items?[1].badgeValue = nil
        }
    }

    func setCartEmtpyPopUp() {
        let alertController = UIAlertController(title: "empty is cart", message: "Add Product to Your Cart", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func refreshCart() {
        viewModel?.fetchCartItems()
        setupProducts()  // Ekranı yeniden yapılandır
        calculateTotal()
        updateBadge()
    }

    
    @objc private func setupProducts() {
        // StackView'i temizle
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        guard let cartItems = viewModel?.cartItems, !cartItems.isEmpty else {
            print("Cart items are empty or nil.")
            return
        }
        
        // Ürünleri stackView'e eklendi
        for product in cartItems {
            print("Product: \(product.id)")
            let productView = ProductItemView(product: product)
            productView.delegate = self
            stackView.addArrangedSubview(productView)
        }
        
        updateBadge()
    }


    func calculateTotal() {
        guard let cartItems = viewModel?.cartItems else {
            return
        }
        let total = cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        totalPriceLabel.text = "\(Int(total)) ₺"
    }

}

// MARK: - Product Item View
class ProductItemView: UIView {
    private var product: CartInfos?
    weak var delegate: CartScreenViewController?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemBlue
        return label
    }()
    
    private let quantityControl: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let quantityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .systemBlue
        label.textColor = .white
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    init(product: CartInfos) {
        self.product = product
        super.init(frame: .zero)
        setupUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let labelsStack = UIStackView()
        labelsStack.axis = .vertical
        labelsStack.spacing = 4
        labelsStack.addArrangedSubview(nameLabel)
        labelsStack.addArrangedSubview(priceLabel)
        
        addSubview(labelsStack)
        addSubview(quantityControl)
        
        quantityControl.addSubview(minusButton)
        quantityControl.addSubview(quantityLabel)
        quantityControl.addSubview(plusButton)
        
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        quantityControl.translatesAutoresizingMaskIntoConstraints = false
        minusButton.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 60),
            
            labelsStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStack.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            quantityControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            quantityControl.centerYAnchor.constraint(equalTo: centerYAnchor),
            quantityControl.widthAnchor.constraint(equalToConstant: 120),
            quantityControl.heightAnchor.constraint(equalToConstant: 40),
            
            minusButton.leadingAnchor.constraint(equalTo: quantityControl.leadingAnchor),
            minusButton.topAnchor.constraint(equalTo: quantityControl.topAnchor),
            minusButton.bottomAnchor.constraint(equalTo: quantityControl.bottomAnchor),
            minusButton.widthAnchor.constraint(equalToConstant: 40),
            
            quantityLabel.centerXAnchor.constraint(equalTo: quantityControl.centerXAnchor),
            quantityLabel.topAnchor.constraint(equalTo: quantityControl.topAnchor),
            quantityLabel.bottomAnchor.constraint(equalTo: quantityControl.bottomAnchor),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            
            plusButton.trailingAnchor.constraint(equalTo: quantityControl.trailingAnchor),
            plusButton.topAnchor.constraint(equalTo: quantityControl.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: quantityControl.bottomAnchor),
            plusButton.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    private func configure() {
        nameLabel.text = product?.name
        priceLabel.text = "\(Int(product?.price ?? 0.0)) ₺"
        quantityLabel.text = "\(product?.quantity ?? 0)"
    }
    
    @objc private func minusButtonTapped() {
        // Öncelikle ürünün quantity değerini kontrol edelim
        if product?.quantity ?? 0 > 0 {
            // quantity değerini azalt
            quantityLabel.text = "\(product?.quantity ?? 0)"
            
            // Core Data'da bu ürünü bulup quantity değerini güncelle
            if let productID = product?.id { // Eğer ID'yi kullanarak ürünü bulabiliyorsak
                delegate?.viewModel?.decreaseCartItemQuantity(id: productID)
                NotificationCenter.default.post(name: .cartUpdated, object: nil)
            }
            
            // Toplamı hesapla
            delegate?.calculateTotal()
        }
    }
    
    @objc private func plusButtonTapped() {
        quantityLabel.text = "\(product?.quantity ?? 0)"
        
        if let productID = product?.id { // Eğer ID'yi kullanarak ürünü bulabiliyorsak
            delegate?.viewModel?.addCartItem(id: productID)
            NotificationCenter.default.post(name: .cartUpdated, object: nil)
        }
        
        delegate?.calculateTotal()
    }
}

// MARK: - Model
struct CartProduct {
    let name: String
    let price: Double
    var quantity: Int
}

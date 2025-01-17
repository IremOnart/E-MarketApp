//
//  ProductListViewController.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import UIKit

class ProductListViewController: UIViewController {
    
    var viewModel: ProductListViewModelProtocol? = ProductListViewModel()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let searchBar = UISearchBar()
    private var filteredProducts: [MarketProductElement] = []
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)  // Font ekleniyor
        return label
    }()
    
    
    private let filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Filter", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .white
        stackView.alignment = .center
        return stackView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel?.fetchProducts()
//        collectionView.reloadData()
        self.view.backgroundColor = UIColor(red: 29/255, green: 86/255, blue: 255/255, alpha: 1.0)
        attachViewModel()
        filteredProducts.append(contentsOf: viewModel?.filteredProductList ?? [])
        print(viewModel?.filteredProductList)
        print(filteredProducts)
    }
    
    // ViewModel'e changeHandler ekleyerek verilerdeki değişiklikleri dinle
    private func attachViewModel() {
        viewModel?.changeHandler = { [weak self] change in
            guard let self = self else { return }
            
            switch change  {
            case .didError(let message):
                self.showErrorPopup(message: message)
                self.activityIndicator.stopAnimating()  // Hata durumunda loading'i durdur
            case .success:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()  // Ana thread üzerinde tabloyu yeniden yükle
                    self.activityIndicator.stopAnimating()  // Yükleme tamamlandığında indicator'ı durdur
                }
            default:
                break
            }
        }
    }

    
    func setUpUI() {
        setUpNavigationBar()
        setSearchBar()
        setFilterStackView()
        setCollectionView()
        setUpLoadingIndicator()
        activityIndicator.startAnimating()
    }
    
    func setUpLoadingIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
    
    
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        // Arka plan çizgilerini kaldırmak için
        searchBar.backgroundImage = UIImage()  // Çizgileri kaldırır
        searchBar.backgroundColor = .white
        
        // TextField'a stil vermek için searchBar.searchTextField kullanıyoruz
        let textField = searchBar.searchTextField
        textField.backgroundColor = UIColor(white: 0.97, alpha: 1)  // Rengi açmak için beyaz tonunu kullanabiliriz
        textField.layer.cornerRadius = 6  // Köşe yuvarlama
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.heightAnchor.constraint(equalToConstant: 30).isActive = true  // Yüksekliği artırıyoruz
        
        // Arama çubuğunun stilini daha da özelleştirmek için
        searchBar.barTintColor = UIColor.white  // Arka plan rengini değiştirebilirsiniz
        
        // SearchBar'ı görünümde ekliyoruz
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    
    func setFilterStackView() {
        // FilterStackView'i yerleştiriyoruz
        view.addSubview(filterStackView)
        
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.addSubview(filterButton)
        // FilterLabel ve FilterButton'ı stack view'e ekliyoruz
        filterStackView.addArrangedSubview(filterLabel)
        filterStackView.addArrangedSubview(buttonContainer)
        
        filterButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -16).isActive = true
        filterButton.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor).isActive = true
        filterButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor).isActive = true
        filterButton.widthAnchor.constraint(equalToConstant: (view.frame.width / 2 - 30)).isActive = true
        
        filterLabel.leadingAnchor.constraint(equalTo: filterStackView.leadingAnchor, constant: 16).isActive = true
        filterLabel.bottomAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: -10).isActive = true
        filterLabel.topAnchor.constraint(equalTo: filterStackView.topAnchor, constant: 10).isActive = true
        filterLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        buttonContainer.trailingAnchor.constraint(equalTo: filterStackView.trailingAnchor, constant: -16).isActive = true
        buttonContainer.bottomAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: -10).isActive = true
        buttonContainer.topAnchor.constraint(equalTo: filterStackView.topAnchor, constant: 10).isActive = true
        
        filterButton.addTarget(self, action: #selector(openFilterModal), for: .touchUpInside)
        
        // Auto Layout kısıtlamalarını ekliyoruz
        NSLayoutConstraint.activate([
            filterStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterStackView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setCollectionView() {
        // Layout ayarları
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        collectionView.layer.borderWidth = 0
        collectionView.layer.borderColor = UIColor.clear.cgColor
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Auto Layout ile collectionView yerleştir
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterStackView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.register(ProductListCollectionViewCell.self, forCellWithReuseIdentifier: "ProductListCollectionViewCell")
    }
    
    @objc func openFilterModal() {
        let filterVC = FilterViewController()
        filterVC.modalPresentationStyle = .pageSheet
        filterVC.delegate = self
        let navigationController = UINavigationController(rootViewController: filterVC)
        filterVC.navigationItem.title = "Filter Options"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 24),
            .foregroundColor: UIColor.black
        ]
        navigationController.navigationBar.titleTextAttributes = attributes
        present(navigationController, animated: true, completion: nil)

    }
    
    // Hata mesajını gösteren popup
    func showErrorPopup(message: String, title: String = "Error") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewModel = viewModel else { return }
        
        if searchText.isEmpty {
            viewModel.resetFilter() // Arama metni boşsa filtreyi sıfırla
        } else {
            viewModel.searchProducts(by: searchText) // Arama metnine göre filtrele
        }
        collectionView.reloadData() // Koleksiyon görünümünü güncelle
    }
}

extension ProductListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numOfProducts ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductListCollectionViewCell", for: indexPath) as! ProductListCollectionViewCell
        guard let product = viewModel?.productListItem(for: indexPath) else {
            return UICollectionViewCell() // Boş bir hücre döndür
        }
        cell.configure(with: product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ProductDetailViewController()
        let vm = ProductDetailViewModel(productImage: viewModel?.filteredProductList[indexPath.row].image ?? "", productTitle: viewModel?.filteredProductList[indexPath.row].name ?? "", productDiscription: viewModel?.filteredProductList[indexPath.row].description ?? "", price: viewModel?.filteredProductList[indexPath.row].price ?? "", id: viewModel?.filteredProductList[indexPath.row].id ?? "")
        vc.viewModel = vm
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Hücre boyutunu belirleme
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let totalPadding = padding * 3
        let availableWidth = collectionView.frame.width - totalPadding
        let availableHeight = collectionView.frame.height / 2
        let widthPerItem = availableWidth / 2
        return CGSize(width: widthPerItem, height: availableHeight - totalPadding)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        if offsetY > contentHeight - frameHeight * 1.1,
           viewModel?.isLastPage == false {
            viewModel?.fetchProducts()
        }
    }
}

extension ProductListViewController: FilterViewControllerDelegate {
    
    func didApplyFilter(name: String, price: Double, brand: String, model: String) {
        // Filtreleri al ve ürünleri filtrele
        viewModel?.filterProducts(name: name, price: price, brand: brand, model: model)
        
        // Filtrelenmiş ürünleri al
        filteredProducts = viewModel?.filteredProductList ?? []
        
        // Koleksiyon View'ı verisini güncelle
        collectionView.reloadData()
    }
    
    func didClearFilter() {
        viewModel?.resetFilter()
        collectionView.reloadData()
    }
    
}

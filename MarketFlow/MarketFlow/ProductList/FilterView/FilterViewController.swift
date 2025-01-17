//
//  FilterView.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation
import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didApplyFilter(name: String, price: Double, brand: String, model: String)
    func didClearFilter()
}

class FilterViewController: UIViewController {
    
    // Delegate
    weak var delegate: FilterViewControllerDelegate?
    
    // UI Elemanları
    private let priceTextField = UITextField()
    private let nameTextField = UITextField()
    private let brandTextField = UITextField()
    private let modelTextField = UITextField()
    
    private let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Apply", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private let clearFilterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Clear Filter", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // Set the title in the navigation bar
        self.navigationItem.title = "Filter Options" // Set your title here
        
        setupUI()
    }
    
    private func setupUI() {
        // TextField ve Button yerleşimi
        priceTextField.placeholder = "Max Price"
        priceTextField.borderStyle = .roundedRect
        priceTextField.keyboardType = .decimalPad
        nameTextField.placeholder = "Name"
        nameTextField.borderStyle = .roundedRect
        brandTextField.placeholder = "Brand"
        brandTextField.borderStyle = .roundedRect
        modelTextField.placeholder = "Model"
        modelTextField.borderStyle = .roundedRect
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        priceTextField.translatesAutoresizingMaskIntoConstraints = false
        brandTextField.translatesAutoresizingMaskIntoConstraints = false
        modelTextField.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        clearFilterButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(priceTextField)
        view.addSubview(nameTextField)
        view.addSubview(brandTextField)
        view.addSubview(modelTextField)
        view.addSubview(applyButton)
        view.addSubview(clearFilterButton)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            priceTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            priceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            priceTextField.widthAnchor.constraint(equalToConstant: 250),
            
            nameTextField.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 20),
            nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalToConstant: 250),
            
            brandTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            brandTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            brandTextField.widthAnchor.constraint(equalToConstant: 250),
            
            modelTextField.topAnchor.constraint(equalTo: brandTextField.bottomAnchor, constant: 20),
            modelTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modelTextField.widthAnchor.constraint(equalToConstant: 250),
            
            applyButton.topAnchor.constraint(equalTo: modelTextField.bottomAnchor, constant: 30),
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.widthAnchor.constraint(equalToConstant: 200),
            applyButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearFilterButton.topAnchor.constraint(equalTo: applyButton.bottomAnchor, constant: 10),
            clearFilterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearFilterButton.widthAnchor.constraint(equalToConstant: 200),
            clearFilterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // Apply button action
        applyButton.addTarget(self, action: #selector(applyFilter), for: .touchUpInside)
        
        // Clear Filter button action
        clearFilterButton.addTarget(self, action: #selector(clearFilter), for: .touchUpInside)
    }
    
    @objc private func clearFilter() {
        delegate?.didClearFilter()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func applyFilter() {
        guard let priceText = priceTextField.text, !priceText.isEmpty else {
            // Show an error or handle empty input case if necessary
            print("Price is required")
            let alertController = UIAlertController(title: "Price is required", message: "Please enter the price", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Tamam", style: .default)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        // Try to convert the price to a Double
        guard let price = Double(priceText) else {
            // Show an error if the conversion fails (invalid number)
            print("Invalid price input")
            return
        }
        
        // Delegate ile filtre parametrelerini gönder
        delegate?.didApplyFilter(name: nameTextField.text ?? "", price: price, brand: brandTextField.text ?? "", model: modelTextField.text ?? "")
        
        // Modal ekranı kapat
        dismiss(animated: true, completion: nil)
    }
    
}


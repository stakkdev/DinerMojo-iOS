//
//  SearchBar.swift
//  DinerMojo
//
//  Created by Kristyna Fojtikova on 16/03/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

import Foundation

@objc public protocol SearchBarDelegate {
    @objc func onSearchButtonPressed()
    @objc func onLocationButtonPressed()
    @objc func onFilterButtonPressed()
    @objc func inputValueChanged(to value: String?)
    @objc func toggleSuggestionsTableView(to visible: Bool)
}

@objc public class SearchBar: UIView {
    
    private static let NIB_NAME = "SearchBar"
    
    // MARK: Initializers
    @objc var delegate: SearchBarDelegate?
    var isEditing: Bool = false {
        didSet {
            updateRightBarButtonImage()
        }
    }
    
    // MARK: References
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var view: UIView!
    @IBOutlet weak var searchBarLeftButton: UIButton!
    @IBOutlet weak var searchBarRightButton: UIButton!
    
    // MARK: Actions
    @IBAction func searchBarRightButtonPressed(_ sender: Any) {
        if (isEditing) {
            self.textField.resignFirstResponder()
        }
    }
    
    @IBAction func searchBarLeftButtonPressed(_ sender: Any) {
        self.delegate?.onLocationButtonPressed()
    }
    @IBAction func filterButtonPressed(_ sender: Any) {
        self.delegate?.onFilterButtonPressed()
    }
    
    // MARK: Initialise

    public override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
         Bundle.main.loadNibNamed(SearchBar.NIB_NAME, owner: self, options: nil)
         view.translatesAutoresizingMaskIntoConstraints = false
         addSubview(view)
         setup()
     }
    
     func setup() {
        setupLayout()
        self.textField.delegate = self
        
//        return [UIColor colorWithRed:0.43137254901961f green:0.7843137254902f blue:0.69803921568627f alpha:1.00f];
        self.view.backgroundColor = UIColor(red: 0.43137254901961, green:  0.7843137254902, blue: 0.69803921568627, alpha: 1.0)
        
     }
    
     private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
     }
    
    // MARK: - Private functions
    
    func updateRightBarButtonImage() {
        let searchImage = UIImage(named: "searchIcon")
        let crossImage = UIImage(named: "crossIcon")
        searchBarRightButton.setImage(isEditing ? crossImage : searchImage, for: .normal)
    }
}

// MARK: - UITextFieldDelegate

extension SearchBar: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        self.isEditing = false
        self.delegate?.toggleSuggestionsTableView(to: false)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEditing = true
        self.delegate?.toggleSuggestionsTableView(to: true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        let newValue = textField.text
        self.delegate?.inputValueChanged(to: newValue)
    }
    
}

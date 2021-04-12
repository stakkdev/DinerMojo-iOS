//
//  SearchBar.swift
//  DinerMojo
//
//  Created by Kristyna Fojtikova on 16/03/2021.
//  Copyright © 2021 hedgehog lab. All rights reserved.
//

import Foundation

@objc public protocol SearchBarDelegate {
    @objc func onLocationButtonPressed()
    @objc func onFilterButtonPressed()
    @objc func inputValueChanged(to value: String?)
    @objc func toggleSuggestionsTableView(to visible: Bool)
    @objc func closeButtonPressed()
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
            self.textField.text = ""
            self.delegate?.closeButtonPressed()
        }
        self.toggleActive(to: !isEditing)
    }
    
    @IBAction func searchBarLeftButtonPressed(_ sender: Any) {
        self.delegate?.onLocationButtonPressed()
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        self.delegate?.onFilterButtonPressed()
    }
    
    @IBAction func searchBarEditingChanged(_ sender: Any) {
        let newValue = textField.text
        self.delegate?.inputValueChanged(to: newValue)
    }
    
    // MARK: Initialise

    public override func awakeFromNib() {
        initWithNib()
    }
    
    // MARK: - Public functions
    
    @objc public func toggleActive(to active: Bool) {
        if active {
            if !self.textField.isFirstResponder {
                self.textField.becomeFirstResponder()
            }
        } else {
            if self.textField.isFirstResponder {
                self.textField.resignFirstResponder()
            }
        }
        self.isEditing = active
    }
    
    @objc public func setText(to text: String) {
        self.textField.text = text
    }
    
    // MARK: - Private functions
    
    private func initWithNib() {
         Bundle.main.loadNibNamed(SearchBar.NIB_NAME, owner: self, options: nil)
         view.translatesAutoresizingMaskIntoConstraints = false
         addSubview(view)
         setup()
     }
    
     private func setup() {
        setupLayout()
        self.textField.delegate = self
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
    
    private func updateRightBarButtonImage() {
        let searchImage = UIImage(named: "searchIcon")
        let crossImage = UIImage(named: "crossIcon")
        searchBarRightButton.setImage(isEditing ? crossImage : searchImage, for: .normal)
    }
}

// MARK: - UITextFieldDelegate

extension SearchBar: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
//        self.isEditing = false
//        self.delegate?.toggleSuggestionsTableView(to: false)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isEditing = true
        self.delegate?.toggleSuggestionsTableView(to: true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}

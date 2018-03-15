//
//  SearchBarView.swift
//  QFind
//
//  Created by Exalture on 16/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit
protocol SearchBarProtocol {
    func searchButtonPressed()
    
    func textField(_ textField: UITextField, shouldChangeSearcgCharacters range: NSRange, replacementString string: String) -> Bool
   func menuButtonSelected()
    
}
class SearchBarView: UIView,UITextFieldDelegate {
    @IBOutlet var searchView: UIView!
    
   
    @IBOutlet weak var searchInnerView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var searchText: UITextField!
    var searchDelegate : SearchBarProtocol?
    var searchString = String()
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit()
    {
        Bundle.main.loadNibNamed("SearchBar", owner: self, options: nil)
        addSubview(searchView)
        searchView.frame = self.bounds
        searchView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        searchInnerView.layer.cornerRadius = 5.0
        searchInnerView.clipsToBounds = true
        searchText.delegate = self
       
         self.searchText.placeholder = NSLocalizedString("SEARCH_TEXT", comment: "SEARCH_TEXT Label in the search bar ")
        setFontForSearchText()
    }
    func setFontForSearchText() {
        if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
            if ( UIScreen.main.bounds.width <= 320 ) {
                searchText.font = UIFont(name: "Lato-Regular", size: 10)
            }
            else {
                searchText.font = UIFont(name: "Lato-Regular", size: (searchText.font?.pointSize)!)
            }
            
            
        }
        else {
            if ( UIScreen.main.bounds.width <= 320 ) {
                searchText.font = UIFont(name: "GESSUniqueLight-Light", size: 10)
            }
            else {
            
            searchText.font = UIFont(name: "GESSUniqueLight-Light", size: (searchText.font?.pointSize)!)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        searchString = searchText.text!+string
//        let  char = string.cString(using: String.Encoding.utf8)!
//        let isBackSpace = strcmp(char, "\\b")
//        if (isBackSpace == -92){
//            searchString = String(searchString.characters.dropLast())
//        }
//        if ((searchString.count) > 0 ) {
//            searchButton.isHidden = false
//        }
//        else {
//            searchButton.isHidden = true
//        }
        
        
        
        searchDelegate?.textField(searchText, shouldChangeSearcgCharacters: range, replacementString: string)
        
        return true
    }
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchDelegate?.searchButtonPressed()
        
    }
    @IBAction func didTapMenu(_ sender: UIButton) {
        searchDelegate?.menuButtonSelected()
    }
    func hideSearchButton() {
        self.searchButton.isHidden = true
    }
    func unhideSearchButton() {
        self.searchButton.isHidden = false
    }
}

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
   // func searchTextFieldDidBeginEditing(_ textField: UITextField) 
}
class SearchBarView: UIView,UITextFieldDelegate {
    @IBOutlet var searchView: UIView!
    
   
    @IBOutlet weak var searchInnerView: UIView!
    
    @IBOutlet weak var searchText: UITextField!
    var searchDelegate : SearchBarProtocol?
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
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(string)
       // searchDelegate?.searchTextshouldChangeCharacters()
        searchDelegate?.textField(searchText, shouldChangeSearcgCharacters: range, replacementString: string)
        return true
    }
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        searchDelegate?.searchButtonPressed()
    }
}

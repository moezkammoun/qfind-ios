//
//  PredicateSearchViewController.swift
//  QFind
//
//  Created by Exalture on 19/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import UIKit
protocol predicateTableviewProtocol {
     func tableView(_ tableView: UITableView, cellForSearchRowAt indexPath: IndexPath) -> UITableViewCell
    func tableView(_ tableView: UITableView, didSelectSearchRowAt indexPath: IndexPath)
      func tableView(_ tableView: UITableView, numberOfSearchRowsInSection section: Int) -> Int
    
    
}
class PredicateSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var predicateSearchTable: UITableView!
    
   
    var predicateProtocol : predicateTableviewProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       initialSetUp()
    }
    func initialSetUp(){
        self.view.layer.cornerRadius = 7.0
        self.view.clipsToBounds = true
        predicateSearchTable.layer.cornerRadius = 7.0
        predicateSearchTable.clipsToBounds = true
        self.view.layer.masksToBounds = false;
        self.view.layer.shadowOffset = CGSize(width: -1, height: 15)
        self.view.layer.shadowRadius = 5;
        self.view.layer.shadowOpacity = 0.5;

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        if (UIDevice.current.userInterfaceIdiom == .pad)
        {
            return 85
        }
        else{
            return 50
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = predicateProtocol?.tableView(predicateSearchTable, numberOfSearchRowsInSection: section)
        return numberOfRows!
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell =  predicateProtocol?.tableView(predicateSearchTable, cellForSearchRowAt: indexPath)
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        predicateProtocol?.tableView(predicateSearchTable, didSelectSearchRowAt: indexPath)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}

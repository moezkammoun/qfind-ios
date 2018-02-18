
//
//  Sidebar.swift
//  QFind
//
//  Created by Exalture on 18/01/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Foundation
import UIKit

protocol SidebarViewDelegate: class {
    func sidebarDidSelectRow(row: Row)
}

enum Row: String {
    case menu
    case aboutus
    case howToBecomeQfinder
    case termsAndConditions
    case contactUs
    case settings
    case none
    
    
    
    init(row: Int) {
        switch row {
        case 0: self = .menu
        case 1: self = .aboutus
        case 2: self = .howToBecomeQfinder
        case 3: self = .termsAndConditions
        case 4: self = .contactUs
        case 5: self = .settings
        default: self = .none
        }
    }
}

class SidebarView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    var titleArr = [String]()
    
    weak var delegate: SidebarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.clipsToBounds=true
        let menu = NSLocalizedString("Menu", comment: "Menu sidemenu item in sidemenu")
        let aboutUs = NSLocalizedString("About us", comment: "About us sidemenu item in sidemenu")
        let howToBecomeQFinder = NSLocalizedString("How to become qfinder", comment: "How to become qfinder sidemenu item in sidemenu")
        let termsAndConditions = NSLocalizedString("Terms & conditions", comment: "Terms & conditions sidemenu item in sidemenu")
        let contactUs = NSLocalizedString("Contact us", comment: "Contact us sidemenu item in sidemenu")
        let settings = NSLocalizedString("Settings", comment: "Settings item in sidemenu")
        titleArr = [menu, aboutUs, howToBecomeQFinder, termsAndConditions,
                    contactUs, settings]
        
        setupViews()
        
        myTableView.delegate=self
        myTableView.dataSource=self
        myTableView.register(UITableViewCell.self,
                             forCellReuseIdentifier: "Cell")
        myTableView.tableFooterView=UIView()
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        myTableView.allowsSelection = true
        myTableView.bounces=false
        myTableView.showsVerticalScrollIndicator=false
        myTableView.backgroundColor =  UIColor.clear

       
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell",
                                               for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
            
        if indexPath.row == 0 {
            
            let cellImg: UIImageView!
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                
                if ((LocalizationLanguage.currentAppleLanguage()) == "en")
                {
                    cellImg = UIImageView(frame: CGRect(x: cell.frame.width-90, y: 15, width: 90,
                                                    height: 90))
                }
                else{
                    cellImg = UIImageView(frame: CGRect(x: 20, y: 15, width: 90,
                                                    height: 90))
                }
                
            }
            else{
                if ((LocalizationLanguage.currentAppleLanguage()) == "en")
                {
                    cellImg = UIImageView(frame: CGRect(x: cell.frame.width-60, y: 5, width: 50,
                                                        height: 50))
                }
                else{
                    cellImg = UIImageView(frame: CGRect(x: 15, y: 5, width: 50,
                                                        height: 50))
                }
            }
           
            cellImg.layer.cornerRadius = 40
            cellImg.layer.masksToBounds=true
            cellImg.contentMode = .scaleAspectFit
         cellImg.layer.masksToBounds=true
            cellImg.image = #imageLiteral(resourceName: "hamburger-white")
            cell.addSubview(cellImg)
            cell.textLabel?.text  = titleArr[indexPath.row].uppercased()
            cell.textLabel?.textColor = UIColor.white
            let cellSeparator = UIView(frame: CGRect(x: 0,y: cell.frame.height-2,
                                                     width: cell.frame.width, height: 1))
            cellSeparator.backgroundColor = UIColor(red:210/255, green: 210/255, blue:210/255,alpha: 1.0)
             cell.addSubview(cellSeparator)
        }
        else if (indexPath.row == titleArr.count-1)
        {
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
        }
        else {
            cell.textLabel?.text = titleArr[indexPath.row]
            cell.textLabel?.textColor = UIColor.white
            var cellSeparator = UIView()
            if (UIDevice.current.userInterfaceIdiom == .pad)
            {
                 cellSeparator = UIView(frame: CGRect(x: 42,y: cell.frame.height-1,
                                                         width: cell.frame.width-84, height: 1))
            }
            else
            {
                cellSeparator = UIView(frame: CGRect(x: 15,y: cell.frame.height-1,
                                                         width: cell.frame.width-30, height: 1))
            }
            
            cellSeparator.backgroundColor = UIColor(red:210/255, green: 210/255, blue:210/255,alpha: 1.0)
            cell.addSubview(cellSeparator)
        }
            if ((LocalizationLanguage.currentAppleLanguage()) == "en") {
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 30)
                    cell.indentationLevel = 3
                }
                else{
                    cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 15)
                }
                
            }
            else {
                if (UIDevice.current.userInterfaceIdiom == .pad)
                {
                    cell.textLabel?.font = UIFont(name: "GE_SS_Unique_Bold", size: 30)
                    cell.indentationLevel = 3
                }
                else{
                    cell.textLabel?.font = UIFont(name: "GE_SS_Unique_Bold", size: 15)
                }
            }
           
            
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        self.delegate?.sidebarDidSelectRow(row: Row(row: indexPath.row))
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (UIDevice.current.userInterfaceIdiom  == .pad){
            if indexPath.row == 0 {
                return 130
            } else {
                return 100
            }
        }else{
            if indexPath.row == 0 {
                return 60
            } else {
                return 50
            }
        }
        
    }
    
    func setupViews() {
        self.addSubview(myBackgroundImage)
        self.addSubview(myTableView)
        if #available(iOS 9.0, *) {
            myTableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
             myTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
             myTableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            myTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
                .isActive = true
            
            
            myBackgroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
            myBackgroundImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            myBackgroundImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            myBackgroundImage.bottomAnchor.constraint(equalTo: bottomAnchor)
                .isActive = true
        } else {
            // Fallback on earlier versions
        }
        
        
        
       
    }
    
    let myTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    let myBackgroundImage: UIImageView = {
        var imageView = UIImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "sideMenu")
        return imageView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  DMVenuesOptionCell.swift
//  DinerMojo
//
//  Created by Mike Mikina on 4/23/17.
//  Copyright © 2017 hedgehog lab. All rights reserved.
//

import UIKit

class DMVenuesOptionCell: UITableViewCell, UITableViewCellLoadableProtocol, TableViewSelectForGroup {

    @IBOutlet weak var allSection: UIView!
    @IBOutlet weak var selectedSection: UIView!
    @IBOutlet weak var favouritesSection: UIView!
    
    var allSectionHandler: DMRadioViewOption?
    var selectedSectionHandler: DMRadioViewOption?
    //var favouritesSectionHandler: DMRadioViewOption?
    
    var clickCallback: (() -> ())?

    var data: DMVenuesOptionItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        self.allSectionHandler = DMRadioViewOption.instanceFromNib()
        _ = self.allSectionHandler?.setupView(parent: self.allSection, title: NSLocalizedString("notifications.things.all.venues", comment: "notifications.things.all.venues"))
        
        self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
        _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: NSLocalizedString("notifications.things.selected.venues", comment: "notifications.things.selected.venues"))
        
       /* self.favouritesSectionHandler = DMRadioViewOption.instanceFromNib()
        _ = self.favouritesSectionHandler?.setupView(parent: self.favouritesSection, title: NSLocalizedString("notifications.things.fav.venues", comment: "notifications.things.fav.venues"))*/
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap1.delegate = self
        self.allSection.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap2.delegate = self
        self.selectedSection.addGestureRecognizer(tap2)
        
        /*let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        tap3.delegate = self
        self.favouritesSection.addGestureRecognizer(tap3)*/
    }

    func loadData(_ data: AnyObject?) {

        guard let data = data as? DMVenuesOptionItem else {
            return
        }
        
        if let ids = data.ids {
            data.selectedVenues = true
            var str: String
            if ids.count > 1, let name = data.selectedName {
                str = "\(name) + \(ids.count - 1) others >"
                self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
                self.selectedSectionHandler?.setSelected(selected: true)
                _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: str)
            } else if ids.count == 1, let name = data.selectedName {
                str = "Selected Venues - \(name)"
                self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
                self.selectedSectionHandler?.setSelected(selected: true)
                _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: str)
            } else {
                str = "Selected Venues"
                self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
                self.selectedSectionHandler?.setSelected(selected: true)
                _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: str)
            }
            self.data = data
            self.refreshView()
            
            return
        }
        var allData = [Any]()
        let request = DMVenueRequest()
        request.downloadVenues(completionBlock: { (error, results) in
            if error == nil {
                if let venues = results as? [DMVenue] {
                    for venue in data.subscribed ?? [] {
                        if venues.filter({ el in el.name() == ((venue as? NSDictionary)?["venue"] as? NSDictionary)?["name"] as? String }).count > 0 {
                            allData.append(venue)
                        }
                    }
                    if allData.count > 0 {
                        data.selectedVenues = true
                    }
                    if allData.count == 1 {
                        guard let name = ((allData.first as? NSDictionary)?["venue"] as? NSDictionary)?["name"] as? String else { return }
                        self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
                        let str = "Selected Venues - \(name)"
                        _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: str)
                    } else if allData.count > 1 {
                        let count = allData.count - 1
                        guard let name = ((allData.first as? NSDictionary)?["venue"] as? NSDictionary)?["name"] as? String else { return }
                        self.selectedSectionHandler = DMRadioViewOption.instanceFromNib()
                        let str = "\(name) + \(count) others >"
                        _ = self.selectedSectionHandler?.setupView(parent: self.selectedSection, title: str)
                    }
                    self.data = data
                    self.refreshView()
                }
            }
        })
    }
    
    func refreshView() {
        if let allVenues = self.data?.allVenues, let allSectionHandler = self.allSectionHandler {
            self.changeSelection(selected: allVenues, item: allSectionHandler)
        }
        if let selectedVenues = self.data?.selectedVenues, let selectedSectionHandler = self.selectedSectionHandler {
            self.changeSelection(selected: selectedVenues, item: selectedSectionHandler)
        }
        /*if let myFav = self.data?.myFav, let favouritesSectionHandler = self.favouritesSectionHandler {
            self.changeSelection(selected: myFav, item: favouritesSectionHandler)
        }*/
    }
    
    func changeSelection(selected: Bool, item: DMRadioViewOption) {
        item.button.isSelected = selected
        item.titleLabel.isHighlighted = selected
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer?) {
        if let data = self.data {
            if sender?.view?.tag == 1 {
                data.allVenues = true
                data.selectedVenues = false
                data.myFav = false
            }
            else if sender?.view?.tag == 2 {
                data.allVenues = false
                data.selectedVenues = true
                data.myFav = false
                
                if let click = self.clickCallback {
                    click()
                }
            }
            else if sender?.view?.tag == 3 {
                data.allVenues = false
                data.selectedVenues = false
                data.myFav = true
            }
            
            self.refreshView()
        }
    }
}

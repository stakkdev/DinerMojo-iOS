//
//  UpdateLocationTableViewCell.swift
//  DinerMojo
//
//  Created by XXX on 22/02/22.
//  Copyright © 2022 hedgehog lab. All rights reserved.
//

import UIKit

class UpdateLocationTableViewCell: UITableViewCell, UITableViewCellLoadableProtocol, TableViewSelectForGroup {

    @IBOutlet weak var txtFieldSearch: UITextField!
    var data: UpdateLocationTableViewItem?
    var clickCallback: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        txtFieldSearch.delegate = self
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
        if let click = self.clickCallback {
            click()
        }
    }
    
//    @IBAction func leftButtonAction(_ sender: UIButton) {
//        print("leftButtonAction")
//    }
//
//    @IBAction func rightButtonAction(_ sender: Any) {
//        print("rightButtonAction")
//    }
    
    func loadData(_ data: AnyObject?) {
        guard let data = data as? UpdateLocationTableViewItem else {
            return
        }
        self.data = data
        txtFieldSearch.text = data.searchText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print(string)
//        return true
//    }
    
}

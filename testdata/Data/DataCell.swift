//
//  DataCell.swift
//  testdata
//
//  Created by Antonio on 9/12/21.
//

import Foundation
import UIKit

class DataCell: UITableViewCell {
    
    @IBOutlet weak var fecha: UILabel!
    @IBOutlet weak var coste: UILabel!
    
    open func configure(_ fecha: Date,  amount: Double, fee: Double, id: Int) {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale // save locale temporarily
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateFormatter.locale = tempLocale
        self.fecha.text = dateFormatter.string(from: fecha) + " *** " + String(id)
        var total: Double = 0.0
        if (amount < 0) {
            total = abs(amount) - fee
             self.coste.textColor = .systemRed
        }else {
            self.coste.textColor = .systemGreen
            total = amount - fee
        }
        self.coste.text = "\(total)" + "€"
     }
}

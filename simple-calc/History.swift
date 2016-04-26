//
//  History.swift
//  simple-calc
//
//  Created by Joshua Hall on 4/25/16.
//  Copyright © 2016 Joshua Hall. All rights reserved.
//

import Foundation
import UIKit

class History : UIViewController {
    @IBOutlet weak var hisLabel: UILabel!
    @IBOutlet weak var sv: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var historyString : String = ""
        for x in history{
            historyString += x
            historyString += "\n"
        }
        hisLabel.text = historyString
    }
    var history : [String] = ["No history to display"]
}
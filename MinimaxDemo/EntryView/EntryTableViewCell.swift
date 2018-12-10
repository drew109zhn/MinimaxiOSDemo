//
//  EntryTableViewCell.swift
//  MinimaxDemo
//
//  Created by Drew Zhong on 12/4/18.
//  Copyright © 2018 Drew Zhong. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var mainWordLabel: UILabel!
    var node: Node?
    var comparingNodes: [Node]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(node: Node) {
        mainWordLabel.text = node.value
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  DetailTableViewCell.swift
//  MinimaxDemo
//
//  Created by Drew Zhong on 12/6/18.
//  Copyright © 2018 Drew Zhong. All rights reserved.
//

import UIKit
import SnapKit

class DetailTableViewCell: UITableViewCell {
    
    var mainNodeLabel: UILabel!
    var doneSetUpLabels = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainNodeLabel = UILabel()
        addSubview(mainNodeLabel)
        mainNodeLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(50)
            make.width.equalTo(50)
        }
        mainNodeLabel.layer.borderWidth = 3
        mainNodeLabel.layer.cornerRadius = 25
        mainNodeLabel.textAlignment = .center
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func setupWith(node: Node?, dict: [Int:[Node]]??) {
        guard let dict = dict as? [Int:[Node]] else {
            return
        }

        mainNodeLabel.text = node?.value
        if doneSetUpLabels == true {
            return
        }
        doneSetUpLabels = true
        
        let maxLabel = UILabel()
        addSubview(maxLabel)
        maxLabel.snp.makeConstraints { (make) in
            make.height.equalTo(30)
            make.width.equalTo(60)
            make.centerY.equalTo(mainNodeLabel)
            make.left.equalTo(mainNodeLabel.snp.right).offset(20)
        }
        var max = 0
        for int in dict.keys {
            if dict[int]!.count > max {
                max = dict[int]!.count
            }
        }
        maxLabel.text = "max: " + max.description
        
        var num = 0
        for dist in dict.keys {
            let label = UILabel()
            self.addSubview(label)
            let topSpace = num * 50 + (num + 1) * 20
            
            
            let text: NSMutableAttributedString = NSMutableAttributedString(string: "Distance " + dist.description + "     ")
            
            if let dataDict = dict[dist] {
                for otherNode in dataDict {
                    let myMutableString = NSMutableAttributedString(string: otherNode.value!, attributes: nil)
                    for i in 0..<(otherNode.value!).count {
                        if node?.value!.character(at: i) == otherNode.value!.character(at: i) {
                        myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: NSRange(location:i,length:1))
                        }
                    }
                    text.append(NSMutableAttributedString(string: " "))
                    text.append(myMutableString)
                }
            }
            
            label.attributedText = text
            label.numberOfLines = 0
            label.snp.makeConstraints({ (make) in
                make.top.equalToSuperview().offset(topSpace)
                make.left.equalTo(maxLabel.snp.right).offset(20)
                make.right.equalToSuperview().offset(30)
                make.height.equalTo(50)
            })
            label.sizeToFit()
            num += 1
        }
    }
}

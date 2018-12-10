//
//  EntryViewController.swift
//  MinimaxDemo
//
//  Created by Drew Zhong on 12/4/18.
//  Copyright © 2018 Drew Zhong. All rights reserved.
//

import UIKit
struct Node: Hashable {
    var hashValue: Int
    
    static func ==(lhs: Node, rhs: Node) -> Bool {
        return lhs.value == rhs.value
    }
    
    var value:String?

    init(value: String) {
        self.value = value
        hashValue = value.hashValue
    }
    
    func getDistance(otherNode: Node) -> Int {
        guard let value = value, let otherString = otherNode.value,
            value.count == otherString.count else {
            return -1;
        }
        var res: Int = 0
        for i in 0..<otherString.count {
            if let ch1 = otherString.character(at: i),
                let ch2 = value.character(at: i) {
                if (ch1 == ch2) {
                    res = res + 1
                }
            }
        }
        return res
    }
}
class EntryViewController: UIViewController {
    var dataArray: [Node]?
    var textfield: TextField?
    var closeButton: UIButton?
    
    @IBAction func didSelectShowGraph(_ sender: Any) {
        guard let dataArray = dataArray else {
            return
        }
        let vc = DetailViewController()
        vc.nodes = dataArray
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didSelectAddWord(_ sender: Any) {
        if self.textfield != nil || self.closeButton != nil {
            return
        }
        let textFiled: TextField = TextField()
        view.addSubview(textFiled)
        textFiled.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        textFiled.layer.borderWidth = 2.0
        textFiled.placeholder = "please add word here"
        textFiled.delegate = self
        
        let button: UIButton = UIButton()
        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalTo(textFiled).offset(70)
        }
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(closeTextfield), for: .touchUpInside)
        textFiled.backgroundColor = .white
        self.textfield = textFiled
        self.closeButton = button
    }
    @objc func closeTextfield() {
        if (self.textfield?.text != nil && self.textfield?.text!.trimmingCharacters(in: .whitespaces) != "") {
            if dataArray != nil && dataArray!.count > 0 &&
                self.textfield?.text!.trimmingCharacters(in: .whitespaces).count == dataArray![0].value!.count {
                let node = Node(value: (self.textfield?.text)!.lowercased())
                dataArray?.append(node)
                tableView.reloadData()
            } else if dataArray != nil && dataArray!.count == 0 {
                let node = Node(value: (self.textfield?.text)!.lowercased())
                dataArray?.append(node)
                tableView.reloadData()
            }
        }
        closeButton?.removeFromSuperview()
        textfield?.removeFromSuperview()
        self.textfield = nil
        self.closeButton = nil
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        dataArray = [Node(value: "goof"), Node(value: "good"), Node(value: "okok")]
        tableView.register(UINib(nibName: "EntryTableViewCell", bundle: nil), forCellReuseIdentifier: "EntryTableViewCell")
        

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    deinit {
        print("released")
    }

}
extension EntryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataArray = dataArray else {
            return 0;
        }
        return dataArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath)
        if let cell = cell as? EntryTableViewCell,
            let dataArray = dataArray {
            cell.setup(node: dataArray[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(55)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            self.dataArray!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension EntryViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}

class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
}

extension String {
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}

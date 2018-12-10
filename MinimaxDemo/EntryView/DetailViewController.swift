//
//  DetailViewController.swift
//  MinimaxDemo
//
//  Created by Drew Zhong on 12/6/18.
//  Copyright © 2018 Drew Zhong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var nodes:[Node]?
    var nodeMap: [Node : [Int: [Node]]?]?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailTableViewCell")
        nodeMap = [Node : [Int: [Node]]?]()
        guard let nodes = nodes,
            var nodeMap = nodeMap else {
            return
        }
        for node in nodes {
            for otherNode in nodes{
                if otherNode != node {
                    let dis = node.getDistance(otherNode: otherNode)
                    if nodeMap[node] == nil {
                        nodeMap[node] = [Int: [Node]]()
                    }
                    if nodeMap[node]!![dis] == nil {
                        nodeMap[node]!![dis] = [Node]()
                    }
                    nodeMap[node]!![dis]!.append(otherNode)
                 }
            }
        }
        self.nodeMap = nodeMap
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getOptimalNode() -> Node? {
        guard let nodeMap = nodeMap else {
            return nil
        }
        var res: Int = Int.max;
        var resNode: Node?
        for node in nodeMap.keys {
            var max = 0
            for int in nodeMap[node]!!.keys {
                if nodeMap[node]!![int]!.count > max {
                    max = nodeMap[node]!![int]!.count
                }
            }
            if max < res {
                res = max
                resNode = node
            }
        }
        return resNode
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nodeMap = nodeMap else {
            return 0
        }
        return nodeMap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath)
        guard let nodeMap = nodeMap else {
            return UITableViewCell()
        }
        var index = 0
        var curNode: Node?
        for node in nodeMap.keys {
            if index == indexPath.row {
                curNode = node
                break
            }
            index = index + 1
        }
        if curNode == nil {
            return UITableViewCell()
        }
        if let cell = cell as? DetailTableViewCell {
            cell.setupWith(node: curNode, dict: nodeMap[curNode!])
        }
        if curNode == getOptimalNode() {
            cell.backgroundColor = .gray
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let nodeMap = nodeMap else {
            return 0
        }
        var index = 0
        var dic: [Int: [Node]]?
        for node in nodeMap.keys {
            if index == indexPath.row {
                dic = nodeMap[node]!
            }
            index = index + 1
        }
        guard let dict = dic else {
            return 0
        }
        return (CGFloat)((dict.count) * 50 + (dict.count + 1) * 20)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

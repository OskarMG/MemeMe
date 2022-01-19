//
//  SentMemesTableVC.swift
//  MemeMe
//
//  Created by Oscar Martínez Germán on 19/1/22.
//

import UIKit

class SentMemesTableVC: UITableViewController {
    
    // MARK: - Properties
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func configureTableView() {
        self.tableView.rowHeight = 100
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SentMemesTableViewCell.identifier, for: indexPath) as! SentMemesTableViewCell
        
        let meme = self.memes[indexPath.row]
        cell.configureCell(with: meme)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }

}

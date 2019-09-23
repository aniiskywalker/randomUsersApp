//
//  RootTableViewController.swift
//  RandomUsersApp
//
//  Created by Ana Victoria Frias on 9/22/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit
import Nuke

class RootTableViewController: UITableViewController, userDelegate, UISearchBarDelegate {

    var randomUserWS = RandomUserWS()
    var usersInfo = [user]()
    var usersInfoSearch = [user]()
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 60, width: self.view.frame.width, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        randomUserWS.delegate = self
        randomUserWS.viewRandomUsers()
        searchBar.placeholder = "Search"
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        searchBar.delegate = self
        LoadingOverlay.shared.showOverlay(view: self.view)
        addDoneButtonOnKeyboard()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func refresh(_ sender: Any) {
        randomUserWS.viewRandomUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        usersInfo = usersInfoSearch
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let newUsers = usersInfoSearch
        for (index, user) in newUsers.enumerated() {
            if user.name.lowercased().hasPrefix(searchBar.text!.lowercased()){
                usersInfo.removeAll()
                usersInfo.append(newUsers[index])
                self.tableView.reloadData()
            }else{
                usersInfo.removeAll()
                self.tableView.reloadData()
            }
        }
    }

    func didSuccessGetRandomUser(user: [user]) {
        LoadingOverlay.shared.hideOverlayView()
        refreshControl?.endRefreshing()
        usersInfo = user
        usersInfoSearch = user
        tableView.reloadData()
    }
    func didFailGetRandomUser(error: String) {
        LoadingOverlay.shared.hideOverlayView()
        refreshControl?.endRefreshing()
        let alert = UIAlertController(title: "Oh-no!", message: error, preferredStyle: .alert)
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(acceptAction)
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "users", for: indexPath) as! UsersTableViewCell
        cell.nameUser.text = usersInfo[indexPath.row].name
        guard let url = URL(string: usersInfo[indexPath.row].thumbnail) else{
            return cell
        }
        Nuke.loadImage(with: url, into: cell.imageUserView)
        if let id_user = UserDefaults.standard.object(forKey: "id") as? [String] {
            if id_user.contains(usersInfo[indexPath.row].id) {
                cell.likeIcon.image = UIImage(named: "filledHeart")
            }else{
                cell.likeIcon.image = UIImage(named: "emptyHeart")
            }
        }else{
            cell.likeIcon.image = UIImage(named: "emptyHeart")
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "details") as! ViewController
        newVC.user = usersInfo[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    @IBAction func searchUser(_ sender: Any) {
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

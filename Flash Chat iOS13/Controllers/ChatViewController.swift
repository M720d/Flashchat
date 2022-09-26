//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
      
let db = Firestore.firestore()

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages : [Messages] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = k.titleName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: k.cellNibName, bundle: nil), forCellReuseIdentifier: k.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages() {
//        messages = []
        
        db.collection(k.FStore.collectionName)
            .order(by: k.FStore.dateField )
            .addSnapshotListener { QuerySnapshot, error in
                
            self.messages = []
            if let e = error {
                
                print("erroro in fetching the error. \(e)")
                
            } else {
                
                if let snapshotDocuments = QuerySnapshot?.documents {
                    
                    for doc in snapshotDocuments {
//                            print(doc.data())
                        let data = doc.data()
                        
                        if let messageSender = data[k.FStore.senderField] as? String , let messageBody = data[k.FStore.bodyField]  as? String {
                            
                            let newMessage = Messages(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageBody = messageTextfield.text , let messageSender = Auth.auth().currentUser?.email {
            
            db.collection(k.FStore.collectionName).addDocument(data: [
                k.FStore.senderField : messageSender,
                k.FStore.bodyField : messageBody,
                k.FStore.dateField : Date().timeIntervalSince1970]) { error in
                    
                if let e = error {
                    print("issue storing data, \(e)")
                } else {
                    print("successfully added")
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: k.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        return cell
    }
    
    
}

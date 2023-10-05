//
//  ChatViewController.swift
//  SecretMessenger
//
//  Created by Mufrat Karim Aritra on 10/3/23.
//  Copyright © 2023 Lego Code. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class ChatViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(message: "Sample Message", sender: "sample@message.com")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTextfield.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        title = "Chat History"
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addMessagesToDatabase()
        return true
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField)
            .addSnapshotListener() { querySnapshot, error in
                
                self.messages = []
                if let err = error {
                    print(err)
                } else {
                    if let snapDocs = querySnapshot?.documents {
                        for snapDoc in snapDocs {
                            let doc = snapDoc.data()
                            if let sender = doc[K.FStore.senderField] as? String, let message = doc[K.FStore.bodyField] as? String {
                                let newMessage = Message(message: message, sender: sender)
                                self.messages.append(newMessage)
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    
                                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                                
                            }
                        }
                    }
                }
            }
            
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        addMessagesToDatabase()
    }
    
    func addMessagesToDatabase() {
        if let message = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName)
                .addDocument(data:[
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: message,
                    K.FStore.dateField: Date().timeIntervalSince1970
                    
                ]) { (error) in
                    if let err = error {
                        print("Data saving was not successful due to \(err)")
                    } else {
                        self.messageTextfield.text = ""
                    }
                    
                }
            
        }
    }
    
    
    @IBAction func pressingLogOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageObj = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messageObj.message
        if messageObj.sender == Auth.auth().currentUser?.email{
            cell.leftImage.isHidden = true
            cell.rightImage.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.blue)
        } else {
            cell.rightImage.isHidden = true
            cell.leftImage.isHidden = false
            cell.messageBubble.backgroundColor  = UIColor(named: K.BrandColors.blue)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        
        
        return cell
        
        
        

    }
    
}

extension ChatViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


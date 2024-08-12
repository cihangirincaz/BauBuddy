//
//  UITableView+Extensions.swift
//  BauBuddy
//
//  Created by cihangirincaz on 12.08.2024.
//

import Foundation
import UIKit

extension UIViewController {
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}


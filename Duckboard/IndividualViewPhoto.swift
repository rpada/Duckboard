//
//  IndividualViewPhoto.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/6/22.
//

import Foundation
import UIKit

class IndividualViewPhoto: UIViewController {
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    var dataController: DataController!
    var selectedImage: String!
    
    // from https://stackoverflow.com/questions/24195310/how-to-add-an-action-to-a-uialertview-button-using-swift-ios
    
    // stack overflow said to use DispatchQueue: https://stackoverflow.com/questions/58087536/modifications-to-the-layout-engine-must-not-be-performed-from-a-background-thr
    func showAlertAction(title: String, message: String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                print("Action")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var IndividualPhoto: UIImageView!
    
    override func viewDidLoad() {
      //  self.ActivityIndicator.isHidden = true
        showPhoto()
    }
    
    func showPhoto(){
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        if let url = URL(string: selectedImage ?? "") {
             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                 guard let data = data, error == nil else { return }
                 
                 DispatchQueue.main.async { /// execute on main thread
                     ///
                     self.IndividualPhoto.image = UIImage(data: data)
                 }
             }
             task.resume()
            self.ActivityIndicator.isHidden = true
        } else {
            self.showAlertAction(title: "Error", message: "Could not load the duck photo.")
        }
    }
    
}

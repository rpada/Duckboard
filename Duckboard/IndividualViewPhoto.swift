//
//  IndividualViewPhoto.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/6/22.
//

import Foundation
import UIKit

class IndividualViewPhoto: UIViewController {
    
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
        showPhoto()
    }
    
    func showPhoto(){
        if let url = URL(string: selectedImage ?? "") {
             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                 guard let data = data, error == nil else { return }
                 
                 DispatchQueue.main.async { /// execute on main thread
                     self.IndividualPhoto.image = UIImage(data: data)
                 }
             }
             task.resume()
         }
    }
    
}

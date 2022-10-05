//
//  ButtonViewController.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/3/22.
//

import Foundation
import UIKit

class ButtonViewController: UIViewController{
    
    var dataController: DataController!

    @IBOutlet weak var DuckButton: UIButton!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // loadPhotos()
    }
    
    @IBAction func loadDuckPhoto(_ sender: Any) {
       getDuckData()
       
    }
    func getDuckData(){
        DuckClient.generatePhoto(completion: { (response, error) in
            if let response = response {
                let photoController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
                var randomURL = response.url
                photoController.passedURL = randomURL
                try? self.dataController.viewContext.save()
               self.navigationController?.pushViewController(photoController, animated: true)
            } else {
                self.showAlertAction(title: "Error", message: "Could not load a duck photo.")
            }
        }
    )}

    
    }
    


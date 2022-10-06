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

    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
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
    
    override func viewWillAppear(_ animated: Bool) {
        ActivityIndicator.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicator.isHidden = true
    }
    
    @IBAction func loadDuckPhoto(_ sender: Any) {
    ActivityIndicator.isHidden = false
    ActivityIndicator.startAnimating()
    getDuckData()
    }
    
    @IBAction func takeMeToDuckboard(_ sender: Any) {
        // this functionality I based off of the Virtual Tourist app- wherein you need to pass the value of the pin over to the next view controller.
        // https://knowledge.udacity.com/questions/209471
        // https://classroom.udacity.com/nanodegrees/nd003/parts/4674db75-a1fd-4134-aedf-387f74357fe0/modules/480a4cc0-6e64-4979-b1e6-15ce588850ee/lessons/751f4590-576f-4091-aa8b-3b0edd2cd3e8/concepts/d4f21dca-dd2e-4a3b-b0c1-5c55db1b0ca5

        //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
        let collectionController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionView") as! CollectionView
        collectionController.dataController = self.dataController
        self.navigationController?.pushViewController(collectionController, animated: true)
    }
    
    // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
    // based off of loading the photos in Virtual Tourist, similar functionality
    func getDuckData(){
        DuckClient.generatePhoto(completion: { (response, error) in
            if let response = response {
                let photoController = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
                //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
                
                // this functionality I based off of the Virtual Tourist app- wherein you need to pass the value of the pin over to the next view controller.
                // https://knowledge.udacity.com/questions/209471
                // https://classroom.udacity.com/nanodegrees/nd003/parts/4674db75-a1fd-4134-aedf-387f74357fe0/modules/480a4cc0-6e64-4979-b1e6-15ce588850ee/lessons/751f4590-576f-4091-aa8b-3b0edd2cd3e8/concepts/d4f21dca-dd2e-4a3b-b0c1-5c55db1b0ca5

                //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
                var randomURL = response.url
                photoController.passedURL = randomURL
                photoController.dataController = self.dataController
               self.navigationController?.pushViewController(photoController, animated: true)
            } else {
                self.showAlertAction(title: "Error", message: "Could not load a duck photo.")
            }
        }
    )}

    
    }
    


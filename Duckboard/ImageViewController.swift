//
//  ImageViewController.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/3/22.
//

import Foundation

import UIKit
import CoreData

class ImageViewController: UIViewController {

    @IBOutlet weak var loadNewPhoto: UIButton!
    @IBOutlet weak var Heart: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    
    var passedURL: String = ""
    var isActive: Bool = false
    var dataController:DataController!
    
    @IBAction func buttonPress(_ sender: UIButton) {
        if isActive {
            isActive = false
            Heart.setImage(UIImage(named: "heart"), for: .normal)
        } else {
            isActive = true
            Heart.setImage(UIImage(named: "Filled Heart"), for: .normal)
        }
        
        let favoritesController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionView") as! CollectionView
        //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
        favoritesController.favePhoto = passedURL
       self.navigationController?.pushViewController(favoritesController, animated: true)
        
    }
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        self.hidesBottomBarWhenPushed = false
        self.tabBarController?.tabBar.isHidden = false
        super.viewDidLoad()
        print("This is the URL:", passedURL)
      showImage()
    }
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
    
    func showImage(){
        // https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        if let url = URL(string: passedURL) {
             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                 guard let data = data, error == nil else { return }
                 
                 DispatchQueue.main.async { /// execute on main thread
                     self.ImageView.image = UIImage(data: data)
                   //  try? self.dataController.viewContext.save()
                 }
             }
             
             task.resume()
         }
    }
    
    @IBAction func newImage(_ sender: Any) {
        //  https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        DuckClient.generatePhoto(completion: { (response, error) in
            if let response = response {
                self.passedURL = response.url
                if let url = URL(string: response.url) {
                     let task = URLSession.shared.dataTask(with: url) { data, response, error in
                         guard let data = data, error == nil else { return }
                         
                         DispatchQueue.main.async { /// execute on main thread
                             self.ImageView.image = UIImage(data: data)
                         }
                     }
                     
                     task.resume()
                 }
            } else {
                self.showAlertAction(title: "Error", message: "Could not load a duck photo.")
            }
        }
    )}
    
//    func fetchLoadedPhoto() -> [SinglePhoto] {
//        // https://classroom.udacity.com/nanodegrees/nd003/parts/9f3d04d4-d74a-4032-bf01-8887182fee62/modules/bbdd0d82-ac18-46b4-8bd4-246082887515/lessons/62c0b010-315c-4a1c-9bab-de477fff1aab/concepts/49036d1d-4810-4bec-b973-abe80a5dee6b
//        let fetchRequest: NSFetchRequest<SinglePhoto> = SinglePhoto.fetchRequest()
//        if let fetchPhotos = try?
//            dataController.viewContext.fetch(fetchRequest){
//            singlePhotoSingleton.sharedInstance().singularPhoto = fetchPhotos
//            // iteration https://knowledge.udacity.com/questions/346334
//            for persistedPhotos in singlePhotoSingleton.sharedInstance().singularPhoto {
//                print ("photos fetched")
//            }
//        } else {
//            self.showAlertAction(title: "Error!", message: "Could not load photo. Please try again.")
//        }
//        return singlePhotoSingleton.sharedInstance().singularPhoto
//    }
    
    }


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
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var FilledHeart: UIButton!
    
    var passedURL: String = ""
    var isActive: Bool = false
    var dataController:DataController!
    
    @IBAction func buttonPress(_ sender: UIButton) {
        self.FilledHeart.isHidden = false
        saveImage()
        // this functionality I based off of the Virtual Tourist app- wherein you need to pass the value of the pin over to the next view controller.
        let favoritesController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionView") as! CollectionView
        //https://stackoverflow.com/questions/7213346/get-latitude-and-longitude-from-annotation-view
        favoritesController.dataController = dataController
        
    }
    
    // // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
    // based on saving the images in the Virtual Tourist app
    func saveImage(){
        let photo = FavoritePhoto(context: dataController.viewContext)
        photo.coreURL = passedURL
        try? dataController.viewContext.save()
    }
    // MARK: - Properties
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        self.FilledHeart.isHidden = true
        super.viewDidLoad()
        self.ActivityIndicator.isHidden = true
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
    
    @IBAction func unfavorite(_ sender: Any) {
        print("pressed 1")
        // https://knowledge.udacity.com/questions/908565
        fetchFlickrPhotos()
        self.FilledHeart.isHidden = true
        for delete in favoritePhoto.sharedInstance().favePhoto {
            if delete.coreURL == passedURL {
                dataController.viewContext.delete(delete)
                try? dataController.viewContext.save()
            }
        }
    }
    // https://knowledge.udacity.com/questions/908565
    func fetchFlickrPhotos() -> [FavoritePhoto] {
        let fetchRequest: NSFetchRequest<FavoritePhoto> = FavoritePhoto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        print(fetchRequest)
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            favoritePhoto.sharedInstance().favePhoto = result
            for fetchedPhoto in favoritePhoto.sharedInstance().favePhoto {
             //   collectionPhotos.reloadData()
            }
            print("fetching 2")
        } catch {
            self.showAlertAction(title: "There was an error retrieving photos", message: "Sorry")
        }
        return favoritePhoto.sharedInstance().favePhoto
    }
    func showImage(){
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()

        // https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        if let url = URL(string: passedURL) {
             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                 guard let data = data, error == nil else { return }
                 
                 DispatchQueue.main.async { /// execute on main thread
                     self.ImageView.image = UIImage(data: data)
                     self.ActivityIndicator.isHidden = true
                 }
             }
             
             task.resume()
         }
    }
    
    @IBAction func showMyDuckboard(_ sender: Any) {
        // this functionality I based off of the Virtual Tourist app- wherein you need to pass the value of the pin over to the next view controller.
        let collectionController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionView") as! CollectionView
        collectionController.dataController = self.dataController
        self.navigationController?.pushViewController(collectionController, animated: true)
    }
    @IBAction func newImage(_ sender: Any) {
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        
        // // from https://classroom.udacity.com/nanodegrees/nd003/parts/2b0b0f37-f10b-41dc-abb4-a346f293027a/modules/4b26ca51-f2e8-45a3-92df-a1797f597a19/lessons/3283ae8e-5dd5-483b-9c49-2faac7c53276/concepts/126b0978-f775-480a-bac0-68a1396aa81a
        //  https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
        DuckClient.generatePhoto(completion: { (response, error) in
            self.FilledHeart.isHidden = true
            if let response = response {
                self.passedURL = response.url
                if let url = URL(string: response.url) {
                     let task = URLSession.shared.dataTask(with: url) { data, response, error in
                         guard let data = data, error == nil else { return }
                         
                         DispatchQueue.main.async { /// execute on main thread
                             self.ImageView.image = UIImage(data: data)
                             self.ActivityIndicator.isHidden = true
                         }
                     }
                     task.resume()
                 }
            } else {
                self.ActivityIndicator.isHidden = true
                self.showAlertAction(title: "Error", message: "Could not load a duck photo.")
            }
        }
    )}
    
    }


//
//  CollectionView.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/4/22.
//

import Foundation
import UIKit
import CoreData

class CollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dataController: DataController!
    
    @IBOutlet weak var collectionPhotos: UICollectionView!
    var favoritedPhoto: [favoritePhoto]!
    var favePhoto: String = ""

    override func viewDidLoad() {
        print(favePhoto)
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
    func fetchFlickrPhotos() -> [FavoritePhoto] {
        let fetchRequest: NSFetchRequest<FavoritePhoto> = FavoritePhoto.fetchRequest()
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            favoritePhoto.sharedInstance().favePhoto = result
            for fetchedPhoto in favoritePhoto.sharedInstance().favePhoto {
                favoritePhoto.sharedInstance().favePhoto.append(fetchedPhoto)
                collectionPhotos.reloadData()
            }
            print("fetching 2")
        } catch {
            self.showAlertAction(title: "There was an error retrieving photos", message: "Sorry")
        }
        return favoritePhoto.sharedInstance().favePhoto
    }
    // with help from Udacity mentor: https://knowledge.udacity.com/questions/906577
        func downloadImage( imagePath:String, completionHandler: @escaping (_ imageData: Data?, _ errorString: String?) -> Void){
                let session = URLSession.shared
                let imgURL = NSURL(string: imagePath)
                let request: NSURLRequest = NSURLRequest(url: imgURL! as URL)
                
                let task = session.dataTask(with: request as URLRequest) {data, response, downloadError in
                    
                    if downloadError != nil{
                        completionHandler(nil, "Could not download image \(imagePath)")
                    } else {
                        completionHandler(data, nil)
                    }
                }
                task.resume()
            }

        // MARK: Collection View Data Source
        //from Udacity Lession 8.8 Setup the Sent Memes Collection View
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            1
        }
        //from Udacity Lession 8.8 Setup the Sent Memes Collection View
        //from Udacity Lession 8.8 Setup the Sent Memes Collection View
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellView", for: indexPath) as! ImageCellView
            // https://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
            if let url = URL(string: favePhoto) {
                 let task = URLSession.shared.dataTask(with: url) { data, response, error in
                     guard let data = data, error == nil else { return }
                     
                     DispatchQueue.main.async { /// execute on main thread
                         // Set the name and image
                         cell.PhotoCell.image = UIImage(data: data)
                         try? self.dataController.viewContext.save()
                     }
                 }
                 
                 task.resume()
             }
            return cell
        }
        
        // from Meme Me 2.0
        // https://stackoverflow.com/questions/38028013/how-to-set-uicollectionviewcell-width-and-height-programmatically
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: 100.0, height: 100.0)
        }
        // with help from Udacity mentor https://knowledge.udacity.com/questions/848663
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
        func collectionView(_collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 2
        }
   

}

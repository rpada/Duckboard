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
    
    @IBOutlet weak var DeletePhoto: UILabel!
    @IBOutlet weak var NoPhotosFound: UILabel!
    @IBOutlet weak var collectionPhotos: UICollectionView!
    
    override func viewDidLoad() {
        self.DeletePhoto.isHidden = true
        editButton()
        // https://knowledge.udacity.com/questions/906577
        favoritePhoto.sharedInstance().favePhoto = fetchFlickrPhotos()
        if favoritePhoto.sharedInstance().favePhoto.count > 0 {
            self.collectionPhotos.reloadData()
            self.NoPhotosFound.isHidden = true
            fetchFlickrPhotos()
            print("Fetched photo:", favoritePhoto.sharedInstance().favePhoto.count)
        } else {
            self.NoPhotosFound.isHidden = false
            editButtonItem.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionPhotos.reloadData()
    }
    // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621378-setediting
    override func setEditing(_ editing:Bool, animated:Bool){
        super.setEditing(editing, animated: animated)
        if (self.isEditing) {
            self.DeletePhoto.isHidden = false
        } else {
            self.DeletePhoto.isHidden = true
        }
    }
    
    func editButton(){
        // https://developer.apple.com/documentation/uikit/uiviewcontroller/1621471-editbuttonitem
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem!.title = "Edit"
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
    
    // // https://classroom.udacity.com/nanodegrees/nd003/parts/9f3d04d4-d74a-4032-bf01-8887182fee62/modules/bbdd0d82-ac18-46b4-8bd4-246082887515/lessons/62c0b010-315c-4a1c-9bab-de477fff1aab/concepts/49036d1d-4810-4bec-b973-abe80a5dee6b
    func fetchFlickrPhotos() -> [FavoritePhoto] {
        let fetchRequest: NSFetchRequest<FavoritePhoto> = FavoritePhoto.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        print(fetchRequest)
        do {
            let result = try dataController.viewContext.fetch(fetchRequest)
            favoritePhoto.sharedInstance().favePhoto = result
            for fetchedPhoto in favoritePhoto.sharedInstance().favePhoto {
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
        favoritePhoto.sharedInstance().favePhoto.count
    }
    //from Udacity Lession 8.8 Setup the Sent Memes Collection View
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCellView", for: indexPath) as! ImageCellView
        
        let cellImage = favoritePhoto.sharedInstance().favePhoto[indexPath.row]
        // with help from Udacity mentor: https://knowledge.udacity.com/questions/906577
        // from Udacity project review https://review.udacity.com/#!/reviews/3735670
        if cellImage.coreImage == nil{
            let url = URL(string: cellImage.coreURL ?? "")
            downloadImage(imagePath: url!.absoluteString) {(data, error) in
                DispatchQueue.main.async{
                    cell.PhotoCell.image = UIImage(data: data!)
                }
                cellImage.coreImage = data
                try! self.dataController.viewContext.save()
            }
        } else {
            DispatchQueue.main.async{
                cell.PhotoCell.image = UIImage(data: cellImage.coreImage!)
            }
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
    // https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/1618032-collectionview
    // https://stackoverflow.com/questions/51526703/didselectitemat-and-diddeselectitemat-from-uicollectionview
    //https://developer.apple.com/documentation/uikit/uiviewcontroller/1621498-isediting
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditing{
            self.dataController.viewContext.delete(favoritePhoto.sharedInstance().favePhoto[indexPath.row])
            favoritePhoto.sharedInstance().favePhoto.remove(at: indexPath.row)
            self.collectionPhotos.reloadData()
            try? dataController.viewContext.save()
        } else {
            print("Photo tapped")
            let collectionController = self.storyboard?.instantiateViewController(withIdentifier: "IndividualViewPhoto") as! IndividualViewPhoto
            collectionController.dataController = self.dataController
            let flickrPhoto = favoritePhoto.sharedInstance().favePhoto[indexPath.row].coreURL
            print(flickrPhoto)
            collectionController.selectedImage = flickrPhoto
            self.navigationController?.pushViewController(collectionController, animated: true)
        }
        
    }
}
// source I used on storyboard: https://stackoverflow.com/questions/63545986/collectionview-didselectitemat-is-not-getting-called

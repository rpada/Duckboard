//
//  DataController.swift
//  Duckboard
//
//  Created by Brenna Pada on 10/4/22.
//
// https://classroom.udacity.com/nanodegrees/nd003/parts/9f3d04d4-d74a-4032-bf01-8887182fee62/modules/bbdd0d82-ac18-46b4-8bd4-246082887515/lessons/62c0b010-315c-4a1c-9bab-de477fff1aab/concepts/ec849d7a-30e6-4ebd-9b07-910521cbedcc
import Foundation
import CoreData

class DataController {
    let persistentContainer:NSPersistentContainer
    
    var viewContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    init(modelName:String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    func load(completion:(() -> Void)? = nil){
        persistentContainer.loadPersistentStores{ storeDescription, error
            in guard error == nil else{
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}

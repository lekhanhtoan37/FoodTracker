//
//  Meal.swift
//  FoodTracker2
//
//  Created by Toan on 11/23/18.
//  Copyright © 2018 Toan. All rights reserved.
//
import UIKit
import os.log

struct PropertyKey {
    static let name = "name"
    static let photo = "photo"
    static let rating = "rating"
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
}



class Meal: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.photo)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating)
    }

    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty || rating < 0 {
            return nil
        }
        guard !name.isEmpty else {
            return nil
        }
        
        guard ( rating >= 0 ) && ( rating <= 5 ) else {
            return nil
        }
        
        
        
        self.name = name
        self.photo = photo
        self.rating = rating
    }
}



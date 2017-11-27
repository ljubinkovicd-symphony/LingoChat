//
//  Extensions.swift
//  LingoChat
//
//  Created by Dorde Ljubinkovic on 11/18/17.
//  Copyright © 2017 Dorde Ljubinkovic. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>() // Serves as a memory bag for our images

extension UIImageView {
    
    func loadImageUsingCache(with urlString: String) {
        
        self.image = nil // When collection cell re-uses cell, we don't want to have "flashing" images as we scroll
        
        // Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            
            return
        }
        
        // Otherwise, fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            // Download hit an error
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }).resume()
    }
}



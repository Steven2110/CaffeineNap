//
//  UIImageExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import UIKit
import CloudKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        
        // Get our app's base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Append unique identifier for profile image
        let fileUrl = urlPath.appendingPathComponent("selectedAvatarImage")
        
        // Write the image data to the location the address points to
        guard let imageData = jpegData(compressionQuality: 0.5) else { return nil }
        
        //Create our CKAsset with that fileURL
        do {
            try imageData.write(to: fileUrl)
            
            return CKAsset(fileURL: fileUrl)
        } catch {
            return nil
        }
        
    }
    
}

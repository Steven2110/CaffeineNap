//
//  CKAssetExt.swift
//  CaffeineNap
//
//  Created by Steven Wijaya on 04.06.2023.
//

import CloudKit
import UIKit

extension CKAsset {
    
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        guard let fileUrl = self.fileURL else { return dimension.placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.placeholder
        } catch {
            return dimension.placeholder
        }
    }
    
}

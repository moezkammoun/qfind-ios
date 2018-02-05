//
//  SliderImagesModel.swift
//  QFind
//
//  Created by Exalture on 05/02/18.
//  Copyright © 2018 QFind. All rights reserved.
//

import Foundation
class SliderImagesModel: NSObject, NSCoding {
     var sliderImages : NSMutableArray
    init(sliderImages : NSMutableArray) {
        self.sliderImages = sliderImages
    }
    func encode(with aCoder: NSCoder) {
       
        aCoder.encode(sliderImages, forKey: "sliderImagesArray")
    }
    
    required init?(coder aDecoder: NSCoder) {
        sliderImages = aDecoder.decodeObject(forKey: "sliderImagesArray") as! NSMutableArray
    }
    
    
}

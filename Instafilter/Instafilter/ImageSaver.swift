//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Arin Asawa on 11/26/20.
//

import UIKit

class ImageSaver:NSObject{
    var successHandler : (()->Void)?
    var errorHandler: ((Error)->Void)?
    func writeToPhotoAlbum(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }
    
    @objc func saveError(_image: UIImage, didFinishSavingWithError:Error?, contextInfo:UnsafeRawPointer){
        if let error = didFinishSavingWithError {
           errorHandler?(error)
        }else{
            successHandler?()
        }
    }
    
}

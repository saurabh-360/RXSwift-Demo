//
//  CombinestagramViewController.swift
//  RXSwift1.1
//
//  Created by Saurabh Yadav on 31/01/18.
//  Copyright © 2018 Saurabh Yadav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos



class CombinestagramViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cleatButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var itemAdd: UIBarButtonItem!

    
    private let disposeBag = DisposeBag()
    private var images = Variable<[UIImage]>([])
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.value.append(UIImage.init(named: "\(i)")!)
        
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                guard let preview = self?.previewImageView else { return }
                preview.image = UIImage.collage(images: photos,
                                                size: preview.frame.size)
            })
            .disposed(by: disposeBag)
        
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
                self?.updateUI(photos: photos)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
    
        self.images.value = []
        
    }
    
    private func updateUI(photos: [UIImage]) {
        saveButton.isEnabled = photos.count > 0 && photos.count % 2 == 0
        cleatButton.isEnabled = photos.count > 0
        itemAdd.isEnabled = photos.count < 6
        title = photos.count > 0 ? "\(photos.count) photos" : "Collage"
    }

    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func showPhotosButtonAction(_ sender: Any) {
        
        guard let selectPhotosController = EnumStoryboard.combinestagram.instantiateViewController(withIdentifier: "SelectPhotosViewController") as? SelectPhotosViewController else {
            return
        }
        
        selectPhotosController.selectedPhotos
            .subscribe(onNext: { [weak self] newImage in
                guard let images = self?.images else { return }
                images.value.append(newImage)
            }, onDisposed: {
            print("completed photo selection")
            })
            .disposed(by: disposeBag)
        
        self.navigationController?.pushViewController(selectPhotosController, animated: true)
    }
    
}




class PhotoWriter {
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    static func save(_ image: UIImage) -> Observable<String> {
        return Observable.create({ observer in
            var savedAssetId: String?
            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                savedAssetId = request.placeholderForCreatedAsset?.localIdentifier
            }, completionHandler: { success, error in
                DispatchQueue.main.async {
                    if success, let id = savedAssetId {
                        observer.onNext(id)
                        observer.onCompleted()
                    } else {
                        observer.onError(error ?? Errors.couldNotSavePhoto)
                    }
                }
            })
            return Disposables.create()
        })
    }
}





extension UIImage {
    
    static func collage(images: [UIImage], size: CGSize) -> UIImage {
        let rows = images.count < 3 ? 1 : 2
        let columns = Int(round(Double(images.count) / Double(rows)))
        let tileSize = CGSize(width: round(size.width / CGFloat(columns)),
                              height: round(size.height / CGFloat(rows)))
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        for (index, image) in images.enumerated() {
            image.scaled(tileSize).draw(at: CGPoint(
                x: CGFloat(index % columns) * tileSize.width,
                y: CGFloat(index / columns) * tileSize.height
            ))
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    func scaled(_ newSize: CGSize) -> UIImage {
        guard size != newSize else {
            return self
        }
        
        let ratio = max(newSize.width / size.width, newSize.height / size.height)
        let width = size.width * ratio
        let height = size.height * ratio
        
        let scaledRect = CGRect(
            x: (newSize.width - width) / 2.0,
            y: (newSize.height - height) / 2.0,
            width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(scaledRect.size, false, 0.0);
        defer { UIGraphicsEndImageContext() }
        
        draw(in: scaledRect)
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}




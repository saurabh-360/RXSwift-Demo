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

class CombinestagramViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cleatButton: UIButton!
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    private let disposeBag = DisposeBag()
    private var images = Variable<[UIImage]>([])
    var i = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        images.value.append(UIImage.init(named: "\(i)")!)
        images.asObservable()
            .subscribe(onNext: { [weak self] photos in
            guard let preview = self?.previewImageView else { return }
                guard let images = self?.images.value, images.count > 0 else {
                    preview.image = nil
                    self?.i = 0
                    return
                }
                if let image = images.last {
                    preview.image = image
                }
                
//                UIImage.collage(images: photos,
//            size: preview.frame.size)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
    
        self.images.value = []
        
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
    
    @IBAction func showPhotosButtonAction(_ sender: Any) {
        
        i+=1
        i%=4
        images.value.append(UIImage.init(named: "\(i)")!)
        
        
        
        return
        
        guard let combinestagramStoryboard = UIStoryboard.init(name: "Combinestagram", bundle: Bundle.main) as? UIStoryboard else {
            return
        }
        guard let selectPhotosController = combinestagramStoryboard.instantiateViewController(withIdentifier: "SelectPhotosViewController") as? SelectPhotosViewController else {
            return
        }
        
        self.navigationController?.pushViewController(selectPhotosController, animated: true)
    }
    
}

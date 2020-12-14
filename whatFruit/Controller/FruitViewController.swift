//
//  FruitViewController.swift
//  whatFruit
//
//  Created by Nico Cobelo on 14/12/2020.
//

import UIKit
import CoreML
import Vision

class FruitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var fruitInfo: UILabel!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary
        
        imagePicker.allowsEditing = true
    }

// MARK: - ImagePickerController
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.editedImage] as? UIImage {
            
            imageView.image = userPickedImage
        
            guard let ciImage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert UIImage into CIImage")
            }
            detect(fruitImage: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Detect Method
    
    func detect(fruitImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: FruitClassifier().model) else {
            fatalError("Loading CoreML model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let classification = request.results as?
                    [VNClassificationObservation] else {
                fatalError("Model failed to process image")
            }
            
            if let firstResult = classification.first {
                let fruitName = firstResult.identifier
                self.navigationItem.title = fruitName
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: fruitImage)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    // MARK: - Camera Tapped
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
    }
}

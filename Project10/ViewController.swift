//
//  ViewController.swift
//  Project10
//
//  Created by Adrimi on 22/07/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Uable to dequeue PersonCell")
        }
        
        return cell
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        
        // modifying picture to crop what I want
        picker.allowsEditing = true
        
        // just needed to work fine, thus conforming to two delegates
        picker.delegate = self
        
        present(picker, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Extract the image from the dictionary that is passed
        guard let image = info[.editedImage] as? UIImage else { return }
        
        // Generate universally unique identifier (in string)
        let imageName = UUID().uuidString
        
        // Find /documents directory, to save data specific for this app
        let imagePath = getDocumentDirectory().appendingPathComponent(imageName)
        
        // Convert image to jpeg
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            // having valid jpeg data, write it to the disc
            try? jpegData.write(to: imagePath)
        }
        
        // call out the view controller
        dismiss(animated: true)
        
    }
    
    func getDocumentDirectory() -> URL {
        // default.urls asks for /documents directory, relative to the user's home directory.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


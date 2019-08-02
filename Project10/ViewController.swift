//
//  ViewController.swift
//  Project10
//
//  Created by Adrimi on 22/07/2019.
//  Copyright © 2019 Adrimi. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Uable to dequeue PersonCell")
        }
        
        // get person from array
        let person = people[indexPath.item]
        
        // set label text to match person name
        cell.name.text = person.name
        
        // find person image somewhere in memory
        let path = getDocumentDirectory().appendingPathComponent(person.image)
        
        // set founded image
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // some customization of image
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        // some fancy brush also on cell
        cell.layer.cornerRadius = 7
        
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
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        
        // reload view
        collectionView.reloadData()
        
        // call out the view controller
        dismiss(animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "What you want to do?", message: nil, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            guard let person = self?.people[indexPath.item] else { return }
            self?.renamePerson(person: person)
        })
        
        ac.addAction(UIAlertAction(title: "Delete", style: .default) { [weak self] _ in
            guard let person = self?.people[indexPath.item] else { return }
            self?.deletePerson(person: person)
        })
        
        present(ac, animated: true)
    }

    func renamePerson(person: Person) {
        let ac = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func deletePerson(person: Person) {
        let ac = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
            guard let indexOfPerson = self?.people.firstIndex(of: person) else { return }
            self?.people.remove(at: indexOfPerson)
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func getDocumentDirectory() -> URL {
        // default.urls asks for /documents directory, relative to the user's home directory.
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


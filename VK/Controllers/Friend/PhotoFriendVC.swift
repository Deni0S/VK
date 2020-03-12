//
//  PhotoFriendVC.swift
//  VK
//
//  Created by Денис Баринов on 28.1.20.
//  Copyright © 2020 Денис Баринов. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseIdentifier = "Cell"

class PhotoFriendVC: UICollectionViewController {
    var photos: [Photo] = []
    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Загрузим данные
        loadFriendData()
    }
    
    // Загрузить данные
    func loadFriendData() {
        let service = VKService()
        service.getPhoto(id: Session.instance.photoUserId) { [weak self] error in
            if let error = error {
                print(error)
                return
            }
            // Загрузить данные из базы
            self?.loadDataFromRealm()
        }
        Session.instance.photoUserId = ""
    }
    
    // Загрузить данные из Realm
    func loadDataFromRealm() {
        let realm = try! Realm()
        // Получить объект
        let photos = realm.objects(Photo.self)
        // Переделать results в массив
        self.photos = Array(photos)
        self.collectionView?.reloadData()
    }

//    @objc private func likeOnTap(_ sender: String) {
//        guard let index = self.photos.firstIndex(of: sender) else {return}
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoFriendCell", for: indexPath) as! PhotoFriendCell
        // Заполнить ячейку полученными данными и действиями
        cell.fillCell(photos[indexPath.row])
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

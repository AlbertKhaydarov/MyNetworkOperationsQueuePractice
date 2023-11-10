//
//  ViewController.swift
//  MyNetworkOperationsQueuePractice
//
//  Created by Альберт Хайдаров on 10.11.2023.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var dataFactory: ImagesFactoryProtocol?
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
  
    private var files: [ImagesListViewModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        dataFactory = ImagesFactory(networkManager: ImagesLoader(), delegate: self)
        
        dataFactory?.loadData()
    }
    func show(dataFortableView: [ImagesListViewModel]) {
        set(viewModel: dataFortableView)
      
    }
    
    func set(viewModel: [ImagesListViewModel]) {
        files = viewModel
        self.tableView.reloadData()
    }
    
   
    
    func convert(items: [HitList]) -> [ImagesListViewModel] {
        var imageslist: [ImagesListViewModel] = []
        var image = Data()
                  items.forEach { item in
                do {
                    image = try Data(contentsOf: item.previewURL)
                } catch {
                    print(error.localizedDescription)
                }
                    let imageData = ImagesListViewModel(previewImage: UIImage(data: image) ?? UIImage(),
                                                        user: String(item.id))
                    imageslist.append(imageData)
                
            }
            return imageslist
        }

    private func configCell(for cell: ImageListCell, with indexPath: IndexPath) {
        let file = files[indexPath.row]
        cell.imageViewInCell.image = file.previewImage
        cell.titleLabelInCell.text = file.user
    }
}

    extension ListViewController: UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return files.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ImageListCell.reuseIdentifier, for: indexPath)
            
            guard let imageListCell = cell as? ImageListCell else {
                return UITableViewCell()
            }
            
            configCell(for: imageListCell, with: indexPath)
            return imageListCell
        }
    }

extension ListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
//    }
//
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {return 0}
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let heightForCell = image.size.height * (imageViewWidth / image.size.width) + imageInsets.top + imageInsets.bottom
//        return heightForCell
        return 50
    }
}

extension ListViewController: ImagesListFactoryDelegate {
    func didReceiveDataList(dataForList: [HitList]) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let viewModel = self.convert(items: dataForList)
            
            DispatchQueue.main.async { [weak self] in
                self?.show(dataFortableView: viewModel)
                print(viewModel)
            }
        }
    }
    
    func didLoadDataForListFromServer() {
        dataFactory?.requestImages()
    }
    
   
  
}

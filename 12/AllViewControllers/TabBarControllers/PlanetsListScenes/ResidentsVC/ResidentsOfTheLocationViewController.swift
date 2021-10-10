//
//  ResidentsOfTheLocationViewController.swift
//  12
//
//  Created by Евгений Таракин on 23.04.2021.
//

import UIKit


struct Resident {
    let imageLink: String?
    let imageUI: UIImage?
    let previewImage: UIImage?
    let name: String?
    let sex: String?
    let species: String?
}


class LocalResidentsStorage {
    static let shared = LocalResidentsStorage()
    var dictionaryCache: Dictionary<String, Resident> = [:]
}


class ResidentsOfTheLocationViewController: UIViewController {
    
    @IBOutlet weak var residentsCollectionView: UICollectionView?

    let networkService = NetworkService()
    var arrayResidents: [String] = []
    var planetName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor("727272")
        navigationItem.title = "Жители локации: \(planetName)"
        navigationItem.backButtonTitle = " "
        
        residentsCollectionView?.delegate = self
        residentsCollectionView?.dataSource = self
        residentsCollectionView?.register(UINib(nibName: "ResidentCell", bundle: nil), forCellWithReuseIdentifier: "ResidentCell")
        residentsCollectionView?.collectionViewLayout = createLayout()
        
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20.0
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}


extension ResidentsOfTheLocationViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayResidents.count
    }
    
}


extension ResidentsOfTheLocationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResidentCell", for: indexPath) as? ResidentCell
        else { return ResidentCell() }
        
        let currentURLString = arrayResidents[indexPath.item]
        cell.idURLString = currentURLString
        
        cell.backView?.backgroundColor = UIColor("C4C4C4")

        cell.nameLabel?.textColor = .black
        cell.nameLabel?.font = AppFont.regular.size(15)
        
        cell.sexLabel?.textColor = UIColor("565656")
        cell.sexLabel?.font = AppFont.regular.size(12)
        
        cell.speciesLabel?.textColor = UIColor("565656")
        cell.speciesLabel?.font = AppFont.regular.size(12)

        print(cell.idURLString as Any)
        
        if let resident = LocalResidentsStorage.shared.dictionaryCache[currentURLString] {
            cell.nameLabel?.text = resident.name
            cell.sexLabel?.text = resident.sex
            cell.speciesLabel?.text = resident.species
            cell.avatarHuman?.image = resident.previewImage
        } else {
            DispatchQueue.global().async {
                self.networkService.getResident(stringURL: currentURLString) { [ weak self ] (response, error) in
                    print(cell.idURLString as Any)
                    print(currentURLString)
                    if let idURLString = cell.idURLString,
                       idURLString == currentURLString {
                        DispatchQueue.main.async {
                            cell.nameLabel?.text = response?.name
                            cell.sexLabel?.text = response?.gender
                            cell.speciesLabel?.text = response?.species
                        }
                    }
                    if let imageStringURL = response?.image {
                        self?.networkService.getImage(stringURL: imageStringURL) { (image, error) in
                            DispatchQueue.main.async {
                                if let idURLString = cell.idURLString,
                                      idURLString == currentURLString {
                                    cell.avatarHuman?.image = image
                                }
                                LocalResidentsStorage.shared.dictionaryCache[currentURLString] = Resident(imageLink: response?.image, imageUI: image, previewImage: image, name: response?.name, sex: response?.gender, species: response?.species)
                            }
                        }
                    }
                }
            }
            cell.nameLabel?.text = nil
            cell.sexLabel?.text = nil
            cell.speciesLabel?.text = nil
        }
    
        return cell
    }

}

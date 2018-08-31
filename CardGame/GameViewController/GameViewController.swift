//
//  ViewController.swift
//  ShowtimeHomeWork
//
//  Created by Vitalii Kotivskyi on 8/21/18.
//  Copyright © 2018 epam. All rights reserved.
//

import UIKit
import MBProgressHUD

class GameViewController: UIViewController {

    struct Constants {
        static let itemMargin = CGFloat(8.0)
    }

    @IBOutlet weak var gameFinishedLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView?

    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout?

    lazy var gameEngine: GameEngineProtocol = {
        let gameEngine = FlipCardGameEngine(photoLoader: self.photoLoader)
        gameEngine.delegate = self
        return gameEngine
    }()

    var photoLoader: PhotoLoaderProtocol {
        return FlickrPhotoLoader.shared
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout?.minimumInteritemSpacing = Constants.itemMargin
    }

    func updateGameFinishedLabel() {
        gameFinishedLabel.isHidden = !gameEngine.isGameFinished
    }

    func startGame(size: UInt) {
        let options = CardGameOptions(size: size)
        MBProgressHUD.showAdded(to: view, animated: true)
        gameFinishedLabel.isHidden = true
        collectionView?.isHidden = true
        gameEngine.setupGame(options: options) { [weak self] success in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                if success {
                    strongSelf.collectionView?.reloadData()
                    strongSelf.collectionView?.isHidden = false
                }
            }
        }
    }

    @IBAction func startSmallGameAction(_ sender: Any) {
        startGame(size: 4)
    }

    @IBAction func startBigGameAction(_ sender: Any) {
        startGame(size: 6)
    }

}

extension GameViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameEngine.gameField?.height ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameEngine.gameField?.width ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GamePhotoCollectionViewCell.reuseIdentifier, for: indexPath)
        guard let gameFieldCell = cell as? GamePhotoCollectionViewCell,
            let gameField = gameEngine.gameField,
            let gameFieldItem = try? gameField.item(at: indexPath) else {
            assertionFailure()
            return cell
        }
        gameFieldCell.setup(gameFieldItem)
        return cell
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsInRow = CGFloat(collectionView.numberOfItems(inSection: indexPath.section))
        let width = (collectionView.frame.width - Constants.itemMargin * (itemsInRow - 1)) / itemsInRow
        return CGSize(width: width, height: width)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        } else {
            return UIEdgeInsets(top: Constants.itemMargin, left: 0, bottom: 0, right: 0)
        }
    }
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gameEngine.filpItem(at: indexPath)
    }
}

extension GameViewController: GameEngineDelegate {
    func onUpdate() {
        collectionView?.reloadData()
        updateGameFinishedLabel()
    }

    func onUpdate(item: GameFieldItem, indexPath: IndexPath) {
        guard let cell = collectionView?.cellForItem(at: indexPath) as? GamePhotoCollectionViewCell else {
            return
        }
        
        cell.update(with: item, animated: true)
    }

    func onGameFinished() {
        updateGameFinishedLabel()
    }
}


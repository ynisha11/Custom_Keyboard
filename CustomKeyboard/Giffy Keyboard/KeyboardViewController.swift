//
//  KeyboardViewController.swift
//  Nisha Keyboard
//
//  Created by Nisha  on 01/11/18.
//  Copyright © 2018 Nisha . All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var charSet1: UIView!
    @IBOutlet weak var charSet2: UIView!
    @IBOutlet var alphabetsButtonCollection: [UIButton]!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var gifSearchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    var capsLockOn = true
    let defaultKeyboardHeight: CGFloat = 219
    var isShowingGif = false
    var isShowingFirstCharSet = true
    let giphyAPIKey = "SmGQIZ2BAqVLj0Ie4RXwSAi1qzON658l"
    let limitOfResults = 12
    var dataModel: [GifData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "KeyboardView", bundle: nil)
        guard let keyboardView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView else { return }
        view = keyboardView
        registerNib()
    }

    private func registerNib() {
        collectionView.register(UINib(nibName: "GifCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GifCollectionViewCell")
    }

    @IBAction func keyPressed(_ button: UIButton) {
        guard let string = button.titleLabel?.text else {return}
        (textDocumentProxy as UIKeyInput).insertText("\(string)")
        UIView.animate(withDuration: 0.2, animations: {
            button.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
        }, completion: {(_) -> Void in
            button.transform =
                CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        })
    }

    @IBAction func backSpacePressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).deleteBackward()
    }

    @IBAction func spacePressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText(" ")
    }

    @IBAction func returnPressed(_ button: UIButton) {
        (textDocumentProxy as UIKeyInput).insertText("\n")
    }

    @IBAction func charSetPressed(_ button: UIButton) {
        isShowingFirstCharSet = !isShowingFirstCharSet
        charSet1.isHidden = !isShowingFirstCharSet
        charSet2.isHidden = isShowingFirstCharSet
        button.setTitle(isShowingFirstCharSet ? "2/2": "1/2", for: .normal)
    }

    @IBAction func capsLockPressed(_ sender: UIButton) {
        capsLockOn = !capsLockOn

        for button in alphabetsButtonCollection {
            let buttonTitle = button.titleLabel?.text
            button.setTitle(capsLockOn ? buttonTitle?.uppercased(): buttonTitle?.lowercased(), for: .normal)
        }
    }

    @IBAction func nextKeyboardPressed(_ button: UIButton) {
        advanceToNextInputMode()
    }

    @IBAction func gifButtonPressed(_ sender: UIButton) {
        isShowingGif = !isShowingGif
        searchViewHeightConstraint.constant = isShowingGif ? 40: 0
        imagesViewHeightConstraint.constant = isShowingGif ? 40: 0
    }

    @IBAction func searchGif(_ button: UIButton) {
        fetchGifs()
    }

    func fetchGifs() {
        guard let searchWord = textDocumentProxy.documentContextBeforeInput else{return}
        guard let giphyURL = URL(string: "https://api.giphy.com/v1/gifs/search?api_key=\(giphyAPIKey)&q=\(searchWord)&limit=\(limitOfResults)&offset=0&rating=G&lang=en") else { return }
        imagesViewHeightConstraint.constant = isShowingGif ? 300: 0
        spinner.startAnimating()
        collectionView.backgroundColor = UIColor.white

        let session = URLSession.shared
        session.dataTask(with: giphyURL) { [weak self] (data, response, error) in
            if let jsonData = data {
                let decoder = JSONDecoder()
                if let dataModel = try? decoder.decode(DataModel.self, from: jsonData as Data) {
                    print(dataModel)
                    DispatchQueue.main.async {
                        self?.dataModel = dataModel.gifArray
                        self?.collectionView.reloadData()
                    }
                }
            } else if let error = error {
                print(error)
            }
            }.resume()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCollectionViewCell", for: indexPath) as? GifCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.setGif(urlString: dataModel[indexPath.row].images.original.url.absoluteString)
        if !spinner.isHidden {
            spinner.stopAnimating()
            collectionView.backgroundColor = UIColor.white
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCellsInOneRow: CGFloat = 3
        let spacing: CGFloat = 2
        let heightWidth = (UIScreen.main.bounds.width - numberOfCellsInOneRow * spacing)/numberOfCellsInOneRow
        return CGSize(width: heightWidth, height: heightWidth)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

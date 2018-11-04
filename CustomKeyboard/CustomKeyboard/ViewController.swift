//
//  ViewController.swift
//  CustomKeyboard
//
//  Created by Nisha  on 01/11/18.
//  Copyright © 2018 Nisha . All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "Start typing here..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self

        let gifImage = UIImage.gif(url: "https://media3.giphy.com/headers/studiosoriginals/fHmcHCHkISg3.gif")
        imageView.image = gifImage
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }

}

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
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = "Start typing here..."
        textView.textColor = UIColor.lightGray
        textView.delegate = self
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

extension UIViewController {

    func hideBlinkingCursor() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//
//  detailViewVC.swift
//  newsApp
//
//  Created by Ram Kumar on 30/03/22.
//

import Foundation
import UIKit

class detailViewVC: UIViewController
{
    
    @IBOutlet weak var newsCoverIV: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var detailedNewsTV: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var author : String = ""
    var publishedTime : String = ""
    var detailedNews : String = ""
    var articleTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        authorLabel.text = author
        if(Int(publishedTime)! <= 1)
        {
            publishTimeLabel.text = String(format: "\(publishedTime)hr Ago")
        }
        else
        {
            publishTimeLabel.text = String(format: "\(publishedTime)hrs Ago")
        }
        detailedNewsTV.text = detailedNews
        titleLabel.text = articleTitle
    }
    
    func setImage(url: URL)
    {
        DispatchQueue.main.async{
            // Create Image and Update Image View
            self.newsCoverIV.loadImage(url: url)
        }
    }
}

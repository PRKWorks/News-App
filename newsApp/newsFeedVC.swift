//
//  ViewController.swift
//  newsApp
//
//  Created by Ram Kumar on 18/03/22.
//

import Foundation
import UIKit

class newsContentTableViewCell : UITableViewCell {
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleTV: UITextView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
}

class newsFeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var newsFeedTV: UITableView!
    @IBOutlet weak var newsCategorySC: UISegmentedControl!
    
    var newsDataArray : [Article] = []
    var titleArray : [String] = []
    var descriptionArray : [String] = []
    var imageURLArray : [String?] = []
    var timeArray : [String] = []
    var minTimeArray : [String] = []
    var hourTimeArray : [String] = []
    var sourceNameArray : [String] = []
    var convertedTimeInMinutes : [String] = []
    var convertedTimeInHours : [String] = []
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        newsFeedTV.reloadData()
        newsFeedTV.delegate = self
        newsFeedTV.dataSource = self

        // Do any additional setup after loading the view.
        newsAPI.getnewsInfo(category: "general", completion: newsResponseHandler(success:error:))
    }

    // MARK: - newsCategorySC
    @IBAction func newsCategorySC(_ sender: Any) {
        switch (newsCategorySC.selectedSegmentIndex) {
        case 0 :
            newsAPI.getnewsInfo(category: "general", completion: newsResponseHandler(success:error:))
            break;
        case 1 :
            newsAPI.getnewsInfo(category: "sports", completion: newsResponseHandler(success:error:))
            break;
        case 2 :
            newsAPI.getnewsInfo(category: "technology", completion: newsResponseHandler(success:error:))
            break;
        case 3 :
            newsAPI.getnewsInfo(category: "entertainment", completion: newsResponseHandler(success:error:))
            break;
        default :
            break;
        }
    }
    
    // MARK: - newsResponseHandler
    func newsResponseHandler(success:Bool,error: Error?) -> Void
    {
        if success
        {
            newsDataArray = newsAPI.const.article
            print("News:",newsDataArray)
            filterDataFromResponse()
            DispatchQueue.main.async {
                self.newsFeedTV.reloadData()
            }
        } else
            {
                print("error :", error as Any)
        }
    }
    
    // MARK: - filterDataFromResponse
    func filterDataFromResponse(){
        titleArray.removeAll()
        descriptionArray.removeAll()
        imageURLArray.removeAll()
        sourceNameArray.removeAll()
        for index in 0..<newsDataArray.count {
            titleArray.append(newsDataArray[index].title)
            descriptionArray.append(newsDataArray[index].articleDescription ?? "")
            imageURLArray.append(newsDataArray[index].urlToImage)
            sourceNameArray.append(newsDataArray[index].source.name)
            let convertedTimeInMinutes = convertTimeToMinutes(currentDate: newsDataArray[index].publishedAt)
            let convertedTimeInHours = convertTimeToHours(currentDate: newsDataArray[index].publishedAt)
            minTimeArray.append(convertedTimeInMinutes)
            hourTimeArray.append(convertedTimeInHours)
            if(Int(convertedTimeInHours) == 0){
                timeArray.append(convertedTimeInMinutes)
            }
            else
            {
                timeArray.append(convertedTimeInHours)
            }
        }
    }
    
    // MARK: - tableView
    func numberOfSections(in tableView: UITableView) -> Int {
         1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsFeedCell",for: indexPath) as! newsContentTableViewCell
        cell.TitleLabel.text = titleArray[indexPath.row]
        cell.authorLabel.text = sourceNameArray[indexPath.row]
        let convertedTimeInMinutes = convertTimeToMinutes(currentDate: newsDataArray[indexPath.row].publishedAt)
        let convertedTimeInHours = convertTimeToHours(currentDate: newsDataArray[indexPath.row].publishedAt)
        minTimeArray.append(convertedTimeInMinutes)
        hourTimeArray.append(convertedTimeInHours)
        if(Int(convertedTimeInHours) == 0){
            timeArray.append(convertedTimeInMinutes)
            cell.timeLabel.text = String(format:  "\(timeArray[indexPath.row])min ago")
        }
        else
        {
            timeArray.append(convertedTimeInHours)
            cell.timeLabel.text = String(format:  "\(timeArray[indexPath.row])hr ago")
        }
        let defaultURL = "minerescue.org/wp-content/uploads/2020/03/Marketplace-Lending-News.jpg"
        DispatchQueue.global().async {
            [weak self] in
            let url = URL(string: self!.imageURLArray[indexPath.row] ?? defaultURL)
            DispatchQueue.main.async {
                cell.newsImageView.loadImage(url: (url)!)
                cell.newsImageView.layer.cornerRadius = 10
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newsFeedTV.deselectRow(at: indexPath, animated: true)
        let  vc = storyboard?.instantiateViewController(identifier: "detailViewIdentifier") as! detailViewVC
        self.navigationController?.pushViewController(vc, animated: true)
        vc.author = sourceNameArray[indexPath.row]
        vc.publishedTime = timeArray[indexPath.row]
        vc.detailedNews = descriptionArray[indexPath.row]
        vc.articleTitle = titleArray[indexPath.row]
        let defaultURL = "minerescue.org/wp-content/uploads/2020/03/Marketplace-Lending-News.jpg"
        let url = URL(string: imageURLArray[indexPath.row] ?? defaultURL)!
        vc.setImage(url: url)
    }
    
    // MARK: - convertTimeToMinutes
func convertTimeToMinutes (currentDate : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "h:mm a"
        let dateValue = Date()
        let diffComponents = Calendar.current.dateComponents([.hour,.minute], from: dateValue, to: date!)
        let timeDifference = abs(diffComponents.minute!)
        return String(timeDifference)
    }

    // MARK: - convertTimeToHours
func convertTimeToHours (currentDate : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: currentDate)
        dateFormatter.dateFormat = "h:mm a"
        let dateValue = Date()
        let diffComponents = Calendar.current.dateComponents([.hour,.minute], from: dateValue, to: date!)
        let timeDifference = abs(diffComponents.hour!)
        return String(timeDifference)
    }
}

// MARK: - UIImageView
extension UIImageView{
    private static var task: URLSessionDataTask!
    private static var imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: - loadImage
    func loadImage(url: URL){
        image = UIImage(named: "Default Image")
        //to cancel multiple tasks in the background
        if let task = UIImageView.task{
            task.cancel()
        }
        //get the image from cache for faster loading
        if let imageFromCache = UIImageView.imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage{
            self.image = imageFromCache
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: {
                      (data, response, error) -> Void in
            // we have assigned the image of UIImageView class to new image
            guard let data = data, let newImage = UIImage(data: data)else{
                    print("couldn't load image from url : \(url)")
                    return
                }
            DispatchQueue.main.async {
                [weak self] in
                self!.image = newImage
                UIImageView.imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
                    }
        }).resume()
    }

}


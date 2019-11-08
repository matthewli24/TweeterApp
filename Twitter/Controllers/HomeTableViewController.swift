//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Super MattMatt on 11/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import AlamofireImage

class HomeTableViewController: UITableViewController {
    
    // MARK: - Props
    
    
    var tweetsArray = [NSDictionary]()
    var numberOfTweets: Int!
    let myRefreshContol = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveTweets()
        
        myRefreshContol.addTarget(self, action: #selector(retrieveTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshContol

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        retrieveTweets()
    }
    
    
    // MARK: - API Requests
    
    @objc func retrieveTweets() {
        
        //let mentionsTimelineUrl = "https://api.twitter.com/1.1/statuses/mentions_timeline.json"
        //let params = ["count": 10]
        numberOfTweets = 20
        let homeTimelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets!, "exclude_replies": true] as [String : Any]
        
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeTimelineUrl, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshContol.endRefreshing()
        }, failure: { (Error) in
            print("Faied to retrieve tweets: ", Error)
        })
    }
    
    
    func getMoreTweets() {
        
        numberOfTweets = numberOfTweets + 10
        let homeTimelineUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numberOfTweets!, "exclude_replies": true] as [String : Any]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: homeTimelineUrl, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetsArray.removeAll()
            
            for tweet in tweets {
                self.tweetsArray.append(tweet)
            }
            
            self.tableView.reloadData()
        }, failure: { (Error) in
            print("Faied to retrieve tweets: ", Error)
        })
    }
    

    
    
    // MARK: - Actions
    
    @IBAction func logoutTapped(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    

    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let tweet = tweetsArray[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        let profileImageUrlHttps = user["profile_image_url_https"] as! String
        let imageUrl = URL(string: profileImageUrlHttps)
        
        cell.tweetId = tweet["id"] as! Int
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContentLabel.text = tweet["text"] as? String
        cell.profileImageView.af_setImage(withURL: imageUrl!)
        cell.setFavorite(tweet["favorited"] as! Bool)
        cell.setReTweeted(tweet["retweeted"] as! Bool)
        
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetsArray.count
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if indexPath.row + 1 == tweetsArray.count {
             getMoreTweets()
         }
     }
}

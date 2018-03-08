//
//  MoviesViewController.swift
//  MovieDB
//
//  Created by mohanned almulla on 3/7/18.
//  Copyright © 2018 mohanned almulla. All rights reserved.
//

import UIKit
import AFNetworking

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var movies: [NSDictionary]?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Do any additional setup after loading the view.
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return movies?.count ?? 0
    }
    
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    
    // function for the table view which include the movies details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row] // movie variable
        let title = movie["title"] as! String // movie title variable
        let overview = movie["overview"] as! String // movie description variable
        let posterPath = movie["poster_path"] as! String // movie poster variable
        
        let baseUrl = "http://tmdb.org/t/p/w500" // initialize the poster commen link and size
        let imageUrl = NSURL(string: baseUrl + posterPath) //intialization of linking the baseUrl with the poster link from the database
        
        cell.titleLabel.text = title // linking the title space in the app to the database movie titles
        cell.overviewLabel.text = movie[overview] as! String //linking the overview space in the app to the database movie overview
        cell.posterLabel.setImageWith(imageUrl! as URL)
        // next movie in list
        print("row \(indexPath.row)")
        return cell
        
    }
    
    func fetchMovies(){
        // initialize the api key
        let apiKey = "0c8059e40385d03b483414cd0ab6673d"
        // calling the database
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        // load the URL
        let request = NSURLRequest(
            URL: url!,
            //for cached responses
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        // coordinate the network data transfer tasks
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        //download data to the app
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                //using JSON to convert data to the app
                if let responseDictionary = try! NSJSONSerialization.JSNONObjectWithData(data, options:[]) as? NSDictionary{
                    print("response: \(responseDictionary)")
                    self.movies = responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    
                    
                    
                }
            }
        })
        task.resume()

        
        
    }
}

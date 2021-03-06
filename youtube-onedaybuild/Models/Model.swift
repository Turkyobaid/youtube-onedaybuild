//
//  Model.swift
//  youtube-onedaybuild
//
//  Created by Turki Obaid ALarjan on 28/06/2020.
//  Copyright © 2020 Turki Obaid ALarjan. All rights reserved.
//

import Foundation

protocol ModelDelegate {
    
    func videosFetched(_ videos:[Video])
}



//this class is going to make the API call
//and pull back the data
//then send it over to the ViewController

class Model {
    
    var delegate: ModelDelegate?
    
    func getVideos(){
        
        // Create a URL object : points to the endpoint of the YouTube data API
        let url = URL(string: Constants.API_URL)
        
        guard url != nil else {
            return
        }
        // Get a URLSession object
        let session = URLSession.shared
        // Get a data task from the URLSession object : single call to the API
        ///response stuff
        /*
         in this closure it will handle the response
         the we're gonna get three input parameters
         */
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            //Check if there were any errors
            if error != nil || data == nil {
                //if there is error and there is no data
                //will return
                return
            }
            do {
                // Parsing the data into video objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                //now run the decode methode
                let response = try decoder.decode(Response.self, from: data!)
                
                if response.items != nil {
                    
                    
                    
                    DispatchQueue.main.async {
                        //after we've parsed the JSON and we checked that there
                        //are videos after we checke it isnt nil
                        //then it's going to Call the "videosReturned " method of the delegate
                        //and passed those videos throug it
                        self.delegate?.videosFetched(response.items!)
                    }
                }
                
                //dump(response)
                
            } catch {
                
            }
        }
        // Kick of the task : fire the Call
        dataTask.resume()
    }
}

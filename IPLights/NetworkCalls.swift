//
//  NetworkCalls.swift
//  IPLights
//
//  Created by Zeljko J on 31/01/2020.
//  Copyright © 2020 Zeljko J. All rights reserved.
//

import Foundation

class NetworkCalls{
    static let session = URLSession.shared
static func getInfo(host:String,delegate:ApiDelegate?){
    
    let request = NSMutableURLRequest(url: NSURL(string: host)! as URL)
    
    request.httpMethod = "GET"

    let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        
        if(error != nil)
        {
            DispatchQueue.main.async {
             
                delegate?.getXMLConfig(error: true, xml: nil, errMessage: error.debugDescription)
            }
            
        }
        else
        {
            
            
            let v = (response as! HTTPURLResponse).statusCode
            
            if v != 200 {
                
                DispatchQueue.main.async {
                    delegate?.getXMLConfig(error: true, xml: nil, errMessage: "Response code:"+String(v)+"\n \(host)" )
                }
            }
            else
            {
                DispatchQueue.main.async {
                   delegate?.getXMLConfig(error: false, xml: data, errMessage: nil)
                }
              
            }
            
        }
        
    })
    
    task.resume()
}
    static func setRelay(host:String,delegate:ApiDelegate?){
        
        let request = NSMutableURLRequest(url: NSURL(string: host)! as URL)
 
        request.httpMethod = "GET"
        
        
        //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
       // request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            
            if(error != nil)
            {
                DispatchQueue.main.async {
                 
                    delegate?.setReleys(error: true, errMessage: error.debugDescription)
                   
                }
                
            }
            else
            {
                
                
                let v = (response as! HTTPURLResponse).statusCode
                
                if v != 200 {
                    
                    DispatchQueue.main.async {
                        delegate?.setReleys(error: true, errMessage: "Response code:"+String(v)+"\n \(host)")
                    }
                }
                else
                {
                    DispatchQueue.main.async {
                       delegate?.setReleys(error: false, errMessage: "")
                    }
                  
                }
                
            }
            
        })
        
        task.resume()
    }
}

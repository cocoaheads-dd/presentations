import Foundation
import MapKit

class GroundStation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(title: String, latitude: Double, longitude: Double)
    {
        self.title = title
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


enum Endpoint: String {
    case observatories
    case groundStations
}

enum MyError: ErrorType {
    case NetworkError
    case JSONError
}

struct Model {
    
    private let api = "http://sscweb.gsfc.nasa.gov/WS/sscr/2/"
    
    
    func load(endpoint: Endpoint, completion: ([GroundStation]) -> ()) {
        
        var returnList = [GroundStation]()
        
        
//        defer {
//            completion(returnList)
//        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: api + endpoint.rawValue)!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().downloadTaskWithRequest(request) {
            (fileUrl, _, error) -> Void in
            
            if let _ = error {
                completion(returnList)
                return
            }
            
            var string = ""
            
            
            do{
                let data = NSData(contentsOfURL: fileUrl!)!
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject]
                
                guard let groundStations = json?["GroundStation"] as? [[String:AnyObject]] else {
                    completion(returnList)
                    print("Fehlerhaftes JSON")
                    return
                }
                
                returnList = try self.parseJSONToObjects(groundStations)
                
                
                completion(returnList)
                
            } catch MyError.JSONError {
                print("Fehler beim JSON Parsen")
            }
            catch {
                print("Fehler beim JSON Parsen")
            }
            
        }
        
        task?.resume()
        
    }
    
    func parseJSONToObjects(json: [[String:AnyObject]]) throws -> [GroundStation] {
        
        var returnList = [GroundStation]()
        
        
        for dictionary in json {
            
            guard let title = dictionary["Name"] as? String,
                    location = dictionary["Location"] as? [String: Double],
                    latitude = location["Latitude"],
                    longitude = location["Longitude"] else {
                    throw MyError.JSONError
                    continue
            }
            
            
            returnList.append(GroundStation(title: title, latitude: latitude, longitude: longitude))
            
        }
        return returnList
    }
    
}





















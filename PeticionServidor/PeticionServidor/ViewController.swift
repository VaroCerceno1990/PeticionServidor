//
//  ViewController.swift
//  PeticionServidor
//
//  Created by Ulises  on 31/5/17.
//  Copyright © 2017 Ulises . All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {

    @IBOutlet weak var resultadoConexion: UITextView!
    @IBOutlet weak var BusquedaISBN: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func BuscarISBN(_ sender: Any) {
        /*print("prueba")*/
        ConexionSincrona()
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    
    func ConexionSincrona()
    {
        var isbn:String=BusquedaISBN.text!
        if(isbn.characters.count==0)
            {
                 showAlertMessage(title: "Warning", message: "You must enter the ISBN of the book", owner: self)
            }
        if connectedToNetwork()
        {
         let urls:String="https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"+isbn
        let url=NSURL(string: urls)
        let datos:NSData?=NSData(contentsOf: url! as URL)

        let texto=NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
        resultadoConexion.text=texto as String!
        }
        
        else{
             showAlertMessage(title: "Error", message: "There are problems connecting to the Internet", owner: self)
        }
        
        
    }
    
    func showAlertMessage (title: String, message: String, owner:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Accept", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    }



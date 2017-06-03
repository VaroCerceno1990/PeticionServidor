//
//  ViewController.swift
//  PeticionServidor
//
//  Created by Ulises  on 31/5/17.
//  Copyright © 2017 Ulises . All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration

class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var resultadoConexion: UITextView!
    @IBOutlet weak var BusquedaISBN: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BusquedaISBN.delegate = self
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //delegate method
        textField.resignFirstResponder()
         ConexionSincrona()
        return true
    }

    @IBAction func BuscarISBN(_ sender: Any) {
        /*print("prueba")*/
        ConexionSincrona()
    }
    

    
    @IBAction func Limpiar(_ sender: Any) {
        resultadoConexion.text="";
        BusquedaISBN.text="";
    }
    
    
    func ConexionSincrona()
    {
        var isbn:String=BusquedaISBN.text!
        if(isbn.characters.count==0)
            {
                 showAlertMessage(title: "Advertencia", message: "Por favor digite el ISBN a buscar", owner: self)
                
                return
            }
        let urls:String="https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"+isbn
        if Reachability.shared.isConnectedToNetwork()
        {
      
        let url=NSURL(string: urls)
        let datos:NSData?=NSData(contentsOf: url! as URL)

        let texto=NSString(data: datos! as Data, encoding: String.Encoding.utf8.rawValue)
        resultadoConexion.text=texto as String!
        }
        
        else{
             showAlertMessage(title: "Error", message: "Por favor revise la conexión de internet e intente nuevamente", owner: self)
        }
        
        
    }
    
    func showAlertMessage (title: String, message: String, owner:UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{ (ACTION :UIAlertAction!)in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    }



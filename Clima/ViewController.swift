//
//  ViewController.swift
//  Clima
//
//  Created by internet on 5/31/15.
//  Copyright (c) 2015 Gualy Vc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cajadeTexto: UITextField!
    
    @IBOutlet weak var labelClima: UILabel!
    var clima:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func iniciarWebServiceCall(sender: AnyObject) {
        println("Mi Lugar: \(cajadeTexto.text)")
        llamadaWebService()
    }
    
    func llamadaWebService(){
        
        let urlPath = "http://api.openweathermap.org/data/2.5/weather?q=\(cajadeTexto.text)"+",es&lang=sp"
        
        let url = NSURL(string: urlPath)
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            //Dentro el hilo secundario
            
            if (error != nil){
                //Imprime esto si es que error no esta vacio
                println(error.localizedDescription)
            }
            
            var nsdata: NSData = NSData(data: data)
            println(nsdata)
            self.recuperarClimaDeJson(nsdata)
            
            //Comunica al hilo principal que ya hay datos
           dispatch_async(dispatch_get_main_queue(), { println(self.clima!)
            self.labelClima.text = self.clima!} )
            
        })
        
        task.resume()
    }
    
    
    func recuperarClimaDeJson(nsdata:NSData){
        
        let jsonCompleto : AnyObject! = NSJSONSerialization.JSONObjectWithData(nsdata, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        println(jsonCompleto)
        
        //Buscamos en el json "weather"
        let arregloJsonWeather = jsonCompleto["weather"]
        
        //Ponemos ? porque no sabemos si nos va delvolver algun valor o algo
        if let jsonArray = arregloJsonWeather as? NSArray{
        
        //Itinerar por todo nuestro array de jsons de nuestra respuesta al servicion web
        jsonArray.enumerateObjectsUsingBlock({ (model, index, stop) -> Void in
            /*let clima = model["description"] as? String
            println(clima)
            self.labelClima.text = clima*/
            self.clima = model["description"] as? String
        });
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


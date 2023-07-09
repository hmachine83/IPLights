//
//  ViewController.swift
//  IPLights
//
//  Created by Zeljko J on 30/01/2020.
//  Copyright © 2020 Zeljko J. All rights reserved.
//

import UIKit

class ViewController: UIViewController, XMLParserDelegate,ApiDelegate {
   
    
    func setReleys(error: Bool, errMessage: String?) {
        if(!error){
            IPSent+=1
            if(IPSent<4){
                let s = IPAddress[IPSent]+"/"+getActivationRelay()+"="+String(setVal)
                NetworkCalls.setRelay(host: s, delegate: self)
            }else{
                 getAll = false
                 IP = 0;
                 readStatus = true
                 NetworkCalls.getInfo(host: IPAddress[0]+"/xml.xml", delegate: self)
            }
        }else{
            showAlert(message: errMessage!)
        }
    }
    
    func getXMLConfig(error: Bool, xml: Data?, errMessage: String?) {
        
        if(!error){
            
            xmlParser = XMLParser(data: xml!)
            xmlParser?.delegate = self
            xmlParser?.parse()
        }else{
            showAlert(message: errMessage!)
        }
    }
    
    func showAlert(message:String){
        // create the alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
 
    
    var active:Int = 0
    var IP:Int = 0
    var IPSent:Int = 0
    var setVal:Int = 0
    
    var relay1:Int = 0

    
    var xmlParser:XMLParser?
    
    var elem:String = ""
    var IPAddress:[String]=["http://192.168.100.13","http://192.168.100.14","http://192.168.100.16","http://192.168.100.17"]
    var Relays:[String]=["relay_1","relay_2","relay_3","relay_4"]
    
    var Buttons:[String]=["Trening 1","Trening 2","Zapas","TV zapas"]
    var map: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    
    var getAll:Bool = false
    var readStatus:Bool = false
    var alertController:UIAlertController?
    
    var blocked: Bool = false
    @IBOutlet weak var light2: UIButton!
    
    @IBOutlet weak var light1: UIButton!
    
    @IBOutlet weak var light3: UIButton!
    
    @IBOutlet weak var light4: UIButton!
    
    @IBAction func light1(_ sender: Any) {
        if(blocked)
        {
         showAlert(message: "The app is fetching light status, plese wait.")
         return
            
        }
        blocked = true
        active = 1;
        getAll = false
        IP = 0;
        //xmlParser = XMLParser(contentsOf: URL.init(string: "http://192.168.184.1/xml.xml")!)
        //xmlParser?.delegate = self
        OnOFF()
       
    }
    
    @IBAction func light2(_ sender: Any) {
        if(blocked)
        {
         showAlert(message: "The app is fetching light status, plese wait.")
         return
            
        }
        blocked = true
        active = 2;
        getAll = false
        IP = 0;
        OnOFF()
    }
    
    
    @IBAction func light3(_ sender: Any) {
        if(blocked)
        {
         showAlert(message: "The app is fetching light status, plese wait.")
         return
            
        }
        blocked = true
        active = 3;
        getAll = false
        IP = 0;
        
         OnOFF()
    }
    
    @IBAction func light4(_ sender: Any) {
        if(blocked)
        {
         showAlert(message: "The app is fetching light status, plese wait.")
         return
            
        }
        blocked = true
        active = 4;
        getAll = false
        IP = 0;
       OnOFF()
    }
   
    @objc func applicationDidBecomeActive() {
        //
       setButtonColor(button:light1,what:2,ekspected: 1)
         setButtonColor(button:light2,what:3,ekspected: 1)
         setButtonColor(button:light3,what:2,ekspected: 1)
         setButtonColor(button:light4,what:3,ekspected: 0)
        loginForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
        selector: #selector(applicationDidBecomeActive),
        name: UIApplication.didBecomeActiveNotification, // UIApplication.didBecomeActiveNotification for swift 4.2+
        object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    func getRelay()->String{
        switch active {
        case 1:
            return Relays[0]
        case 2:
            return Relays[1]
        case 3:
            return Relays[2]
        case 4:
            return Relays[3]
        default:
            return ""
        }
    }
    func getRelay(rel:String)->Int{
        for i in 0..<4{
            if(Relays[i]==rel){
                return i;
            }
        }
        return -1
 
  }
    func getActivationRelay()->String{
       
        switch active {
        case 1:
            return "sdscep?sys140"
        case 2:
            return "sdscep?sys141"
        case 3:
            return "sdscep?sys142"
        case 4:
            return "sdscep?sys143"
        default:
            return ""
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        elem = elementName
       // print("parse 1: "+elementName)
    }
    
    
    func updateUI(){
        setTextOnButton()
 
        
    }
    
    
    func OnOFF(){
        readStatus = true
        
        let eksected: Int = map[active-1][0]
        setVal = eksected == 0 ? 1 : 0
        IPSent = 0
        let s = IPAddress[IPSent]+"/"+getActivationRelay()+"="+String(setVal)
        NetworkCalls.setRelay(host: s, delegate: self)
        
    }
    
    func invokeAgain(){
         IP+=1;
         if(IP<=3)
         {
             NetworkCalls.getInfo(host: IPAddress[IP]+"/xml.xml", delegate: self)
         }else{
             updateUI()
             blocked = false
             readStatus = false
             
        }
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        
        if(getAll){
            if(elementName.contains("relay_4")){
                parser.abortParsing()
                invokeAgain()
             }
        }else{
            if elementName == getRelay(){
                parser.abortParsing()
                invokeAgain()
             }
        }


  }
        
        // 3
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            
            if(!data.isEmpty){
                if(getAll){
                    if elem.contains("relay_") {
                        relay1 = Int(data) ?? -1
                        let inx = getRelay(rel: elem)
                        if(inx<0){
                            showAlert(message: "getRelay less then 0 elem:\n\(elem)")
                            return
                        }
                        map[inx][IP] = relay1
                     
                    }
                    
                }else{
                    if elem == getRelay() {
                        relay1 = Int(data) ?? -1
                        map[active-1][IP] = relay1
                    
                        //setTextOnButton(rel:1,val:relay1)
                     
                    }
                }
               
            }
            
        }
    
    
    func setButtonColor(button:UIButton, what:Int, ekspected:Int){
        let arr:[UIColor] = [UIColor.gray, UIColor.green,  UIColor.orange]
        var color: UIColor = arr[1]
        if(what<4){
            color =  arr[2]
        }else{
            if(ekspected == 0){ color = arr[0] }
        }
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = color.cgColor
    }
    func setTextOnButton(){
        var s:Int = 1
        var eksected: Int = 0
      
        
        
        for k in 0..<4{
           eksected = map[k][0]
        
            for i in 1..<4{
                if(map[k][i]==eksected){
                    s+=1
                }

              }
          
            switch k {
            case 0:
                setButtonColor(button:light1,what:s,ekspected: eksected)
              
                break
            case 1:
                setButtonColor(button:light2,what:s,ekspected: eksected)
                break
            case 2:
                setButtonColor(button:light3,what:s,ekspected: eksected)
                
                break
            case 3:
               setButtonColor(button:light4,what:s,ekspected: eksected)
                break
                
            default:
               break
            }
            s = 1
        }

    }
    

    func triggerAll(){
        getAll = true
        IP = 0
        blocked = true
        NetworkCalls.getInfo(host: IPAddress[IP]+"/xml.xml", delegate: self)
        
    }
    func loginForm()
    {
        var codeTxt : UITextField?
         alertController = UIAlertController(title: "Enter pin to enable", message: "", preferredStyle: .alert)
        alertController?.addTextField { (pTextField) in
            pTextField.placeholder = "Enter pin"
            pTextField.clearButtonMode = .whileEditing
            pTextField.borderStyle = .none
            pTextField.keyboardType = .numberPad
            codeTxt = pTextField
        }
        
        alertController?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (pAction) in
    
            self.loginForm()
        }))
        //create Ok button
        alertController?.addAction(UIAlertAction(title: "Enter", style: .default, handler: { (pAction) in
            
            let code:String = (codeTxt?.text)! as String
            
            if(code == "1250"){
                self.triggerAll()
                self.alertController?.dismiss(animated: true, completion: nil)
            }else{
                codeTxt?.placeholder = "Enter pin again"
                codeTxt?.text = ""
                self.loginForm()
            }
            
        }))
    
        //ApiCalls.makeSMSRequest(delegate: self)
        present(alertController!, animated: true, completion:nil)
    }
}


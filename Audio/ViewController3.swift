//
//  ViewController3.swift
//  Audio
//
//  Created by User1 on 7/7/17.
//  Copyright © 2017 User1. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData



class ViewController3: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var soundFileURL:URL!
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var dataSource:[AudioRecord] = []
    
    // var smth = CoreDataService()
    // var appdel:AppDelegate!
    var url:URL?
    var path:String = ""
    var name:String = ""
    var length:String = ""
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var nameOfFile: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
  //  @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var currentFileName:String = ""
    var meterTimer:Timer!
    

    func deleteAllData(entity: String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                context.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
    
    @IBAction func StartStopAction(_ sender: Any) {
        print("sender::",sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
 //self.deleteAllData(entity: "AudioData")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"AudioData")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    
                    //       path = result.value(forKey: "path") as? String
                    print(result.description)
                    path.append(result.value(forKey: "path") as! String)
                    print("path:", self.path as Any)
                    name.append(result.value(forKey: "name") as! String)
                    print("name12: ", self.name as Any)
                    
                    
                    length = (result.value(forKey: "duration") as! String)
                    
                    print("length:", self.length )
                    self.dataSource.append(AudioRecord.init(duration: length, filePath: path, fileName: name))
                    
                    
                    print("pathhhhhh", result.value(forKey: "path") as! String)
                    //     self.dataSource.append(AudioRecord.init(duration: Int64(self.length!)!, filePath: path))
                    //tableView.reloadData()
                    path = ""
                    name = ""
                }
            }
        }
        catch{
            
        }
      
        url = URL(string: "")
        
        
        
        
    }
    
    @IBAction func playB(_ sender: Any) {
        
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if let recorder = self.recorder {
            if recorder.isRecording {
                let min = Int(recorder.currentTime / 60)
                let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
                let s = String(format: "%02d:%02d", min, sec)
                statusLabel.text = s
                recorder.updateMeters()
                
            }
        }
    }
    
    @IBAction func record(_ sender: Any) {
        if player != nil && player.isPlaying {
            print("stopping")
            player.stop()
            
        }
        
        if recorder == nil {
            print("recording. recorder nil")
            recordButton.setBackgroundImage(UIImage (named: "stop"), for: .normal)
          
            playButton.isEnabled = false
           // stopButton.isEnabled = true
            recordWithPermission(true)
            return
        }
        
        if recorder != nil && recorder.isRecording {
            print("pausing")
            recordButton.setBackgroundImage(UIImage (named: "start"), for: .normal)
            recorder?.stop()
            player?.stop()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
                playButton.isEnabled = true
               // stopButton.isEnabled = false
                recordButton.isEnabled = true
            } catch {
                print("could not make session inactive")
                print(error.localizedDescription)
            }

     
            
        } else {
            print("recording")
      
        
            playButton.isEnabled = false
       //     stopButton.isEnabled = true
            //            recorder.record()
            recordWithPermission(false)
        }
    }
    
//    @IBAction func stopButton(_ sender: Any) {
//        recordButton.setBackgroundImage(UIImage (named: "start"), for: .normal)
//        recorder?.stop()
//        player?.stop()
//        
//        
//        
//        
//        // recordButton.setTitle("Record", for: .normal)
//        let session = AVAudioSession.sharedInstance()
//        do {
//            try session.setActive(false)
//            playButton.isEnabled = true
//            stopButton.isEnabled = false
//            recordButton.isEnabled = true
//        } catch {
//            print("could not make session inactive")
//            print(error.localizedDescription)
//        }
//    }
    @IBAction func play(_ sender: Any) {
        //   print("sender:1 ",sender)
        play()
    }
    
    //
    func play() {
//        print("\(#function)")
//        
//        
//        
//        if self.recorder != nil {
//            url = self.recorder.url // !url
//        } else {
//            url = self.soundFileURL!
//        }
//        print("playing",  url!)
//        
//        do {
//            
//            
//            self.player = try AVAudioPlayer(contentsOf: url!)
//            //  print("player.duration12", player.url ?? "a")
//            
//            stopButton.isEnabled = true
//            player.delegate = self
//            // player.prepareToPlay()
//            player.volume = 1.0
//            player.play()
//            print("playing")
//        } catch {
//            self.player = nil
//            print(error.localizedDescription)
//        }
        //   return player
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = self.tableView.cellForRow(at: indexPath) as! TableViewCell
    cell.StartStop.setBackgroundImage(UIImage(named: "stop"), for: .normal)
       
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         let fileUrl = documentsDirectory.appendingPathComponent(dataSource[indexPath.row].name)
        if dataSource[indexPath.row].name == "" {
            dataSource[indexPath.row].name = String(describing: documentsDirectory)
          print("dataSource[indexPath.row].name = String(describing: documentsDirectory)", dataSource[indexPath.row].name = String(describing: documentsDirectory))
         
            do {
                
              
               // self.player = try AVAudioPlayer(contentsOf: )
                
              //  stopButton.isEnabled = true
                player.delegate = self
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        
        // print("dataSource[indexPath.row]", dataSource[indexPath.row])
        //  print("dataSource::1",dataSource[indexPath.row].value(forKey: "filePath") as Any)
       	
  	
        print("dataSource::2",dataSource[indexPath.row].filePath)
         print("playing",  fileUrl)
        do {
            
            print("fileUrl12", fileUrl)
            self.player = try AVAudioPlayer(contentsOf: fileUrl)
           
       //     stopButton.isEnabled = true
            player.delegate = self
            player.volume = 1.0
            player.prepareToPlay()
            player.play()
        }
        catch{
            print(error.localizedDescription)
        }
      
        
    }
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        //   print("self.dataSource.count", self.dataSource.count)
        return dataSource.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.backgroundColor = UIColor.lightGray
        //        if soundFileURL != nil {
        //            do {
        //                self.player = try AVAudioPlayer (contentsOf: soundFileURL!)
        //                print("Cell soundFileURL", soundFileURL)
        //            }
        //
        //            catch {
        //                print("smth bad happened")
        //            }
        //
        //        }
        
       
        cell.StartStop.setBackgroundImage(UIImage(named: "start"), for: .normal)
        cell.name.text = dataSource[indexPath.row].name
        cell.duration.text = String(dataSource[indexPath.row].duration)
        
        if dataSource[indexPath.row].name == "" {
            cell.name.text = dataSource[indexPath.row].filePath
        }
        
        
        
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("indexPath.row", indexPath.row)
            self.dataSource.remove(at: indexPath.row)
            
            self.tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Records";
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        recorder = nil
        player = nil
        // Dispose of any resources that can be recreated.
    }
    func setupRecorder() {
        
        
        let format = DateFormatter()
        format.dateFormat="MM-dd-HH-mm-ss"
        currentFileName = "rec-\(format.string(from: Date())).m4a"
        print("currentFileName", currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("documentsDirectory: ",documentsDirectory)
        
        
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        
        print("soundFileURL1.description ",soundFileURL.description)
  
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        let recordSettings:[String : Any] = [
            AVFormatIDKey:             kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey :      32000,
            AVNumberOfChannelsKey:     2,
            AVSampleRateKey :          44100.0
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            print("soundFileURL2.description ",soundFileURL.description)
            
            
            
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            print("URLLLL", soundFileURL)
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
            print("recorder12:", recorder)
        } catch {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    func recordWithPermission(_ setup:Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission() {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                    
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                           target:self,
                                                           selector:#selector(self.updateAudioMeter(_:)),
                                                           userInfo:nil,
                                                           repeats:true)
                    
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission() == .denied {
            print("permission denied")
        }
    }
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ViewController3 : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        
        print("\(#function)")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let newFile = NSEntityDescription.insertNewObject(forEntityName: "AudioData", into: context)
        
        
        print("dataSource", dataSource)
        
        print("finished recording \(flag)")
     //   stopButton.isEnabled = false
        playButton.isEnabled = true
        // recordButton.setTitle("Record", for:UIControlState())
        
        // iOS8 and later
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in
            print("keep was tapped")
            
          
            
            print("dataSource.count", self.dataSource.count)
            
            
            
            // newFile.valueForKey:"name"
            
            
            do {
                
                self.player = try AVAudioPlayer (contentsOf: self.soundFileURL!)
                self.dataSource.append(AudioRecord.init(duration: String(self.player.duration), filePath: "\(self.soundFileURL)", fileName: self.name))
                
                print("self.dataSource ", self.dataSource[0].value(forKey: "duration")!)
                self.tableView.reloadData()
                
                
            }
                
            catch {
                print("smth bad happened")
            }
            newFile.setValue(String(self.player.duration), forKey: "duration")
            newFile.setValue(self.currentFileName, forKey: "name")
            newFile.setValue(self.soundFileURL.description, forKey: "path")
            //     newFile.setValue(Int64 (self.recorder.description), forKey: "duration")
            do {
                try context.save()
                print("probably saved")
            }
            catch{
                print("smth bad with saving coredata")
            }
            self.recorder = nil
            
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
            print("delete was tapped")
            self.recorder.deleteRecording()
            
            
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    
}

// MARK: AVAudioPlayerDelegate
extension ViewController3 : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("\(#function)")
        
        tableView.reloadData()
      
   
        print("finished playing \(flag)")
        recordButton.isEnabled = true
      //  stopButton.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
      
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}


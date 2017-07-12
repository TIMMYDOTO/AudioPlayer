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
    
    var url:URL?
    var path:String = ""
    var name:String = ""
    var length:String = ""
    
    var date:String = ""
    var time:String = ""
    
    
  
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var recordButton: UIButton!
    var currentFileName:String = ""
    var meterTimer:Timer!
    var currentDate:String = ""
    var currentTime:String = ""
    
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
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //  self.deleteAllData(entity: "AudioData")
        
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
                    
                    print(result.description)
                    path.append(result.value(forKey: "path") as! String)
                    name.append(result.value(forKey: "name") as! String)
                    length = (result.value(forKey: "duration") as! String)
                    date = (result.value(forKey: "date") as! String)
                    time = (result.value(forKey: "time") as! String)
                    
                    self.dataSource.append(AudioRecord.init(duration: length, filePath: path, fileName: name, time:time, date: date))
                    
                    path = ""
                    name = ""
                }
            }
        }
        catch{
            
        }
        
        
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
                recordButton.isEnabled = true
            } catch {

                print(error.localizedDescription)
            }
            
            
            
        } else {
            print("recording")
            
            recordWithPermission(false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! TableViewCell
        cell.startStopImage.image = UIImage (named: "stop")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentsDirectory.appendingPathComponent(dataSource[indexPath.row].name)
        if dataSource[indexPath.row].name == "" {
            dataSource[indexPath.row].name = String(describing: documentsDirectory)
            print("dataSource[indexPath.row].name = String(describing: documentsDirectory)", dataSource[indexPath.row].name = String(describing: documentsDirectory))
            
            do {
                
                player.delegate = self
                player.volume = 1.0
                player.prepareToPlay()
                player.play()
            }
            
            
        }
        
        print("dataSource::2",dataSource[indexPath.row].filePath)
        print("playing",  fileUrl)
        do {
            
            print("fileUrl12", fileUrl)
            self.player = try AVAudioPlayer(contentsOf: fileUrl)
            
            
            player.delegate = self
            player.volume = 1.0
            player.prepareToPlay()
            player.play()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        
        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let index = dataSource[indexPath.row].duration.index(dataSource[indexPath.row].duration.startIndex, offsetBy:4)
        
        cell.backgroundColor = UIColor.lightGray
        
        cell.startStopImage.image = UIImage (named: "start")
        
        cell.duration.text = dataSource[indexPath.row].duration.substring(to: index)
        cell.date.text = dataSource[indexPath.row].date
        cell.time.text = dataSource[indexPath.row].time
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
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
        
    }
    func setupRecorder() {
        let formater = DateFormatter()
        formater.dateFormat="yyyy.MM.dd"
        currentDate = formater.string(from: Date())
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat =  "mm:ss"
        currentTime = currentDateFormatter.string(from: Date())
        
        
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
            // probably won't happen
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
}

extension ViewController3 : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        
        print("\(#function)")
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        let newFile = NSEntityDescription.insertNewObject(forEntityName: "AudioData", into: context)
        
        print("finished recording \(flag)")
        
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in
            print("keep was tapped")
            
            do {
                
                self.player = try AVAudioPlayer (contentsOf: self.soundFileURL!)
                self.dataSource.append(AudioRecord.init(duration: String(self.player.duration), filePath: "\(self.soundFileURL!)", fileName: self.currentFileName, time:self.currentTime, date:self.currentDate))
                

                self.tableView.reloadData()
                
                
            }
                
            catch {
                print("smth bad happened")
            }
            newFile.setValue(String(self.player.duration), forKey: "duration")
            newFile.setValue(self.currentFileName, forKey: "name")
            newFile.setValue(self.soundFileURL.description, forKey: "path")
            newFile.setValue(self.currentDate, forKey: "date")
            newFile.setValue(self.currentTime, forKey: "time")
            
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
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("\(#function)")
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
        
    }
}


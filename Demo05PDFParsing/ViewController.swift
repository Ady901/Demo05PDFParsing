//
//  ViewController.swift
//  Demo05PDFParsing
//
//  Created by Aditya Sharma on 9/11/18.
//  Copyright © 2018 AdityaSharma. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let filePath = Bundle.main.url(forResource: "Notice_Result_RN", withExtension: "pdf")
        do {
            let data = try Data(contentsOf: filePath!, options: Data.ReadingOptions.uncached)
            print(data)
            if let pdf = PDFDocument(data: data) {
                let pageCount = pdf.pageCount
                let documentContent = NSMutableArray()
                print(pageCount)
                
                // Hence pages are 2616 so we are taking 10 page only
                for i in 1 ..< 10 {
                    guard let page = pdf.page(at: i) else { continue }
                    guard let pageContent = page.string else { continue }
                    var tempPageContent = pageContent.replacingOccurrences(of: String(format: "\n%d of 2615\n", i), with: "")
                    tempPageContent = tempPageContent.replacingOccurrences(of: String(format: "\n %d of 2615\n", i), with: "")
                    tempPageContent = tempPageContent.replacingOccurrences(of: "POST LDC and LDC/StoreKeeper\nNAVODAYA VIDYALAYA SAMITI\nRECRUITMENT TO THE NON-TEACHING POSTS - CBT dated 12-13-14 January 2018\nRoll Number wise Merit List\nM\n Sl No.\nApp Seq No\nRoll No\nName of Candidate\nDoB\n(DGDEN/M (M/F/T)\n/YYSYoYc)ial Category\nSub Category\nPWD Type\nActual Score\nNormalized Score\nShift\nNo of Invalid Questions\nCandidate New/Old", with: "")
                    tempPageContent = tempPageContent.replacingOccurrences(of: String(format: " New/Old\n41\n", i), with: "")
                    tempPageContent = tempPageContent.replacingOccurrences(of: "POST LDC and LDC/StoreKeeper\nNAVODAYA VIDYALAYA SAMITI\nRECRUITMENT TO THE NON-TEACHING POSTS - CBT dated 12-13-14 January 2018\nRoll Number wise Merit List\nM\n New/Old", with: "")
                    documentContent.add(tempPageContent.replacingOccurrences(of: " Sl No.\nApp Seq No\nRoll No\nName of Candidate\nDoB\n(DGDEN/M (M/F/T)\n/YYSYoYc)ial Category\nSub Category\nPWD Type\nActual Score\nNormalized Score\nShift\nNo of Invalid Questions\nCandidate", with: ""))
                }
                var arrArr = [String]()
                for obj in documentContent {
                    let arr = (obj as! NSString).components(separatedBy: "NVS")
                    arrArr.append(contentsOf: arr)
                }
                UserDefaults.standard.set(arrArr, forKey: "arrArr")
                let temp1 = arrArr.map { ($0 as NSString).replacingOccurrences(of: "\n", with: "---") }.map { $0.components(separatedBy: "---") }.map { (arr) -> [String] in
                    return arr
                }
                let temp2 = temp1.compactMap { $0 }.map { "\($0)" }
                export(arr: temp2)
                print(temp2)
                
            }
            
        } catch {
            print(error.localizedDescription)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func export(arr: [String]) {
        let fileName = "result.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = ""
        let count = arr.count
        if count > 0 {
            for str in arr {
                let newLine = str.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "") + "\n"
                csvText.append(newLine)
            }
            do {
                try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            } catch {
                print("Failed to create file")
                print("\(error)")
            }
        } else {
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


//
//  InitialViewController.swift
//  SliderPuzzle
//
//  Created by Jorge Alcántara Arnela on 26/3/17.
//  Copyright © 2017 Jaime Alcántara. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var firstImage: UIImageView!
    
    @IBOutlet weak var secondShadow: UIView!
    
    @IBOutlet weak var firstShadow: UIView!
    
    @IBOutlet weak var picker: UIPickerView!
    var pickerData: [String] = [String]()
    
    var imageSelected: String = "beach-artwork"
    
    var difficulty: Int = 3
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.delegate = self
        self.picker.dataSource = self
        let firstTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(firstImageTap(_:)))
        firstTapRecognizer.delegate = self
        self.firstImage.addGestureRecognizer(firstTapRecognizer)
        
        let secondTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(secondImageTap(_:)))
        secondTapRecognizer.delegate = self
        self.secondImage.addGestureRecognizer(secondTapRecognizer)
        
        
        self.pickerData = ["3x3", "4x4", "5x5", "6x6"]

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            let vc = segue.destination as! GameViewController
            vc.imageSelected = self.imageSelected
            vc.numberOfTilesPerSection = self.difficulty
        }
    }
    
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "toGame", sender: nil)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.difficulty = row + 3
    }
    
    
    func firstImageTap(_ sender: UITapGestureRecognizer) {
        self.firstShadow.alpha = 1
        self.secondShadow.alpha = 0
        self.imageSelected = "beach-artwork"
    }
    
    func secondImageTap(_ sender: UITapGestureRecognizer) {
        self.secondShadow.alpha = 1
        self.firstShadow.alpha = 0
        self.imageSelected = "bears"
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

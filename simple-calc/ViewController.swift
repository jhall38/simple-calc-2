//
//  ViewController.swift
//  simple-calc
//
//  Created by Joshua Hall on 4/21/16.
//  Copyright © 2016 Joshua Hall. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var displayed: UILabel!
    var nums : [Double?] = [nil] //list of ints to use
    var index : Int = 0 //index of nums
    var operation : String? //the oepration used
    var decimalPlaces : Int? // keeps track of decimal places on the right side. Null if decimal button hasn't been pressed yet
    var counter : Int = 0 //used for count operation.
    var history : [String] = []
    
    @IBOutlet weak var historyScroll: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onePress(sender: AnyObject) {
        inputNumber(1)
    }
    
    @IBAction func twoPress(sender: AnyObject) {
        inputNumber(2)
    }
    
    @IBAction func threePres(sender: AnyObject) {
        inputNumber(3)
    }

    @IBAction func fourPress(sender: AnyObject) {
        inputNumber(4)
    }
    
    @IBAction func fivePress(sender: AnyObject) {
        inputNumber(5)
    }
    
    @IBAction func sixPress(sender: AnyObject) {
        inputNumber(6)
    }

    @IBAction func sevenPress(sender: AnyObject) {
        inputNumber(7)
    }
    
    @IBAction func eigPress(sender: AnyObject) {
        inputNumber(8)
    }
    
    @IBAction func ninePress(sender: AnyObject) {
        inputNumber(9)
    }
    
    @IBAction func decPress(sender: AnyObject) {
        if(decimalPlaces == nil){
            decimalPlaces = 0
        }
    }

    @IBAction func zeroPress(sender: AnyObject) {
        inputNumber(0)
    }
    
    @IBAction func equalPress(sender: AnyObject) {
        equals()
        decimalPlaces = nil
    }
    
    @IBAction func plusPress(sender: AnyObject) {
        operation = "+"
        doOperation()
    }
    
    @IBAction func minusPress(sender: AnyObject) {
        operation = "-"
        doOperation()
    }

    @IBAction func dividePress(sender: AnyObject) {
        operation = "/"
        doOperation()
    }
    @IBAction func mulPress(sender: AnyObject) {
        operation = "*"
        doOperation()
    }
    
    @IBAction func moduPress(sender: AnyObject) {
        operation = "%"
        doOperation()
    }
    @IBAction func clearPress(sender: AnyObject) {
        clear()
    }
    
    @IBAction func countPress(sender: AnyObject) {
        operation = "count"
        counter += 1
        nums.append(nil)
        index += 1
        clear()
    }
    
    @IBAction func avgPress(sender: AnyObject) {
        operation = "avg"
        index += 1
        nums.append(nil)
        clear()
    }
    
    @IBAction func factPress(sender: AnyObject) {
        operation = "fact"
        equals()
    }
    
    //inputs a number onto the calculator
    func inputNumber(num : Double) {
        if(nums[index]==nil){ //this is the first number being entered
            nums[index] = num
            NSLog("\(index)")
            displayed.text = String(Int(nums[index]!))
            return
        }
        
        //other numbers have been entered before (compute based on magnitudes of ten
        if(decimalPlaces == nil){
            nums[index] = nums[index]! * 10 + num
            displayed.text = String(Int(nums[index]!))
            return
        }
        //here is how we compute it if the user has hit the decimal button
        nums[index] = nums[index]! + num * pow(10.0, -1.0 * Double(decimalPlaces!))
        decimalPlaces = decimalPlaces! + 1
        displayed.text = String(nums[index]!)

    }
    
    //clears the calculator
    func clear(){
        nums[index] = nil
        decimalPlaces = nil
        displayed.text = "0"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestinationViewController : History = segue.destinationViewController as! History
        DestinationViewController.history = history
    }

    //computes and answer based on the operation used
    func equals(){
        if nums[0] != nil && (index==0 || nums[1] != nil){
            if(operation) != nil{
                updateHistory()
                switch(operation!){
                case "+":
                    nums[0] = nums[0]! + nums[1]!
                    break
                case "-":
                    nums[0] = nums[0]! - nums[1]!
                    break
                case "*":
                    nums[0] = nums[0]! * nums[1]!
                    break
                case "/":
                    nums[0] = nums[0]! / nums[1]!
                    break
                case "%":
                    nums[0] = nums[0]! % nums[1]!
                    break
                case "count":
                    nums[0] = Double(counter)
                    break
                case "avg":
                    nums[0] = computeAvg()
                    break
                case "fact":
                    nums[0] = Double(computeFact(Int(nums[index]!)))
                default: break
                }
                if nums[0]! - Double(Int(nums[0]!)) == 0{ //is this a whole number
                    displayed.text = String(Int(nums[0]!))
                }
                else{
                    displayed.text = String(nums[0]!)
                }
                index = 0
                counter = 0
            }
        }
        
    }
    
    //function for doing an operation.
    func doOperation(){
        if index == 0{ //will just move on to the next input
            index += 1
            nums.append(nil)
            clear()
        }
        else if index == 1{ //will compute last result first
            equals()
            index += 1
        }
    }
    
    //factorial function
    func computeFact(num : Int) -> Int{
        if(num == 1 || num == 0){
            return 1
        }
        else{
            return num + computeFact(num-1)
        }
    }
    
    func updateHistory(){
        if(operation != nil){
            var hist : String = ""
            switch(operation!){
                case "avg", "count":
                    var answer : String
                    if(operation == "count"){
                        hist += "count "
                        answer = String(Int((Double(counter))))
                    }
                    else{
                        hist += "avg "
                        answer = String(computeAvg())
                    }
                    for x in nums{
                        if(x == nil){
                            break
                        }
                        hist += "\(x!) "
                    }
                    hist += answer
                    break
                case "fact":
                    hist += "\(nums[0]!) fact \(computeFact(Int(nums[0]!)))"
                    break
                case "+":
                    hist += "\(nums[0]!) + \(nums[1]!) = \(nums[0]! + nums[1]!)"
                    break
                case "-":
                    hist += "\(nums[0]!) - \(nums[1]!) = \(nums[0]! - nums[1]!)"
                    break
                case "*":
                    hist += "\(nums[0]!) * \(nums[1]!) = \(nums[0]! * nums[1]!)"
                    break
                case "/":
                    hist += "\(nums[0]!) / \(nums[1]!) = \(nums[0]! / nums[1]!)"
                    break
                case "%":
                    hist += "\(nums[0]!) % \(nums[1]!) = \(nums[0]! % nums[1]!)"
                    break
                default: break
            }
            history.append(hist)
        }
    }
    func computeAvg() -> Double{
        var sum : Double = 0
        var count : Double = 0
        for x in nums{
            if(x == nil){
                break
            }
            sum += x!
            count += 1
        }
        return sum / count
    }
}


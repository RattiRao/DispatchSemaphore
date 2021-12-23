//
//  ViewController.swift
//  DispatchSemaphoreDemo
//
//  Created by Ratti on 23/12/21.
//

import UIKit

enum ErrorWithdraw: Error{
    case insufficientBalance
}

protocol ProtocolWithdrawAmount{
    func withDrawAmount(amount: Double) throws
    func printBalance()
}

//Create balance variable
var balance: Double = 30000

class ATM: ProtocolWithdrawAmount{
    //Create ATM Method
    func withDrawAmount(amount: Double) throws {
        print("Atm entered")
        guard (amount < balance) else { throw ErrorWithdraw.insufficientBalance }
        balance -= amount
    }
    
    func printBalance() {
        print("Balance amount is \(balance)")
    }
}

class Bank: ProtocolWithdrawAmount{
    func withDrawAmount(amount: Double) throws {
        print("Bank entered")
        guard (amount < balance) else { throw ErrorWithdraw.insufficientBalance }
        balance -= amount
        print("Balance amount is \(balance)")
    }
    
    func printBalance() {
        print("Balance amount is \(balance)")
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Running two methods at a same time (Concurrent)
        
        let queue = DispatchQueue.init(label: "semaphoreDemo", qos: .utility, attributes: .concurrent)
        let semaphore = DispatchSemaphore.init(value: 1)
        
        queue.async{
            do {
                semaphore.wait()
                let atm: ATM = ATM()
                try atm.withDrawAmount(amount: 20000)
                atm.printBalance()
                semaphore.signal()
            } catch let error {
                print(error)
                semaphore.signal()
            }
        }
        
        queue.async{
            do {
                semaphore.wait()
                let bank: Bank = Bank()
                try bank.withDrawAmount(amount: 15000)
                bank.printBalance()
                semaphore.signal()
            } catch let error {
                print(error)
                semaphore.signal()
            }
        }
    }
}


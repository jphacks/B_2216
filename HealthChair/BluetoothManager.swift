//
//  BluetoothManager.swift
//  HealthChair
//
//  Created by 五十嵐諒 on 2022/10/21.
//

import Foundation
import CoreBluetooth

class BluetoothManager: NSObject {
    let kUARTServiceUUID = "2309e44f-cb8d-43fc-95b2-4c7134c23467" // サービス
    let kRXCharacteristicUUID = "37216a09-9f31-40f7-ab16-54ae5b32fd19" // ペリフェラルからの受信用

    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var serviceUUID : CBUUID!
    
    var kRXCBCharacteristic: CBCharacteristic?
    var charcteristicUUIDs: [CBUUID]!
    
    static let shared = BluetoothManager()
    
    func setup(){
        print("setup...")

        centralManager = CBCentralManager()
        centralManager.delegate = self as CBCentralManagerDelegate

        serviceUUID = CBUUID(string: kUARTServiceUUID)
        charcteristicUUIDs = [CBUUID(string: kRXCharacteristicUUID)]
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("CentralManager didUpdateState")

        switch central.state {
            
        //電源ONを待って、スキャンする
        case CBManagerState.poweredOn:
            let services: [CBUUID] = [serviceUUID]
            centralManager?.scanForPeripherals(withServices: services,
                                               options: nil)
        default:
            break
        }
    }
    
    /// ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        
        self.peripheral = peripheral
        centralManager?.stopScan()
        
        //接続開始
        central.connect(peripheral, options: nil)
        print("  - centralManager didDiscover")
    }
    
    /// 接続されると呼ばれる
    func centralManager(_ central: CBCentralManager,
                        didConnect peripheral: CBPeripheral) {
        
        peripheral.delegate = self
        peripheral.discoverServices([serviceUUID])
        print("  - centralManager didConnect")
    }
    
    /// 切断されると呼ばれる？
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            setup() // ペアリングのリトライ
            return
        }
    }
}

//MARK : - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {
    
    /// サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didDiscoverServices error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        //キャリアクタリスティク探索開始
        if let service = peripheral.services?.first {
            print("Searching characteristic...")
            peripheral.discoverCharacteristics(charcteristicUUIDs,
                                               for: service)
        }
    }
    
    /// キャリアクタリスティク発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }

        print("service.characteristics.count: \(service.characteristics!.count)")
        for characteristics in service.characteristics! {
            if(characteristics.uuid == CBUUID(string: kRXCharacteristicUUID)) {
                self.kRXCBCharacteristic = characteristics
                print("kTXCBCharacteristic did discovered!")
            }
        }
        
        if(self.kRXCBCharacteristic != nil) {
            startReciving()
        }
        print("  - Characteristic didDiscovered")

    }
    
    private func startReciving() {
        guard let kRXCBCharacteristic = kRXCBCharacteristic else {
            return
        }
        peripheral.setNotifyValue(true, for: kRXCBCharacteristic)
        print("Start monitoring the message from Arduino.\n\n")
    }

    /// データ送信時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)
        if error != nil {
            print(error.debugDescription)
            return
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print(#function)
    }
    
    /// データ更新時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(#function)

        if error != nil {
            print(error.debugDescription)
            return
        }
        updateWithData(data: characteristic.value!)
    }
    
    private func updateWithData(data : Data) {
        print("raw", data, "int", data.withUnsafeBytes { $0.load( as: Float.self ) } )
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(RawData.self,from: data)
            print(data)
        } catch let parseError {
            print("JSON Error")
        }
    }
    
    
}


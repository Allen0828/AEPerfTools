//
//  AEMutedTools.swift
//  AssistTools
//
//  Created by gw_pro on 2021/9/26.
//

import UIKit
import AudioToolbox

class AEMutedTools: NSObject {
    
    public static let shared = AEMutedTools()
    
    public func isMuted(callback: @escaping ((Bool)->Void)) {
        self.callback = callback
        detectMute()
    }
    
    private var duration: Float = 0
    private var timer: Timer?
    private var callback: ((Bool)->Void)?
    
    override init() {
        super.init()
    }
    
    private func audioServicesPlaySystemSoundCompleted(soundID: SystemSoundID) {
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
        if (duration < 0.010) {
            callback?(true)
        } else {
            callback?(false)
        }
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }

    private func detectMute() {
        duration = 0
        var soundObjc: SystemSoundID = 0
        let path = Bundle.main.path(forResource: "detection", ofType: "aiff")
        let baseURL = NSURL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(baseURL, &soundObjc)

        let observer = UnsafeMutableRawPointer( Unmanaged.passUnretained(self).toOpaque())
        AudioServicesAddSystemSoundCompletion(soundObjc, nil, nil, { id, date in
            let mySelf = Unmanaged<AEMutedTools>.fromOpaque(date!) .takeUnretainedValue()
            mySelf.audioServicesPlaySystemSoundCompleted(soundID: id)
        }, observer)

        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(incrementTimer), userInfo: nil, repeats: true)
        AudioServicesPlaySystemSound(soundObjc)
    }
    
    @objc private func incrementTimer() {
        debugPrint("incrementTimer")
        duration = duration + 0.001
    }

}

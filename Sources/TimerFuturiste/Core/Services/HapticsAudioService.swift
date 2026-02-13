import AudioToolbox
import Foundation
import UIKit

protocol HapticsAudioServicing {
    func playTimerFinishedFeedback()
}

final class HapticsAudioService: HapticsAudioServicing {
    func playTimerFinishedFeedback() {
        AudioServicesPlaySystemSound(1005)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


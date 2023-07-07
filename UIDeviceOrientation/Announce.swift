//
//  Announce.swift
//  UIDeviceOrientation
//
//  Created by rabbit on 2020/05/14.
//  Copyright © 2020 rabbit. All rights reserved.
//

import Foundation
import AVFoundation

// Node : If you play in the background, set setting & capabilities > background modes > audio... .

class Announce {
    var enableAnnounce = false

    let synthesizer = AVSpeechSynthesizer()
    var voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode())

    init() {

    }

    /// set language.
    ///
    /// - Parameters:
    ///    - language: language code (ex. "en-US")
    func setLanguage(_ language: String) {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for v in voices {
            if (v.language == language) {
                voice = AVSpeechSynthesisVoice(language: language)
                return
            }
        }
    }

    /// enable announcement.
    func enable() {
        enableAnnounce = true
    }

    /// disable announcement.
    func disable() {
        enableAnnounce = false
    }

    enum optionType {
        case normal
        case immediate
    }
    /// announce.
    ///
    /// - Parameters:
    ///   - text: speeking text.
    ///   - option: .immediate :　Stop the current announcement and play the specified text.
    func play(_ text: String, option: optionType = .normal) {
        if (enableAnnounce) {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = voice
            if (option == .immediate) {
                synthesizer.stopSpeaking(at: .immediate)
            }
            synthesizer.speak(utterance)
        }
    }

}

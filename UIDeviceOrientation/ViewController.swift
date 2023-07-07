//
//  ViewController.swift
//  UIDeviceOrientation
//
//  Created by rabbit on 2020/05/14.
//  Copyright © 2020 rabbit. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var activeAnnounce: String = ""
    var inactiveAnnounce: String = ""

    @IBOutlet weak var SimpleLabel: UILabel!
    @IBOutlet weak var Portrait: UILabel!
    @IBOutlet weak var Landscape: UILabel!
    @IBOutlet weak var ValidInterface: UILabel!
    @IBOutlet weak var Flat: UILabel!

    @IBOutlet weak var DetailLabel: UILabel!
    @IBOutlet weak var DPortrait: UILabel!
    @IBOutlet weak var PortraitUpsideDown: UILabel!
    @IBOutlet weak var LandscapeLeft: UILabel!
    @IBOutlet weak var LandscapeRight: UILabel!
    @IBOutlet weak var FaceUp: UILabel!
    @IBOutlet weak var FaceDown: UILabel!

    @IBOutlet weak var Detail: UIButton!
    @IBOutlet weak var Language: UIButton!

    @IBAction func DetailAction(_ sender: Any) {
        switchDetail()
    }

    @IBAction func LanguageAction(_ sender: UIButton) {
        switchLanguage()
    }

    enum detailType {
        case simple
        case detail
    }
    var detailMode = detailType.simple

    var languageMode = Locale.current.languageCode!

    let announce = Announce()

    override func viewDidLoad() {
        super.viewDidLoad()

//        if #available(iOS 13, *) {
//            // nop
//        }
//        else {
            let audioSession = AVAudioSession.sharedInstance()
            try? audioSession.setCategory(.playback)
//        }

        if (languageMode != "en" && languageMode != "ja") {
            languageMode = "en"
        }

        setupMode()
        resetColor()

        // for LifeCycle
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.activeApp),
            name: UIApplication.didBecomeActiveNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.inactiveApp),
//            name: UIApplication.didEnterBackgroundNotification,
            name: UIApplication.willResignActiveNotification,
            object: nil)

        // for Device Orientation
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.orientationChanged),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)

    }

    func switchDetail() {
        switch detailMode {
            case .simple:   detailMode = .detail
            case .detail:   detailMode = .simple
        }
        setupMode()
        orientationChanged()
    }

    func switchLanguage() {
        switch languageMode {
            case "ja":  languageMode = "en"
            case "en":  languageMode = "ja"
            default:    languageMode = "en"
        }
        setupMode()
        orientationChanged()
    }

    @objc func activeApp() {

        announce.enable()
        announce.play(activeAnnounce, option: .immediate)

    }

    @objc func inactiveApp() {

        announce.play(inactiveAnnounce, option: .immediate)
        announce.disable()

    }

    @objc func orientationChanged() {
        resetColor()

        var label = UILabel()
        label.text = "unknown"

        let orientation = UIDevice.current.orientation
        switch detailMode {
            case .simple:

                if (orientation.isPortrait)    { label = Portrait }
                else if (orientation.isLandscape)   { label = Landscape }
                else if (orientation.isFlat)        { label = Flat }
                else {
                    if #available(iOS 13.0, *) {
                        let ifOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                        switch ifOrientation {
                            //                                case .unknown:              label = Portrait
                            case .portrait:             label = Portrait
                            case .portraitUpsideDown:   label = Portrait
                            case .landscapeLeft:        label = Landscape
                            case .landscapeRight:       label = Landscape
                            default: break
                        }
                    }
                    else {
                        let sbOrientation = UIApplication.shared.statusBarOrientation
                        switch sbOrientation {
                            //                                case .unknown:              label = Portrait
                            case .portrait:             label = Portrait
                            case .portraitUpsideDown:   label = Portrait
                            case .landscapeLeft:        label = Landscape
                            case .landscapeRight:       label = Landscape
                            default: break
                        }
                    }
                }

                if (orientation.isValidInterfaceOrientation) { ValidInterface.textColor = .red }    // orientation is portrait or landscape.

            case .detail:

                switch orientation {
                    case .unknown:
                        if #available(iOS 13.0, *) {
                            let ifOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
                            switch ifOrientation {
                                //                                case .unknown:              label = Portrait
                                case .portrait:             label = DPortrait
                                case .portraitUpsideDown:   label = DPortrait
                                case .landscapeLeft:        label = LandscapeLeft
                                case .landscapeRight:       label = LandscapeRight
                                default: break
                            }
                        }
                        else {
                            let sbOrientation = UIApplication.shared.statusBarOrientation
                            switch sbOrientation {
                                //                                case .unknown:              label = Portrait
                                case .portrait:             label = DPortrait
                                case .portraitUpsideDown:   label = DPortrait
                                case .landscapeLeft:        label = LandscapeLeft
                                case .landscapeRight:       label = LandscapeRight
                                default: break
                            }
                    }
                    case .portrait:              label = DPortrait
                    case .portraitUpsideDown:    label = PortraitUpsideDown
                    case .landscapeLeft:         label = LandscapeLeft
                    case .landscapeRight:        label = LandscapeRight
                    case .faceUp:                label = FaceUp
                    case .faceDown:              label = FaceDown
                    default: break
            }
        }

        // change color
        label.textColor = .red

        // announce
        announce.play(label.text!, option: .immediate)

    }

    func setupMode() {

        activeAnnounce = "Opend".localized(lang: languageMode)
        inactiveAnnounce = "Closed".localized(lang: languageMode)

        Portrait.text = "Portrait".localized(lang: languageMode)
        Landscape.text = "Landscape".localized(lang: languageMode)
        ValidInterface.text = "Valid Interface".localized(lang: languageMode)
        Flat.text = "Flat".localized(lang: languageMode)

        DPortrait.text = "Portrait".localized(lang: languageMode)
        PortraitUpsideDown.text = "Portrait Upside Down".localized(lang: languageMode)
        LandscapeLeft.text = "Landscape Left".localized(lang: languageMode)
        LandscapeRight.text = "Landscape Right".localized(lang: languageMode)
        FaceUp.text = "Face Up".localized(lang: languageMode)
        FaceDown.text = "Face Down".localized(lang: languageMode)

        SimpleLabel.text = "SimpleLabel".localized(lang: languageMode)
        DetailLabel.text = "DetailLabel".localized(lang: languageMode)

        Language.setTitle("Language".localized(lang: languageMode), for: .normal)

        if (detailMode == .simple) {
            Detail.setTitle("Detail".localized(lang: languageMode), for: .normal)
            SimpleLabel.font = UIFont.boldSystemFont(ofSize: 20)
            DetailLabel.font = UIFont.systemFont(ofSize: 20)
        }
        else if (detailMode == .detail) {
            Detail.setTitle("Simple".localized(lang: languageMode), for: .normal)
            SimpleLabel.font = UIFont.systemFont(ofSize: 20)
            DetailLabel.font = UIFont.boldSystemFont(ofSize: 20)
        }

        switch languageMode {
            case "en":  announce.setLanguage("en-US")
            case "ja":  announce.setLanguage("ja-JP")
            default:    announce.setLanguage("en-US")
        }

    }

    func resetColor() {
        Portrait.textColor = .label
        Landscape.textColor = .label
        ValidInterface.textColor = .label
        Flat.textColor = .label

        DPortrait.textColor = .label
        PortraitUpsideDown.textColor = .label
        LandscapeLeft.textColor = .label
        LandscapeRight.textColor = .label
        FaceUp.textColor = .label
        FaceDown.textColor = .label
    }

}

extension String {
    func localized(lang: String) -> String {
        let path   = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

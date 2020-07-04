//
//  TutorialPages.swift
//  OBSCam
//
//  Created by Davide Toldo on 01.10.20.
//  Copyright © 2020 Davide Toldo. All rights reserved.
//

import UIKit

class TutorialPage1: TutorialPage {
    init() {
        super.init(
            title: "Step 1:",
            description: "Open OBSCam on your iOS device, then add 'Video Capture Device' in OBS.",
            imageName: "obs-step-1"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TutorialPage2: TutorialPage {
    init() {
        super.init(
            title: "Step 2:",
            description: "Select iPhone or iPad in 'Device' selector.",
            imageName: "obs-step-2"
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TutorialPage3: TutorialPage {
    init() {
        super.init(
            title: "App Information:",
            description: """
Single Tap = Hide / show controls so they won't be visible in the video feed.

Double Tap = Switch cameras.
""",
            imageName: ""
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

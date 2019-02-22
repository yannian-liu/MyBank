//
//  IsJailbroken.swift
//  Fingerprint
//
//  Created by yannian liu on 2017/4/21.
//  Copyright © 2017年 yannian liu. All rights reserved.
//

import Foundation
class YLJailbroken  {
    class func isJailbroken()-> Bool{
        
        // 1. Presence of file paths of some commonly used hacks
        let fileManager = FileManager.default
        if(fileManager.fileExists(atPath: "/Applications/Cydia.app")) ||
            (fileManager.fileExists(atPath: "/Applications/blackra1n.app")) ||
            (fileManager.fileExists(atPath: "/Applications/FakeCarrier.app")) ||
            (fileManager.fileExists(atPath: "/Applications/Icy.app")) ||
            (fileManager.fileExists(atPath: "/Applications/IntelliScreen.app")) ||
            (fileManager.fileExists(atPath: "/Applications/MxTube.app")) ||
            (fileManager.fileExists(atPath: "/Applications/RockApp.app")) ||
            (fileManager.fileExists(atPath: "/Applications/SBSettings.app")) ||
            (fileManager.fileExists(atPath: "/Applications/WinterBoard.app")) ||
            (fileManager.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist")) ||
            (fileManager.fileExists(atPath: "/Library/MobileSubstrate/DynamicLibraries/Veency.plist")) ||
            (fileManager.fileExists(atPath: "/private/var/lib/apt")) ||
            (fileManager.fileExists(atPath: "/private/var/lib/cydia")) ||
            (fileManager.fileExists(atPath: "/private/var/mobile/Library/SBSettings/Themes")) ||
            (fileManager.fileExists(atPath: "/private/var/stash")) ||
            (fileManager.fileExists(atPath: "/private/var/tmp/cydia.log")) ||
            (fileManager.fileExists(atPath: "/System/Library/LaunchDaemons/com.ikey.bbot.plist")) ||
            (fileManager.fileExists(atPath: "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist")) ||
            (fileManager.fileExists(atPath: "/usr/bin/sshd")) ||
            (fileManager.fileExists(atPath: "/usr/libexec/sftp-server")) ||
            (fileManager.fileExists(atPath: "/usr/sbin/sshd"))
        {
            return true
        }
        
        // 2. Presence of shell access
        // Since non-jailbroken iOS devices do not have shell access, the presence of shell access indicates a jailbroken device.
        
        
        // 3.Non-existence of standard framework at the expected file path
        // If the standard Foundation framework does not exist at the expected file path “/System/Library/Frameworks/Foundation.framework/Foundation“, then this absence indicates a jailbroken device.
        
        
        //4. Existence of symbolic links
//        
//        Some directories are originally located in the small system partition, however, this partition is overwritten during the jailbreak process. Therefore the data must be relocated to the larger data partition. Because the old file location must remain valid, symbolic links are created. The following list contains files/directories which would be symbolic links on a jailbroken device. An application could check for these symbolic links, and, if they exist, detect a jailbreak.
//        
//        /Library/Ringtones
//        
//        /Library/Wallpaper
//        
//        /usr/arm-apple-darwin9
//        
//        /usr/include
//        
//        /usr/libexec
//        
//        /usr/share
//        
//        /Applications
        
        
            let path_StringArray = ["/Library/Ringtones","/Library/Wallpaper","/usr/arm-apple-darwin9","/usr/include","/usr/libexec","/usr/share","/Applications"]
            for i in 0...path_StringArray.count-1 {
                
                do {
                    let path: String = try fileManager.destinationOfSymbolicLink(atPath: path_StringArray[i])
                    return true
                }catch{
                    
                }
            }



        
//        5.Writing files
//        
//        On jailbroken devices, applications are installed the /Applications folder and thereby given root privileges. A jailbroken device could be detected by having the app check whether it can modify files outside of its sandbox. This can be done by having the app attempt to create a file in, for example, the /private directory. If the file is successfully created, the device has been jailbroken.
        
        return false
    }
    
}

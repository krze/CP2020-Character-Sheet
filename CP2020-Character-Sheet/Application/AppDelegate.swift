//
//  AppDelegate.swift
//  CP2020-Character-Sheet
//
//  Created by Ken Krzeminski on 11/17/18.
//  Copyright © 2018 Ken Krzeminski. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var coordinator: CharacterSheetCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let characterSheetViewController = CharacterSheetViewController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController:characterSheetViewController)
        
        window?.rootViewController = navigationController
        
        coordinator = CharacterSheetCoordinator(with: navigationController,
                                                characterSheetViewController: characterSheetViewController)
        
        characterSheetViewController.delegate = coordinator

        
        // DEBUG delete this VVV
        
        
        let testSkill = Skill(name: "Combat Sense", nameExtension: nil,
                              description: "This ability is based on the Solo's constant training and professionalism. Combat Sense allows the Solo to perceive danger, notice traps, and have an almost unearthly ability to avoid harm. Your Combat Sense gives you a bonus on both your Awareness skill and your Initiative equal to your level in the Combat Sense skill.", isSpecialAbility: true, linkedStat: nil, modifiesSkill: "Awareness/Notice", IPMultiplier: 1)
        let factory = JSONFactory<Skill>()
        let jsonString = factory.encodedString(from: testSkill)
        if let string = jsonString {
            print(string)
        }
        
        let filePath = Bundle.main.url(forResource: "Skills", withExtension: "json")
        let data = try! Data(contentsOf: filePath!)
        let skillsFactory = JSONFactory<[Skill]>()
        let skills = skillsFactory.decode(with: data)
        
        if let skills = skills {
            print(skills)
        }
        
        // DEBUG Delete this ^^^
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


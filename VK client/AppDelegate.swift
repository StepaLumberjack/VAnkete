//
//  AppDelegate.swift
//  VK client
//
//  Created by macbookpro on 13.09.17.
//  Copyright © 2017 macbookpro. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        }
        UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.badge)
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
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Вызов обновления данных в фоне \(Date())")
        if lastUpdate != nil, abs(lastUpdate!.timeIntervalSinceNow) < 60 {
            print("Фоновое обновление не требуется, т.к. последний раз данные обновлялись \(abs(lastUpdate!.timeIntervalSinceNow)) секунд назад (меньше 60)")
            completionHandler(.noData)
            return
        }
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer?.schedule(deadline: .now(), repeating: .seconds(29), leeway: .seconds(1))
        timer?.setEventHandler { [weak self] in
            print("Не смогли загрузить данные")
            completionHandler(.failed)
            return
        }
        timer?.resume()
        let vkFriendsService = VKFriendsService()
        vkFriendsService.loadRequestsData()
        guard let realm = try? Realm() else { return }
        let redNumber = realm.objects(FriendRequest.self).count
        requestNotification(redNumber)
        print(realm.configuration.fileURL)
        
        timer = nil
        lastUpdate = Date()
        completionHandler(.newData)
        print("Двнные загружены в фоне")
    }

}


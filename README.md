# CurrencyTradingDemo
Real time Bitcoin rates update(based on latest data reflect buy/sell rate of bitcoins in various country)

Overview:
The output of this technical task, should be an app which displays a simple order placement ticket, showing real-time updating Bitcoin prices.

For price updates, write a price service that polls the following URL every 15 seconds:
https://blockchain.info/ticker

This will return prices in JSON format. For more information see the simple API documentation here: https://www.blockchain.com/en/api


<---Overview--->
* Programming paradigm and design patterns used
  * OOP
  * Singleton, KVO, Observer 
* Application Architecture
  * Combination of Modular and MVVM
* Included efforts to adhere to Engineering best practices
  * SOLID principles
  * Test case writing and code coverage gathering
  * Clean,Testable, Scalable, Reusable and Maintainable code writing
* Dependency
  * N/A
* Deployment target: iOS 11
* Supported devices: iPad and iPhone
* Xcode  version used: 11.3
* Code coverage: 43.2 %
* Assumptions
  * No CACHING OR LOCAL STORAGE required
  * Initial alphabatical sorting on client side while displaying bitcoin rates in various currency in tableview.
  * Numbers with two decimal points supported through out application(buy rate, sell rate, units, amount etc)
* Approximate time estimation and efforts involved for this application development
  * Application architecture, basic utility and infra setup: 2 hours
  * Application reusable(and independent) components/classes/methods and basic utility setup: 2 hours
  * Unit test case writing: 1.5 hours
  * User interface flow and design: 4 hours
  * ViewControllers and viewModel programming: 3 hours
  * Readme/Documentation and video recording: 0.5 hour
* User Interface and Application Demo link
  * Link to download video(expires in 7 days)
  * Youtube link:
* Limitations/known issues
  * LandingScreen::Minor user expereince concern in simultaneous tableview cells loading including animation of labels --> Here, List of bitcoin rates across of different countries shown and real time update happens based on API polling
* Future scalability/requirements/features possibility/Scope of improvements
  * Instead of API polling, we might go with silent push notifications
  * Although, here, usage of KVO along with proper state/flow management gives seamless experience(with code readability as well) , we might utilise thirdparty RxSwift or latest native offering SwiftUI+Combine.
* Approach overview
  * Stick to MVP first with possibility of scaling slowly/periodically.
  * Write modular and maintainable code with proper architecture, standard practices and documentation.
  * Have basic code coverage and write more test cases and have automated test suite ready before deployment(considering timeline and priority including sense of business impact/urgency).






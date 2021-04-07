import UIKit
import PlaygroundSupport
/*:
 # Hands

 ## About me:

 Hi, my name is Tamerlan and I am an 18 year old student from Kazakhstan. I'm a self-taught software engineer who likes to use Swift and Apple's cool new frameworks in mobile app development. I always wanted to participate in the Swift Student Challenge, the first time I learned about this competition in 2018, since then I could not take part due to the fact that information about the dates of the event unfortunately passed me by, and I am glad that in 2021 I am participating in this competition.

 ## About project:

 I have always been interested in how I can improve my memory in addition to reading books, and once I came across an interesting technique related to hand gestures, it seemed to me a very interesting activity with good advantages, since in addition to improving memory, these exercises also prevented the possibility of developing Alzheimer's disease. So for this contest, I decided to choose this topic and create a really useful app for people who care about the health of their brain.

 Once launched, the app will offer you a choice of two game modes: remember the sequence and repeat the sequence.

 The **remember sequence mode** is similar to the Simon game, where a sequence of gestures will be shown at the beginning, which will then need to be repeated in the same order.

 **Repeat sequence mode** is a game in which you need to have time to show a gesture that will be in focus. The mechanics of the game are similar to the popular rhythm game Just Dance.

 In each mode, the difficulty of the game will increase as you progress. So for the remember sequence mode, the number of gestures to repeat will increase, and for the repeat sequence mode, the frequency of new gestures will also increase.

 ## How it works?

 In order to determine which gesture was shown by the user, the application recognizes which fingers were extended. **The extended fingers are determined by comparing the distances from each phalanx to the wrist.** So, for example, if the distance from the distal phalanx is greater than the distance from the intermediate phalanx, then the finger is marked as extended. This algorithm applies to all fingers except the thumb. **To determine whether the thumb is extended, the processing of the angle formed by the distal and metacarpal phalanges is added.**

 ## Frameworks:

 I really like the new Apple SwiftUI framework for creating interfaces and its declarative style, which makes it easy to create cool interfaces, but here I decided to stop at UIKit, because I have more experience in using this technology. I also used the Vision framework to recognize the hand gestures that the user shows.
 */
PlaygroundPage.current.setLiveView(HomeViewController())

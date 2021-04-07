<img align="right" src="https://github.com/onl1ner/onl1ner/blob/master/Resources/Hands/icon.png" width="256"/>

# Hands

I have always been interested in how I can improve my memory in addition to reading books, and once I came across an interesting technique related to hand gestures, it seemed to me a very interesting activity with good advantages, since in addition to improving memory, these exercises also prevented the possibility of developing **Alzheimer's disease**. So for this contest, I decided to choose this topic and create a really useful app for people who care about the health of their brain.

Once launched, the app will offer you a choice of two game modes: remember the sequence and repeat the sequence.

The **remember sequence mode** is similar to the [Simon game](https://en.wikipedia.org/wiki/Simon_(game)), where a sequence of gestures will be shown at the beginning, which will then need to be repeated in the same order.

**Repeat sequence mode** is a game in which you need to have time to show a gesture that will be in focus. The mechanics of the game are similar to the popular rhythm game [Just Dance](https://en.wikipedia.org/wiki/Just_Dance_(video_game_series)).

In each mode, the difficulty of the game will increase as you progress. So for the remember sequence mode, the number of gestures to repeat will increase, and for the repeat sequence mode, the frequency of new gestures will also increase.

## How it works?

In order to determine which gesture was shown by the user, the application recognizes which fingers were extended. **The extended fingers are determined by comparing the distances from each phalanx to the wrist.** So, for example, if the distance from the distal phalanx is greater than the distance from the intermediate phalanx, then the finger is marked as extended. This algorithm applies to all fingers except the thumb. **To determine whether the thumb is extended, the processing of the angle formed by the distal and metacarpal phalanges is added.**

## Frameworks

I really like the new Apple SwiftUI framework for creating interfaces and its declarative style, which makes it easy to create cool interfaces, but here I decided to stop at UIKit, because I have more experience in using this technology. I also used the Vision framework to recognize the hand gestures that the user shows.

## License
**Hands** is under the terms and conditions of the MIT license.

```
MIT License

Copyright (c) 2021 Tamerlan Satualdypov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

# LanguageGame

The app consists on a language game where two words are presented in every round. One of the words is supposed to be the translation of the other one in a second language. 

The challenge for the player is to identify if the translation is correct or not. Everytime he is able to do that, a new point is scored.

#### Built with

Xcode 10.0, Swift 4.2

## Sum up
- How much time was invested

  The code challenge took me a couple of days of work.

  ​

- How was the time distributed (concept, model layer, view(s), game mechanics)

  Concept was the first thing I worked on (I'd say around 20 min for thinking and drawing a sketch of how the app should look and work). Data fetching and having it available to use, took me a few hours.

  The views implementation was the fastest thing and the rest of the time was invested on implementing and solving the game mechanic problems.

  ​


- Decisions made to solve certain aspects of the game

  I found a couple of important aspects:

  - How to present randomly the matches without falling into a pattern and still presenting the correct ones with reasonable probability.

    For this, I created random numbers to decide which rounds a correct match would be presented and which ones not. With this I avoided to be previsible and the amount of correct matches were still higher than the wrong ones.

  - How to check that the match is the correct and also that the player chooses the correct answer even though he presses the ```selectWrong``` button.

    I decided to track both of them creating two different Bool variables:  ```isCorrectTranslation``` and ```isCorrectAnswer```

    ​

- Decisions made because of restricted time

  After several trials, I couldn't find a good way to implement the feature related with the limited time to answer (*"The player needs to answer before the word reaches the bottom of the screen"*). So I decided to move on and keep the game as it is now. The player needs to answer something to continue playing. 

  This meant discarding the approach of the no answer rounds. Nevertheless, my first idea was to track this rounds and store the english words into a third array. So at the end of the game (when results are showed) the player would have the option to try again those words and score a few more points.

  Even though the task took me longer than it was supposed to, I didn't want to exceed the one week term specified, and that's the reason why I didn't work in the UI either.

  ​

- What would be the first thing to improve or add if there had been more time

  I'd say implement the time to answer in order to at least complete all the requirements of the challenge.
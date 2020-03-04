

# Dungeon Mayhem Game created with Ruby on Rails and ReactJs

This repository is the implementation of the popular [Dungeon Mayhem](https://media.wizards.com/2019/dnd/downloads/DnD_Mayhem.pdf) using api build on [Ruby on Rails](https://rubyonrails.org/) and front-end build using [ReactJs](https://reactjs.org/) and using [Pubnub](https://admin.pubnub.com/) as broadcasting tool.


## Pre-requisites
  

### For Ruby on rails

  - Ruby 2.6.3

  - Rails 6.0.2.1

### For ReactJs

  - ReactJs 16.12.0
  
 #### Other requirements
  - npm 6.13.7
  
  - node v13.7.0
  
# Steps to Run the APP

This repository consists of two sections.
  - Rails API
  - React Front-End
 
So, we will need to run two projects seperately to play the game.

### Step 1: Setting Up Rails API
  
  **Step 1.1:** Navigate to Rails Project
  ```bash
    $ cd card-ruby
  ```
  **Step 1.2:** Bundle all related packages for project
  ```bash
    $ bundle install
  ```
  
  **Step 1.3:** Setting Up database
  ```bash
    $ rake db:migrate
  ```
  #### This game is played by multiplayer. So we need to host the api using our IP.
  **Step 1.4:** Run rails server
  ```bash
    $ rails server -b <your_ip> -p 3001
  ```
  
  This will run the rails api on port 3001: (http://<your_ip>:3001)
  

### Step 2: Setting Up React Front-End
  **Step 2.1:** Navigate to React Project
  ```bash
    $ cd boggle-front
  ```
  **Step 2.2:** Install all related packages for project
  ```bash
    $ npm install
  ```
  **Step 2.3:** Run the app
  ```bash
    $ npm start
  ```
  
  This will run the rails api on port 3000: (http://localhost:3000)
  
  
## Preview (screenshots)

#### 1. Rails API HomePage
  <img src="boggle-api\resources\api-home.png" alt="API Home Page" style="zoom: 60%;" />

#### 2.1. Boggle Game Home
![Web Home](boggle-front/resources/web-home.png)

#### 2.2. Boggle Game Board
![Web Board](boggle-front/resources/web-board.png)
#### 2.3. Boggle Game ScoreBoard
![Web Score](boggle-front/resources/web-score.png)


## Testing the Rails APIs

**Step 1:** Navigate to Rails Project
  ```bash
    $ cd boggle-api
  ```
**Step 2:** Execute test
  ```bash
    $ bundle exec rspec
  ```




## License

MIT © [Technables](https://github.com/technables) 
  
  
## Credits and References

- [Wikipedia Definition](https://en.wikipedia.org/wiki/Boggle)
- [JS-Boggle-Game](https://github.com/zhouyuhang/JS-Boggle-Game)
- [boggle-rails-react](https://github.com/zaagan/boggle-rails-react)
  


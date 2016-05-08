#StarWarsIntro.css
A CSS Library for the Star Wars Intro Crawl

####What is this?
Star Wars Intro is a small CSS Library to build your own Star Wars-esk intro. Use it for a movie marathon you're hosting, a browser game intro, a fan site, or pretty much anything else.

####Requirements
To install the Star Wars Into you'll need:
..* HTML
..* CSS

####Installation
The installation process is simple. Download the css file and add the html sample. You can put anything you want inside of the 'content-body'. The CSS will do the rest.

```html
<!-- Place in document head -->
<link rel="stylesheet" href="/path/to/starwarsintro.css">

<!-- Place in Body where you'd like intro to appear -->
<div class="star-wars-intro">

  <!-- Blue Intro Text -->
  <p class="intro-text">
    A few days ago, during...
  </p>

  <!-- Logo Image or Text goes in here -->
  <h2 class="main-logo">
    <img src="img/star-wars-intro.png">
  </h2>

  <!-- All Scrolling Content Goes in here -->
  <div class="main-content">

    <div class="title-content">
      <p class="content-header">EPISODES IV-VI<br/>A Movie Marathon</p>

      <br>

      <p class="content-body">
        After years of galactic silence, civilization is on the brink of a new Star Wars release. Now, with the Force preparing to awaken, the people of Earth seek solace in films of old. With nowhere to turn, they gather in great numbers and watch the original trilogy without rest. Three films. 6 hours. 24 minutes. Popcorn. Slushies. Total elation.
      </p>

      <!-- button or link or whatever -->
      <a href="./StarScroll.zip" class="space-button">Download The Code Now!</a>
        
    </div>
  </div>
</div>
```


##Sources: [polarnotion](https://polarnotion.github.io/starwarsintro/)
# Database Optimizations

## Description

Given an existing application which generates a report from a large data set, improve the efficiency of the report using database optimization methods.

## Deliverables

* **An estimate.**  After you read through this assignment (but before you start coding), write down a number of hours that you expect each part to take (1-3).  Record your hours as you go.
* **A repository.** You will be working from the existing application found in this repository, but you will make your own copy.
* **A README.** The README should include data on all of the metrics requested below.
* **A test suite.** Build your application using TDD.  Your test suite must include unit tests, controller tests, and at least two integration tests.
* **A reflection on your estimate.**


#### Part One - Analysis

For this project, you will be starting with an application which runs very slowly.  This inefficiency is due partly to the sheer amount of data present, but mostly due to the structure of the code and the database.  Your task is to make it run in a reasonable amount of time.

Once you pull down the application from GitHub, run `bundle install` and `rake db:migrate`, then follow the steps below.

* [x] Run `rake db:seed`.  When it is finished, it  will tell you how long the process took (in seconds).  Record the amount of time. *_2350.942623 seconds_*
* [x] Turn on your server and open your browser to `localhost:3000`.  You will have to sort out which parameters you need to pass it.
* [x] Open Chrome's timeline in developer tools, then hit Cmd-R on your keyboard.  The timeline will track time to load the page.  Record the following:
  * [x] Total time in Chrome's timeline *_3907 seconds_*
  * [x] "Idle" time in Chrome's timeline *_crashed without giving info_*
  * [x] The time given by Rails at the top of the page *_1320.891084 seconds_*
  * [x] The time given by Rails at the bottom of the page (sorry for the long scroll) *_1322.042374 seconds_*
  * [x] Explain what these four numbers are and which are subsets of the others *_The time given by Rails is a subset of the total time. It took very long to search the database, but not long at all to render as HTML_*
* [x] Add appropriate indices to the data structure (via migrations).
* [x] Record how long it takes to run the migrations that add indices. *_0.6943 sec_*
* [x] Reload the root page and record the four time numbers again.  Calculate your percent improvement in runtime.
  * [x] Total time in Chrome's timeline *_18.7 seconds_*
  * [x] "Idle" time in Chrome's timeline *_882.49 ms_*
  * [x] The time given by Rails at the top of the page *_5.577238 seconds_*
  * [x] The time given by Rails at the bottom of the page (sorry for the long scroll) *_6.833341 seconds_*
* [x] Examine the code that is run when the root path loads.  Modify the controller commands which access the database to make them more efficient.
* [x] Calculate your percent improvement in runtime.
  * [x] Total time in Chrome's timeline *_9.8 seconds_*
  * [x] "Idle" time in Chrome's timeline *_897.81 ms_*
  * [x] The time given by Rails at the top of the page *_0.016127 seconds_*
  * [x] The time given by Rails at the bottom of the page (sorry for the long scroll) *_3.02472 seconds_*
* [x] Once you have optimized your code as much as you think you can, drop the database, run `rake db:migrate`, and then time how long it takes to run `rake db:seed`.  Was there an improvement or a worsening of runtime?  By what percent and why? *_1882.299137 seconds, it was much faster but I think it was because I was streaming The Walking Dead during the first seed and not doing anything during the second seed. I would have thought it would take longer to seed the second time based on creating the indices._*
* [x] Which is faster: (a) running `rake db:seed` without indices and then running a migration to add indices, or (b) adding indices during your initial `rake db:migrate`, then running `rake db:seed`? *_I think (a), running db:seed before adding indices_*

You've done a thorough job of analyzing runtime, but now take a look at storage space:

* Record the size of your database (in bytes). *_570 MB_*
* Record the size of your development log. *_1.48 GB_*
* Give at least one method (feel free to Google) for reducing the size of one of these, yet keeping your data intact. *_using data compression_*
* Do you think that this is smaller, about right, or larger than the size of databases you'll be working with in your career? *_either about right or smaller_*

Now let's talk about the "memory" numbers given on the page.  What impact have your changes had on memory usage?  If you reload a page again and again (with no code changes in between reloads), does memory used stay the same?  Have you ever been able to make memory used go down? *_memory used stays the same between page loads_*

#### Part Two - Search Bar

A common feature which you'll be asked to develop is a Google-like search.  You enter information in one field, and results are returned when any one of a number of fields matches what you entered.

Create a new action in your `reports` controller which loads the same data, but with no `:name` parameter.  Call the new action/view/route `search`.  In the view, add a single search field (and search button).  The user should be able to type any part of an assembly's `name`, a hit's `match_gene_name` OR a gene's `dna` field.  When the search button is pressed, the page will reload and the user will be shown all of the hits for which any of those things match.

In other words, if a user types in "special" and one assembly has a `name` "Special Assembly" (and no hits have "special" in their `match_gene_name`), all hits for just that assembly will be shown.  If a user types in "tetanus" and only one hit has a `match_gene_name` which includes "tetanus" (and no assemblies have "tetanus" in their `name`), only that one hit will be shown.  If a user types in "AACCGGTT", only hits for genes with "AACCGGTT" in them should be shown.

The search should also be case insensitive.

##### Estimate

I think part one will take 4 hours and part two will take 2 hours.
*_Part one took closer to 5 hours and part two took 2 hours_*

### Day Two
Page took almost 3 minutes to load importing CSV in the foreground.

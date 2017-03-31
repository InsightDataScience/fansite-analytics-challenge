# Table of Contents
1. [Challenge Summary](README.md#challenge-summary)
2. [Details of Implementation](README.md#details-of-implementation)
3. [Download Data](README.md#download-data)
4. [Description of Data](README.md#description-of-data)
5. [Writing clean, scalable, and well-tested code](README.md#writing-clean-scalable-and-well-tested-code)
6. [Repo directory structure](README.md#repo-directory-structure)
7. [Testing your directory structure and output format](README.md#testing-your-directory-structure-and-output-format)
8. [Instructions to submit your solution](README.md#instructions-to-submit-your-solution)
9. [FAQ](README.md#faq)


# Challenge Summary

Picture yourself as a backend engineer for a NASA fan website that generates a large amount of Internet traffic data. Your challenge is to perform basic analytics on the server log file, provide useful metrics, and implement basic security measures. 

The desired features are described below: 

### Feature 1: 
List the top 10 most active host/IP addresses that have accessed the site.

### Feature 2: 
Identify the 10 resources that consume the most bandwidth on the site

### Feature 3:
List the top 10 busiest (or most frequently visited) 60-minute periods 

### Feature 4: 
Detect patterns of three failed login attempts from the same IP address over 20 seconds so that all further attempts to the site can be blocked for 5 minutes. Log those possible security breaches.


### Other considerations and optional features
It's critical that these features don't take too long to run. For example, if it took too long to detect three failed login attempts, further traffic from the same IP address couldn’t be blocked immediately, and that would present a security breach.
This dataset is inspired by real NASA web traffic, which is very similar to server logs from e-commerce and other sites. Monitoring web traffic and providing these analytics is a real business need, but it’s not the only thing you can do with the data. Feel free to implement additional features that you think might be useful.

## Details of Implementation
With this coding challenge, you should demonstrate a strong understanding of computer science fundamentals. We won't be wowed by your knowledge of various available software libraries, but will be impressed by your ability to pick and use the best data structures and algorithms for the job.

We're looking for clean, well-thought-out code that correctly implements the desired features in an optimized way and highlights your ability to write production-quality code.

We also want to see how you use your programming skills to solve business problems. At a minimum, you should implement the four required features, but feel free to expand upon this challenge or add other features you think would prevent fraud and further business goals. Be sure to document these add-ons so we know to look for them.

### Feature 1 
List in descending order the top 10 most active hosts/IP addresses that have accessed the site.

Write to a file, named `hosts.txt`, the 10 most active hosts/IP addresses in descending order and how many times they have accessed any part of the site. There should be at most 10 lines in the file, and each line should include the host (or IP address) followed by a comma and then the number of times it accessed the site. 

e.g., `hosts.txt`:

    example.host.com,1000000
    another.example.net,800000
    31.41.59.26,600000
    …


### Feature 2 
Identify the top 10 resources on the site that consume the most bandwidth. Bandwidth consumption can be extrapolated from bytes sent over the network and the frequency by which they were accessed.

These most bandwidth-intensive resources, sorted in descending order and separated by a new line, should be written to a file called `resources.txt`


e.g., `resources.txt`:
    
    /images/USA-logosmall.gif
    /shuttle/resources/orbiters/discovery.html
    /shuttle/countdown/count.html
    …


### Feature 3 
List in descending order the site’s 10 busiest (i.e. most frequently visited) 60-minute period.

Write to a file named `hours.txt`, the start of each 60-minute window followed by the number of times the site was accessed during that time period. The file should contain at most 10 lines with each line containing the start of each 60-minute window, followed by a comma and then the number of times the site was accessed during those 60 minutes. The 10 lines should be listed in descending order with the busiest 60-minute window shown first. 

e.g., `hours.txt`:

    01/Jul/1995:00:00:01 -0400,100
    02/Jul/1995:13:00:00 -0400,22
    05/Jul/1995:09:05:02 -0400,10
    01/Jul/1995:12:30:05 -0400,8
    …

A 60-minute window can be any 60 minute long time period, windows don't have to start at a time when an event occurs.

### Feature 4 
Your final task is to detect patterns of three consecutive failed login attempts over 20 seconds in order to block all further attempts to reach the site from the same IP address for the next 5 minutes. Each attempt that would have been blocked should be written to a log file named `blocked.txt`.

The site’s fictional owners don’t expect you to write the actual web server code to block the attempt, but rather want to gauge how much of a problem these potential security breaches represent. 

Detect three failed login attempts from the same IP address over a consecutive 20 seconds, and then write to the `blocked.txt` file any subsequent attempts to reach the site from the same IP address over the next 5 minutes. 

For example, if the third consecutive failed login attempt within a 20 second window occurred on `01/Aug/1995:00:00:08`, all access to the website for that IP address would be blocked for the next 5 minutes. Even if the same IP host attempted a login -- successful or not -- one minute later at `01/Aug/1995:00:01:08`, that attempt should be ignored and logged to the `blocked.txt` file. Access to the site from that IP address would be allowed to resume at `01/Aug/1995:00:05:09`.

If an IP address has not reached three failed login attempts during the 20 second window, a login attempt that succeeds during that time period should reset the failed login counter and 20-second clock. 

For example, if after two failed login attempts, a third login attempt is successful, full access should be allowed to resume immediately afterward. The next failed login attempt would be counted as 1, and the 20-second timer would begin there. In other words, this feature should only be triggered if an IP has  3 failed logins in a row, within a 20-second window.

e.g., `blocked.txt`

    uplherc.upl.com - - [01/Aug/1995:00:00:07 -0400] "GET / HTTP/1.0" 304 0
    uplherc.upl.com - - [01/Aug/1995:00:00:08 -0400] "GET /images/ksclogo-medium.gif HTTP/1.0" 304 0
    …

The following illustration may help you understand how this feature might work, and when three failed login attempts would trigger 5 minutes of blocking:


![Feature 4 illustration](images/feature4.png)


Note that this feature should not impact the other features in this challenge. For instance, any requests that end up in the `blocked.txt` file should be counted toward the most active IP host calculation, bandwidth consumption and busiest 60-minute period.

### Additional Features

Feel free to implement additional features that might be useful to derive further metrics or prevent harmful activity. These features will be considered as bonus while evaluating your submission. If you choose to add extras please document them in your README and make sure that they don't interfere with the above four (e.g. don't alter the output of the four core features).

## Download Data
You can download the data here: https://drive.google.com/file/d/0B7-XWjN4ezogbUh6bUl1cV82Tnc/view

## Description of Data

Assume you receive as input, a file, `log.txt`, in ASCII format with one line per request, containing the following columns:

* **host** making the request. A hostname when possible, otherwise the Internet address if the name could not be looked up.

* **timestamp** in the format `[DD/MON/YYYY:HH:MM:SS -0400]`, where DD is the day of the month, MON is the abbreviated name of the month, YYYY is the year, HH:MM:SS is the time of day using a 24-hour clock. The timezone is -0400.

* **request** given in quotes.

* **HTTP reply code**

* **bytes** in the reply. Some lines in the log file will list `-` in the bytes field. For the purposes of this challenge, that should be interpreted as 0 bytes.


e.g., `log.txt`

    in24.inetnebr.com - - [01/Aug/1995:00:00:01 -0400] "GET /shuttle/missions/sts-68/news/sts-68-mcc-05.txt HTTP/1.0" 200 1839
    208.271.69.50 - - [01/Aug/1995:00:00:02 -400] "POST /login HTTP/1.0" 401 1420
    208.271.69.50 - - [01/Aug/1995:00:00:04 -400] "POST /login HTTP/1.0" 200 1420
    uplherc.upl.com - - [01/Aug/1995:00:00:07 -0400] "GET / HTTP/1.0" 304 0
    uplherc.upl.com - - [01/Aug/1995:00:00:08 -0400] "GET /images/ksclogo-medium.gif HTTP/1.0" 304 0
    ...
    
In the above example, the 2nd line shows a failed login (HTTP reply code of 401) followed by a successful login (HTTP reply code of 200) two seconds later from the same IP address.

## Writing clean, scalable, and well-tested code

As a data engineer, it’s important that you write clean, well-documented code that scales for large amounts of data. For this reason, it’s important to ensure that your solution works well for a huge number of logged events, rather than just the simple examples above.

For example, your solution should be able to account for a large number of events coming in over a short period of time, and need to keep up with the input (i.e. need to process a minute worth of events in less than a minute).

It's also important to use software engineering best practices like unit tests, especially since public data is not clean and predictable. For more details about the implementation, please refer to the FAQ below. If further clarification is necessary, email us at <cc@insightdataengineering.com>

You may write your solution in any mainstream programming language such as C, C++, C#, Clojure, Erlang, Go, Haskell, Java, Python, Ruby, or Scala. Once completed, submit a link to a Github repo with your source code.

In addition to the source code, the top-most directory of your repo must include the `log_input` and `log_output` directories, and a shell script named `run.sh` that compiles and runs the program(s) that implement these features.

If your solution requires additional libraries, environments, or dependencies, you must specify these in your `README` documentation. See the figure below for the required structure of the top-most directory in your repo, or simply clone this repo.

## Repo directory structure

The directory structure for your repo should look like this:

    ├── README.md 
    ├── run.sh
    ├── src
    │   └── process_log.py
    ├── log_input
    │   └── log.txt
    ├── log_output
    |   └── hosts.txt
    |   └── hours.txt
    |   └── resources.txt
    |   └── blocked.txt
    ├── insight_testsuite
        └── run_tests.sh
        └── tests
            └── test_features
            |   ├── log_input
            |   │   └── log.txt
            |   |__ log_output
            |   │   └── hosts.txt
            |   │   └── hours.txt
            |   │   └── resources.txt
            |   │   └── blocked.txt
            ├── your-own-test
                ├── log_input
                │   └── your-own-log.txt
                |__ log_output
                    └── hosts.txt
                    └── hours.txt
                    └── resources.txt
                    └── blocked.txt

You simply clone this repo, but <b>please don't fork</b> it.
The contents of `src` do not have to contain a single file called `process_log.py`, you are free to include one or more files and name them as you wish.

## Testing your directory structure and output format

To make sure that your code has the correct directory structure and the format of the output files are correct, we included a test script, called `run_tests.sh` in the `insight_testsuite` folder.

The tests are stored simply as text files under the `insight_testsuite/tests` folder. Each test should have a separate folder and within should have a `log_input` folder for `log.txt` and a `log_output` folder for outputs corresponding to the current test.

You can run the test with the following from the `insight_testsuite` folder:

    insight_testsuite~$ ./run_tests.sh 

On a failed test, the output of `run_tests.sh` should look like:

    [FAIL]: test_features (hosts.txt)
    [FAIL]: test_features (resources.txt)
    [PASS]: test_features (hours.txt)
    [FAIL]: test_features (blocked.txt)
    [Thu Mar 30 16:28:01 PDT 2017] 1 of 4 tests passed

On success:

    [PASS]: test_features (hosts.txt)
    [PASS]: test_features (resources.txt)
    [PASS]: test_features (hours.txt)
    [PASS]: test_features (blocked.txt)
    [Thu Mar 30 16:25:57 PDT 2017] 4 of 4 tests passed



One test has been provided as a way to check your formatting and simulate how we will be running tests when you submit your solution. We urge you to write your own additional tests here as well as for your own programming language. `run_tests.sh` should alert you if the directory structure is incorrect.

Your submission must pass at least the provided test in order to pass the coding challenge.

## Instructions to submit your solution
* To submit your entry please use the link you receieved in your coding challenge invite email
* You will only be able to submit through the link one time 
* Do NOT attach a file - we will not admit solutions which are attached files 
* Use the submission box to enter the link to your github repo or bitbucket ONLY
* Link to the specific repo for this project, not your general repo
* Put any comments in the RADME File inside your Project repo, not in the submission box
* We are unable to accept coding challenges that are emailed to us 

# FAQ

Here are some common questions we've received. If you have additional questions, please email us at `cc@insightdataengineering.com` and we'll answer your questions as quickly as we can, and update this FAQ.

### Which Github link should I submit?
You should submit the URL for the top-level root of your repository. For example, this repo would be submitted by copying the URL `https://github.com/InsightDataScience/fansite-analytics-challenge` into the appropriate field on the application. Do NOT try to submit your coding challenge using a pull request, which would make your source code publicly available.

### Do I need a private Github repo?
No, you may use a public repo, there is no need to purchase a private repo. You may also submit a link to a Bitbucket repo if you prefer.

### May I use R, Matlab, or other analytics programming languages to solve the challenge?
It's important that your implementation scales to handle large amounts of data. While many of our Fellows have experience with R and Matlab, applicants have found that these languages are unable to process data in a scalable fashion, so you should consider another language.

### May I use distributed technologies like Hadoop or Spark?
While you're welcome to do so, your code will be tested on a single machine so there may not be a significant benefit to using these technologies prior to the program. With that said, learning about distributed systems is a valuable skill for all data engineers.

### What sort of system should I use to run my program on (Windows, Linux, Mac)?
You may write your solution on any system, but your source code should be portable and work on all systems. Additionally, your run.sh must be able to run on either Unix or Linux, as that's the system that will be used for testing. Linux machines are the industry standard for most data engineering teams, so it is helpful to be familiar with this. If you're currently using Windows, we recommend using tools like Cygwin or Docker, or a free online IDE such as Cloud9.

### How fast should my program run?
While there are no strict performance guidelines to this coding challenge, we will take the amount of time your program takes into consideration in grading the challenge. Therefore, you should design and develop your program in the most optimal way. 

### Can I use pre-built packages, modules, or libraries?
This coding challenge can be completed without any "exotic" packages. While you may use publicly available packages, modules, or libraries, you must document any dependencies in your accompanying README file. When we review your submission, we will download these libraries and attempt to run your program. If you do use a package, you should always ensure that the module you're using works efficiently for the specific use-case in the challenge, since many libraries are not designed for large amounts of data.

### Can I use a database engine?
This coding challenge can be completed without the use of a database. However, if you must use one, it must be a publicly available one that can be easily installed with minimal configuration.

### Will you email me if my code doesn't run?
Unfortunately, we receive hundreds of submissions in a very short time and are unable to email individuals if code doesn't compile or run. This is why it's so important to document any dependencies you have, as described in the previous question. We will do everything we can to properly test your code, but this requires good documentation. More so, we have provided a test suite so you can confirm that your directory structure and format are correct.

### Do I need to use multi-threading?
No, your solution doesn't necessarily need to include multi-threading - there are many solutions that don't require multiple threads/cores or any distributed systems, but instead use efficient data structures.

### What should the format of the output be?
In order to be tested correctly, you must use the format described above. You can ensure that you have the correct format by using the testing suite we've included. If you are still unable to get the correct format from the debugging messages in the suite, please email us at `cc@insightdataengineering.com`.

### How should I handle ties in the data for feature 1-3? Should I list all the hosts/resources, or only 10? If only 10, how do I decide which 10?
In the event of ties for features, please only list 10 entries, using lexicographical order to sort them.

### Should I check if the files in the input directory are text files or non-text files(binary)?
No, for simplicity you may assume that all of the files in the input directory are text files, with the format as described above.

### Can I use an IDE like Eclipse or IntelliJ to write my program?
Yes, you can use what ever tools you want - as long as your run.sh script correctly runs the relevant target files and creates the `hosts.txt`, `hours.txt`, `resources.txt`, `blocked.txt` files in the `log_output` directory.

### What should be in the log_input directory?
You can put any text file you want in the directory since our testing suite will replace it. Indeed, using your own input files would be quite useful for testing. The file size limit on Github is 100 MB so you won't be able to include the provided input file in your log_input directory.

### How will the coding challenge be evaluated?
Generally, we will evaluate your coding challenge with a testing suite that provides a variety of inputs and checks the corresponding output. This suite will attempt to use your `run.sh` and is fairly tolerant to different runtime environments. Of course, there are many aspects (e.g. clean code, documentation) that cannot be tested by our suite, so each submission will also be reviewed manually by a data engineer.

### How long will it take for me to hear back from you about my submission?
We receive hundreds of submissions and try to evaluate them all in a timely manner. We try to get back to all applicants within two or three weeks of submission, but if you have a specific deadline that requires expedited review, you may email us at `cc@insightdataengineering.com`.

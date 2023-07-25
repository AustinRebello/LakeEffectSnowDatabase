# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: ruby "3.2.2" #Gemfile
* Rails version: rails "7.0.5" #Gemfile
* Python version: python 3.10.11

**HOW I GOT THE PROJECT UP AND RUNNING ON A CLEAN WINDOWS MACHINE**

Install the Ruby programming language, at least version 3.2.2 or later.
rubyinstaller.org/downloads
Select the version from the "With DEVKITs" list and make sure its for (x64)
I used 3.2.2-1 (x64) for the clean install.
Run the executable and install for all users, not just your own.
Follow all instructions within the installer, including for MSYS2. Enter 1 for when it prompts you for which type of MSYS2 installation you want to download.
It may initially say it failed and asked for another input or enter to continue. Hit enter to continue, it will run the installer.

Install the Python programming language, at least version 3.10 or later.
python.org/downloads
Install python for all users using the executable file (need to hit custom installation most likely).

Install Git for Windows, latest version.
gitforwindows.org
Run the executable file, make sure the all users options are enabled, and git bash gets enabled as you will need to use git bash. All other settings can be left as default or customized to your preference.

Since everything was installed for all users, it should have all installed to the C drive. Navigate to the C drive in a command prompt window.
Command: cd C://

Test to make sure all the components installed correctly with the following commands
ruby -v
python --version
Open git bash and type git -v
If the version is not printed, it did not install correctly.

Navigate to where you wish for the project to go. Downloading the project puts it into a folder for you, so if you stay in the C drive, it will create a folder on the C drive for you.
When you reach that folder, first run the command "gem install rails"
Then in git bash, navigate to the same folder and run the command "git clone XXXX" where the XXXX is the link to this repository.

Once the project gets cloned down, navigate within the folder using Git bash and run the following commands.
bundle install
rails db:create
rails db:migrate
pip install numpy
pip install metpy

After everything is installed, you are now ready to use the database, which you can start up by typing "rails s" or "rails server" in that Git Bash window while within the project folder. Open up any web browser and go to "localhost:3000" to reach the webpage.

You will likely need to hit F5 (or refresh) the page nearly immediately as it will likely redirect you to an error since it is the first time setting up and needs to initialize a cache.

If you encounter issues where the site throws an error, see Git Bash where the server is running to identify the true error. If it is a python error where one of the imports fails, you will need to "pip install XXXX" that package.

Once you are done using the server for that instance, in Git Bash, press Ctrl+C to close the server.
If you cannot reopen the server due to it saying its "already running," navigate to the tmp/pids folder and delete anything that is not the .keep file.

Any other questions or concerns, please feel free to email me at **austinrebello02@gmail.com / austin.rebello@noaa.gov** and I will try to assist in any necessary installation issues or local debugging.
=
=
=
**How to add/remove/edit sites for BUFKIT, METAR, Surface Observations and Archive URLs:**
Cleveland's settings will be left in as an example of how to properly format each type of data collection.

PAGE REFRESHES MENTIONED BELOW ARE ONLY REQUIRED POST WEB SERVER DEPLOYMENT
It is strongly recommended to add all desired sites prior to running the web server.

BUFKIT:
    First, collect all the desired sites, including their k prefix if they contain one, but do not add the k if it does not (Ex: le1)
    Type out all the sites in the format of ["kcle", "keri", "kbuf", ...]. ##MUST BE ALL LOWERCASE##
    Please pay attention to the order in which you typed those sites as the order must remain the same across all files you will edit.
    Copy this list in its entirety, including the [ ].
    Replace the existing list in lib/assets/getBufkit.py on line 33 with this list.
    Replace the existing list in app/controllers/lake_effect_snow_events_controller.rb on line 5 with this list.
    Replace the existing list in app/controllers/bufkits_controller.rb on line 36 with this list.
    Replace the existing list in app/views/bufkits/index.html.erb on line 3 with this list.
    Replace the existing list in app/views/lake_effect_snow_events/show.html.erb on line 64 with this list.

    When simply adding or removing a site to an existing list, just add the ', "ksite"' to the end of all 5 lists.
    After this is done, the bufkit data can be generated, do note that you may have to refresh the page for changes to fully take effect.
    Otherwise, some tables may be displaying that should not, or old columns may still persist until a clean refresh is completed.

METAR:
    First, collect all desired sites, they must all be fully capitalized.
    Type out all the sites in the format of ["CLE","ERI","BUF", ...].
    Please pay attention to the order in which you typed those sites as the order must remain the same across all files you will edit.
    Copy this list in its entirety, including the [ ].
    Replace the existing list in lib/assets/getMetar.py on line 39 with this list.
    Replace the existing list in app/controllers/lake_effect_snow_events_controller.rb on line 9 with this list.
    Replace the existing list in app/views/lake_effect_snow_events/show.html.erb on line 52 with this list.

    Follow the same rules as the BUFKIT instructions when adding or removing sites, and refreshing the page.

Surface Observation DB + Links:
    First, collect all desired site IDs (5 digit identifier number)
    Then, collect all desired WFO abbrevations in the SAME ORDER
    Type out all the sites in the format of ["XXXXX", "XXXXX", ...].
    Type out all the WFO abbrevations in the format of ["CLE", "BUF", "DTX", ...]
    Please pay attention to the order in which you typed those sites as the order must remain the same across all files you will edit.
    Copy the site ID list in its entirety, including the [ ].
    Replace the existing list in lib/assets/getRealObs.py on line 14 with this list.
    Replace the existing list in app/controllers/lake_effect_snow_events_controller.rb on line 13 with this list.
    Cope the WFO Abbrevation list  in its entirety, including the [ ].
    Replace the existing list in app/views/lake_effect_snow_events/show.html.erb on line 41 with this list.

    Following the same rules as BUFKIT and METAR instructions, when adding or removing sites, and refreshing the page.
    This section of the guide will work for both the data collection aspect and the surface observation links that are autogenerated per event.

Non-Surface Observation Archive Links
    Replace the existing WFO identifier in app/controllers/lake_effect_snow_events_controller.rb on line 17 with your WFO code.

    Again, refreshing the page when changing the WFO code will be required for changes to take affect.
    


# Duet: connecting out-of-state undergrads through music.

## Product description (20%)
People need to make connections, meet others through music tastes.

Priorities:
1. See music others enjoy
2. Protect private information until both opt in to share it (DM lock, private info, location)
3. Propose matches immediately, and give better matches over time (with usage)

In order to accomplish this, we'll start with a Webapp and port it to a mobile app. Using `flutter` can allow us to develop for both.

Our users need to
#### P0
* Link their Spotify Account, give API access
* Feed of profiles (every user has a profile), shown by compatibility. Be able to mark profiles as positive, neutral, negative. This leads into direct messaging after mutual interaction.
* Must have user profile; main page with profiles; matching, DM; concerts near me
* Matching algorithm: music distribution, total songs listened to, algo work
* Must have a personalizable bio on profile
* Conversations page, same as any messaging app
* reporting, blocking feature

#### P1
* Show the two user group size; show them *why* they were connected (overlap in music listening)
* Users could also create taste profile if not much spotify data: list their top 10 current favorite songs, genre (todo, this changes often for some people?). Sometimes listen to a meditation before bed, but do not want to inform my profile. Emphasize this is for fun, not commited one way door.
* L/R swipe for "what are you in the mood for right now?", reprompt every now and then "what are you listening to --> what do you want to represent you". Goes through top k (15) weighted songs, user swipes to decide what informs their profile.
* Icebreakers, "a song I would play at X" prompts; both users have those shown in profiles. Start convo by **replying** to those prompts, starts the conversation.
* Let users decide what they want to look for: similar music, different music, preferred/minimum filters, location, timezone/message reply history; user-led filtering

#### P2
* expand to Apple Music, Soundcloud if have time / need more predictive signal
* Concert feature, go as a group, users that go to a concert are placed to group chat to coordinate before/after (attend/not going as a FB event)
* concert groups, divided to ensure small enough size? coordinate by location/preference/other

## Use cases (functional requirements) (30%)
Each team member must come up with and describe at least one use case of your product, following this template:

* Goal
* Actors
* Triggers
* Preconditions
* Postconditions (success scenario)
* List of steps (success scenario)
* Extensions/variations of the success scenario
* Exceptions: failure conditions and scenarios

Use cases should capture the unique features of your product. Do not focus on features common to products, such as logging into a service, or downloading a result file.

Identify which student was the original creator of each use case(s). Team members should review each others use cases for accuracy and quality.

### Eclectic Tastes
Andrey Risukhin
* Goal: match with people who also enjoy the Portal 2 OST, Minecraft OST, and instrumental accordion music
* Actors: Seeker, system, matchee.
* Triggers: Seeker installs the app, opens it for the first time.
* Preconditions: Matchee exists in the system database.
* Postconditions: 
* Steps
  1. Seeker creates their profile, selecting the songs (which **may not be auto-suggested**) that they want to seek for.
  2. System takes their preferences, returns matched candidates shown one at a time.
  3. Seeker annotates the profiles shown as (+), (0), (-): want to connect, maybe next time, never want to see again.
  4. System alerts each profile with (+) that they have been (+)'d be Seeker.
  5. Matchee recieves this alert in their notifications tab, clicks on it to open the Seeker's profile.
       5.0.1 System marks this notification as "read" but does not delete.
     5.1.1 Matchee marks Seeker as (+)
     5.1.2 System opens a DM betweek Matchee and Seeker
* Variations
  5.2.1 Matchee marks Seeker as (0)
  5.2.2 System closes the Seeker profile, some internal change on ranking to show later
  5.3.1 Matchee marks Seeker as (-)
  5.3.2 System never shows this profile again
* Exceptions

## Non-functional requirements (10%)
Describe at least three non-functional requirements of your product, e.g., related to scalability, usability, security and privacy, etc.

* Login/authentication system
* secure messaging APIs, ex: Signal protocol
* Terms of Service (don't get sued)
* Scalability (YouTube music, Soundcloud, Apple Music), 1k UW students (subreddit, snapchat, other social media, post on EdBoard) for good UW experience (incentives to share installs, usage, rewards later (tiebreaker of referrals in match priority))
* Safety (blocking, reporting profiles)
* Usability (crash avoid 9.99% for 1000 ms) = track user sessions; easy to navigate (few buttons), low friction to use

## External requirements (10%)
In addition to the requirements stated above, the course staff imposes the following requirements on your product:

* The product must be robust against errors that can reasonably be expected to occur, such as invalid user input.
*   disallow repeat usernames
*   flagging offensive stuff
* The product must be installable by a user, or if the product is a web-based service, the server must have a public URL that others can use to access it. If the product is a stand-alone application, you are expected to provide a reasonable means for others to easily download, install, and run it.
*   Flutter handles public URL, 
* The software (all parts, including clients and servers) should be buildable from source by others. If your project is a web-based server, you will need to provide instructions for someone else setting up a new server. Your system should be well documented to enable new developers to make enhancements.
*   Documentation
* The scope of the project must match the resources (number of team members) assigned.
*   We get frequent feedback from TAs on this, use scrum to track feasibility

## Team info (10%)
Provide a concise summary of the project team and project artifacts. Specifically:

### Identify each team member and high level role.
#### Jobs to be done:
* Store data from Spotify API, other sources. Create matches between profiles using that data. Collect usage data per-user. Use that to inform algorithm feedback.
* User DMs

#### Roles!
* Belem - Frontend
* Selim - Backend
* Andrey - Data, Algorithms, probably Spotify API; begs for resources
* Keegan - Frontend
* Jacob - Backend
* Ramon - Messaging, DMs, notifications; scrum manager


### Link to each project relevant artifact such as your git repo.
* All artifacts on our git repository: ```https://github.com/karlabelem/DUET```

### List communication channels/tools, expectations, and meeting plans that will keep your team in sync.
* Communicate via Discord
* If need response, ping. If pinged, respond within 24 hours (sooner better! :)
* Two synchronous meeting slots per week: Tuesday class, Friday 2:30pm - 3:30pm

## Team process description (20%)
Describe your quarter-long development process.

Specify and justify the software toolset you will use.
Define and justify each team member’s current role: why does your team need this role filled, and why is a specific team member suited for this role? (We understand that roles may/will change over time.)
Provide a preliminary schedule for your project with at least four concrete milestones and deadlines for the quarter. Consider a plan for each major area, and when they’ll integrate. While we expect you to work in an agile fashion, given our short quarter, identifying some milestones (including the features that they’ll light up) is a good way to make sure you’re on track for your delivery.
Specify and explain at least three major risks that could prevent you from completing your project, and what is your mitigation plan.
Describe at what point in your process external feedback (i.e., feedback from customers outside your project team, including the project manager) will be most useful and how you will get that feedback.
Export a PDF snapshot of your document named [project name]_m2.pdf and submit it to Canvas.

Schedule
* Week 4 (P0) - profile creation, store profiles, save/load profiles, link user account, store their spotify data in DB.
* Week 5 (P0) - roughly finalized conversations page, mostly done profile feed/recommendations UI and Algorithm. Login screen for frontend. Block profiles. Try with friends.
* Week 6 (P1) - icebreakers, top k songs, reasoning for matches shown to users (interpretability). Filtering preferences for searching.
* Week 7 (P1) - rest of P1. Try with friends. 
* Week 8 (P2) - 
* Week 9 (P2) - 

Major Risks
1. Single point of failure / tribal knowledge, someone gets sick etc. Mitigate by documenting code, high level plan, keeping track of work in sprints. Pull Requests required, review by 1 other (check comments are clear etc). 
2. Cost of resources, PR (Andrey) ask for credits and resources from companies
3. Misestimation of work to be done - flexible schedule, we have P1 weeks, P2 weeks that can be extended with P0 as needed.

External Feedback
* Weeks 5, 7 (end of P0, P1 weeks) user feedback; stakeholder feedback each Thursday with Connor (make him use it)

Modules
* Data: Python, some analytics service (Amplitude?), telemetry (alerter)
* Frontend: Flutter (web/app easy, VS Code extension). Typescript.
* Backend: Firebase (db platform through Google, like Azure) 

Process
* Agile, Scrum
* Client meetings on Thursday
* Two weekly standups - use Discord for urgent issues
* Ramon as the Scrum Manager (has experience before)

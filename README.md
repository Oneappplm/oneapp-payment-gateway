## OneApp Payment Gateway

Ruby Version: **3.2.2**
Rails Version: **7.1.5.1**
Bundler version **2.6.2**
Database: **postgres (PostgreSQL) 16.9**

**Setup:**

 1. Install ruby using rbenv
 2. bundle install

**Rake Tasks Setup:**

     - rake db:reset
     - rake db:migrate

**Start Local Server:**

     - rails s

**Task Workflow:**

 1. Create new branch againsts master branch for your task
 2. after done on development, create a PR request
 3. make sure your commits is only 1, if more than one, use rebase squashing method: **git rebase -i HEAD~{number_of_commits}**

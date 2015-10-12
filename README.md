# advertise-banners
A web-application to serve banners for an advertising agency.


The campaign banners are displayed following these formula:

X = number of banners with revenue within that campaign

1. X > 5
  show at most ten of the banners with more revenue within that campaign
2. X > 0
  mix the banners with more revenue within that campaign, and complete with most clicked
3. X == 0
  mix with most clicked banners with random banners

## Install Instruction
  * clone repository
  * Please note that the image files and csv files dont exist on the repo (just some test smaller csv's).
    * Place images files in a folder: [project_folder]/public/images/
    * Place csv files in a folder: [project_folder]/csv/
  * setup the database

    ```
    $ bundle
    $ rake db:migrate
    ```

  * import from csv:

    ```
    $ rails c
    impressions_csv_path = Rails.root.join "csv/impressions_1.csv"
    clicks_csv_path =  Rails.root.join "csv/clicks_1.csv"
    conversions_csv_path = Rails.root.join "csv/conversions_1.csv"
    ImportService.new.import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
    exit
    $ rails s
    ```
    
  * perform request in http://localhost:300/campaigns/
      - here you can see a list of campaigns, with several categories of banners (banners with profit, banners with clicks but no revenue and banners without clicks)


## Documentation

### Models
  * Campaign
    * has many banners
    * fields: id
    * contains several methods that allow to show top banners of that campaign
  * Banner
    * belongs to campaign, and has many Clicks
    * fields: id, campaign_id
    * contains two scopes, for most profitable banners and for most cliked banners.
  * Click
    * belongs to Banner, has many Conversions
    * fields: id, banner_id)
  * Conversion
    * belongs to Click
    * fields: id, click_id, revenue)

### Services
 CSV files contain data of the banners. The top banners of a capaign are calculated based on rules. Processing that data in every resquest is a long process. In order to have small response times, its needed a database component, that will store these information and process it faster.
  * ImportService
    * These class allows system administrator to import to the database data from CSV files.
    * Currently this class is designed to support reading from clicks, conversions and impressions CSV files.
    * location: in app/services/import_service.rb
    * 

### Presenters
  * CampaignPresenter
    * In order to keep the controller clean, its possible to take advantage of the presenters design pattern, and pass some logic to the presenter. As it was required to show banners in a random order, as well as saving in a session the random sequence generator, to avoid saturation. The data structure used was an array, that implements a queue mechanism, using the pop function.
      - You can trigger this line in the method show of the campaigns controller to see the sequence changing:

```
    #puts "banners_queue:#{session[:banners_queue]}"
```

## Tests
Please run the tests in you computer using the following command:

```
    rspec
```

### Classes
  * ImportServiceSpecHelper
    * Allows for the ImportService to have a clean code. Implemented in order to learn more ruby :)
    * grabs from the csv file, and gets a set all campaigns existent and other set with banners, clicks, conversions. It opens the files several times, but its just for more reusable code. Test files are small, so it was a tradeoff decision.

### Tests to Import service
  * Size of campaigns in database should be equal to all campaigns in csv files (create a set with all read campaigns)
  * Query campaigns in database with all campaign ids in csv files and the query's results size should be equal to the size set read from the CSV files. These guarantees that all ids were imported correctly.
  * Size of banners in database should be equal to all banners in csv files (create a set with all read banners)
  * Size of clicks should be equal to number of rows
  * Size of impressions should be equal to number of rows
  * If admin runs the service import twice, database should not duplicate values.

### Tests show banners
  * CampaignSpecHelper
    * Implements some logic recurring to arrays, in order to validate the source code developed recorring to active record scopes. 
  * Campaign Model spec
    * location: spec/models/campaign_spec.rb. 
    * These file tests the model Campaign in the following combinations:
      * campaign with three types of banners
      * campaign with 12 profitable banners, plus one banner clicked without revenue and one banner not clicked
      * campaign with 7 profitable banners, plus five banner clicked without revenue and one banner not clicked
      * campaign with 4 profitable banners, plus 10 banners clicked without revenue and one banner not clicked
      * campaign with 4 banners clicked without revenue and 10 banners not clicked
      * campaign with 20 banners not clicked
      
  * Campaign show test
    * The file uses capybara to test the sequence of top banners shown to the user. The test consists in grabbing a campaign instance with 10 top banners, and when the user does 10 times the request, the banner must not repeat in that sequence.
    * location /spec/views/campaigns/show.html.erb_spec.rb



# advertise-banners
A web-application to serve banners for an advertising agency.


Using the github issue system to create the stories that abstracted from the task specification.

## Install Instruction
  * clone repository
  * setup the database
    ```
    $ rake db:migrate
    ```
  * import from csv:
    ```
    $ rails c
    ImportService.new.import(impressions_csv_path,clicks_csv_path,conversions_csv_path)
    exit
    $ rails s
    ```
    * A sample path is using the sample test cases (not that this files are smaller than the files provided)
        - impressions_csv_path = Rails.root.join "spec/csv/impressions_1.csv"
        - clicks_csv_path =  Rails.root.join "spec/csv/clicks_1.csv"
        - conversions_csv_path = Rails.root.join "spec/csv/conversions_1.csv"
  * perform request in http://localhost:300/campaigns/7



## Models
  * Campaign
    * has many banners
    * fields: id
  * Banner
    * belongs to campaign, and has many Clicks
    * fields: id, campaign_id
  * Click
    * belongs to Banner, has many Conversions
    * fields: id, banner_id)
  * Conversion
    * belongs to Click
    * fields: id, click_id, revenue)

### Services
  * ImportService
    * These class allows system administrator to import to the database data from CSV files.
    * Currently this class is designed to support reading from clicks, conversions and impressions CSV files.
    * location: in app/services/import_service.rb

## Tests

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


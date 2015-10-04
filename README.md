# advertise-banners
A web-application to serve banners for an advertising agency.

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
  * ImportService
    * These class allows system administrator to import to the database data from CSV files.
    * Currently this class is designed to support reading from clicks, conversions and impressions CSV files.
    * location: in app/services/import_service.rb

### Presenters
  * CampaignPresenter
    * In order to keep the controller clean, its possible to take advantage of the presenters design pattern, and pass some logic to the presenter. As it was required to show a random order of objects, here that order is done, as well as saving in a session the random sequence generator, to avoid saturation. The data structure used was an array, that implements a queue mechanism, using the pop function.
      - You can trigger this line in the method show of the campaigns controller to see the sequence changing:

```
    #puts "banners_queue:#{session[:banners_queue]}"
```

## Tests
Please run the tests in you computer

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
  * test of the function to show banners in several combinations. Please refer to file spec/models/campaign_spec.rb to more information. Note that there is a module campaign_spec_helper, that implements some logic recurring to arrays, in order to validate the code developed with scopes.



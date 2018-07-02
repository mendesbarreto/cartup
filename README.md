![](logo/cartup_logo.png)
# Cartup

**Cartup** is the easiest way to share prebuilt [Carthage](https://github.com/Carthage/Carthage)
frameworks between projects.

The main propose of this gem is uploading the [Carthage](https://github.com/Carthage/Carthage)
prebuilt frameworks to a cloud storage like google drive, onedrive, dropbox or google cloud.
To know more how to make pre-builds with Carthage please follow the
[link about how to do it](https://github.com/Carthage/Carthage#archive-prebuilt-frameworks-into-one-zip-file).


Currently, the main reason why Cartup exists is because only github projects could
upload and distribute prebuilt frameworks automatically, by using the great github
tool called ["RELEASES"](https://help.github.com/articles/creating-releases/).
But when you work using Bitbucket like I do (not by choice), the whole process must
be done manually: you must upload the prebuilt framework on some sort of cloud
storage, manage its version using a JSON file and upload it manually.

And because of that, the gem was born! To people like me, who are a bit lazy and
do not like doing manual job, this is for them!

**So, in a headline: Our gem wants to make the distribution process of
prebuild carthage binaries easier through the most popular storage clouds.**

*One big thanks to my friend and brother [Rafael Ferreira](https://github.com/RafaelPlantard)
who made the initial script. That's what gave me the idea to bring it to a ruby
plugin and distribute it to everybody with RubyGem!*

## Supported Storage Clouds
* [Firebase Cloud Storage](https://firebase.google.com/docs/storage/?gclid=Cj0KCQiAzfrTBRC_ARIsAJ5ps0uB9qOHR9kDhzlqReNfQlhrRJH7gWwHRCbl-XQRIJEvt9jN6ROPdxQaAohIEALw_wcB)
* [S3 Amazon](https://aws.amazon.com/s3/?sc_channel=PS&sc_campaign=acquisition_BR&sc_publisher=google&sc_medium=english_s3_b&sc_content=s3_e&sc_detail=s3%20amazon&sc_category=s3&sc_segment=89108864308&sc_matchtype=e&sc_country=BR&s_kwcid=AL!4422!3!89108864308!e!!g!!s3%20amazon&ef_id=WrKALgAABG2ITkaZ:20180321155422:s)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cartup'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cartup

## Usage

### GemFile

Add the follow step on GemFile:

```rb
gem 'google-cloud-storage', '~> 1.9'
gem 'aws-sdk-s3', '~> 1.8'
```

### Setup with yaml

The first thing is to setup the yaml file in your project.
Create a file named ```cart_uploader.yaml```.
Inside of this file, insert:

```yaml
project:
  framework:
    version: "1.0.0"
    name: "Cartup"
  google:
    project_id: "<Insert here Google project ID>"
    credentials_file: "<Insert here The path to credential file that you download from firebase>"
    bucket: "<Insert here the name of destination bucket on google cloud>"
  s3:
    region: "<Insert Region Name where you bucket is located"
    bucket_name: "<The nam of you bucket>"
    bucket_access_key: '<Your access key>'
    bucket_secret_key: '<Your secret key>'
```
### Upload a binary

After you have created the ````yaml```` file and set it up, you are ready to send
the prebuilt framework to some cloud storage.

**Before you run the upload command, make sure you have already passed through the following steps:**
* Generated the build with carthage with ```carthage build --no-skip-current```
* Archived the framework with carthage with the command ```carthage archive <YourFrameworkName>```

*If you have any doubts about how to generate prebuilt frameworks, [click here to see more information](https://github.com/Carthage/Carthage#archive-prebuilt-frameworks-into-one-zip-file))*

Now everything is alright, just run the following command:  

if you are running with bundler:
```
bundle exec cartup run
```

if you are running without bundler:
```
cartup run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem into your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`. This will create a git tag for the version, push git
commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mendesbarreto/cartup/.
This project is intended to be a safe, welcoming space for collaboration, and contributors
are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cartup project’s codebases, issue trackers, chat rooms
and mailing lists are expected to follow the [code of conduct](https://github.com/mendesbarreto/cartup/blob/master/CODE_OF_CONDUCT.md).

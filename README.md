# Cartup 

![](logo/cartup_logo.png)

**Cartup** is the easyest way to share prebuilts [Carthage](https://github.com/Carthage/Carthage) frameworks between projects.

The main propose of this gem is uploading the [Carthage](https://github.com/Carthage/Carthage) prebuilts frameworks to a cloud 
storage like google drive, onedrive, dropbox or google cloud. To know more how to make prebuilts with Carthage please follow 
the [link about how to do it](https://github.com/Carthage/Carthage#archive-prebuilt-frameworks-into-one-zip-file) 


Currently, the main reason is because only github projects could upload a prebuilts frameworks and distrubuite
them using a great github tool called ["RELEASES"](https://help.github.com/articles/creating-releases/) automatically. 
To people like me who works using Bitbucket (not because of my choice) the all process should be done manually. So you should
upload the prebuilts frameworks on some sort of cloud storage and manage the version using a JSON file and upload 
manually and because that the gem was born! To the people like me who are a bit lazy and do not like to do manual job, 
this is for you!!! 

**So, in a head line: Our gem wants to make the process of distribution of prebuild carthage binaries easier through the 
most populars storage clouds.**

*One big thanks for my friend and brother [Rafael Ferreira](https://github.com/RafaelPlantard) that made the initial
script and that's give me idea to bring it to a ruby plugin and distribute to every body by RubyGem!* 

## Supported Storage Clouds
* [Firebase Cloud Storage](https://firebase.google.com/docs/storage/?gclid=Cj0KCQiAzfrTBRC_ARIsAJ5ps0uB9qOHR9kDhzlqReNfQlhrRJH7gWwHRCbl-XQRIJEvt9jN6ROPdxQaAohIEALw_wcB)

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

### Setup with yaml

The first thing is setup the yaml file in or project. 
Create a file name called ```cart_uploader.yaml``` inside of this file insert:

```yaml
project:
  framework:
    version: "1.0.0"
    name: "Cartup"
  google:
    project_id: "<Insert here Google project ID>"
    credentials_file: "<Insert here The path to credential file that you download from firebase>"
    bucket: "<Insert here the name of destination bucket on google cloud>"
```
### Upload a binary

After you have created the ````yaml```` file and setup it, you are ready to send the prebuilt frame
some cloud storage.

**Before you could run the upload command make you already make the follow steps:** 
* Generated the build with carthage like ```carthage build --no-skip-current```
* Archived the framework with carthage with the command ```carthage archive <YourFrameworkName>```

*If you hae any doubts about how to generate prebuilts framework [click here to see more information](https://github.com/Carthage/Carthage#archive-prebuilt-frameworks-into-one-zip-file))*

Now everything is alright jus run the follow command:  

if you are running with bundler:
```
bundle exec cartup run
```

if you are running without bundler:
```
cartup run
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mendesbarreto/cartup/. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Cartup project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mendesbarreto/cartup/blob/master/CODE_OF_CONDUCT.md).

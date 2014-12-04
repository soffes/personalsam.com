# Personal Sam

This is my daily-ish video journal about with rambling about what I'm working on, doing day to day, etc. It's more for archival purposes than anything.

## Running

You'll need to set the `VIMEO_ACCESS_TOKEN` environment variable. A Pro Vimeo account is required to get API access to file URLs. Then you can simply:

    $ bundle install
    $ bundle exec foreman start

Now the app is running at <http://localhost:5000>.

## Management

Right now, I upload everything to Vimeo, setup all of the meta data on Vimeo, and the use Rails console to add the episode:

```ruby
Episode.create_with_vimeo_id(113409682)
```

That's it. Eventually, I'd like to automate the whole process and even upload from a Mac app or something so I don't have to use the Vimeo website. For now though, it's totally fine.

Do whatever you want with this code. Enjoy.

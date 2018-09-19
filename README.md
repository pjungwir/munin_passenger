This is a collection of [munin](http://munin-monitoring.org/) plugins for [Phusion Passenger](https://www.phusionpassenger.com/).

They give you graphs for things like:

- How many requests are waiting in the queue for a worker.
- How many requests each worker is currently handling.
- How much RAM each Passenger worker is using.
- How much CPU each Passenger worker is using.
- How many cumulative requests have been processed by each worker.
- How long each worker has been alive.
- How long each worker has been idle.

The plugins are written in Ruby and packaged as a gem,
because if you're running Passenger, presumably you are comfortable with Ruby and its ecosystem.
To install them, first install the gem, then add symlinks to your munin `plugins` directory as desired.
You can run this to symlink all the plugins automatically:

```
munin_passenger-install /etc/munin/plugins
```

(Actually `/etc/munin/plugins` if the default, so you can leave it off if you like.)

You should also configure the plugins by adding a file at `/etc/munin/plugin-conf.d/passenger` with these contents:

```
[passenger_*]
user root
env.PASSENGER_ROOT /usr/sbin
```

The `user root` line is necessary because otherwise `passenger-status` will refuse to run.
The second line should be whatever directory contains `passenger-status`.

Once installed, you will get graphs for most of the things `passenger-status` can tell you.

# TODO

- Distinguish between different groups/supergroups, perhaps by having plugins like `passenger_ram_` etc.
  so you can get them in separate graphs.

- Suppress the "helpful" `passenger-status` message about `xmllint` so it doesn't clutter the munin log,
  without suppressing all the rest of stderr.

# Development

You can run tests by saying `rspec spec`.

You can build a local copy of the gem by saying `rake build`, and install it with `rake install`.

After running `rake build`
you can run `vagrant up` to build a machine running Passenger against a dummy Rails app,
with this munin plugin included.
It will install the most recent `*.gem` file in `pkg`.
Then you can do to http://192.168.60.10:7778/ to see the graphs.

You can run `scripts/make-bins.rb` to regenerate the files in `bin`.

You can run `scripts/load-test.sh` to simulate load on the app.
While that is running, do `scripts/capture-passenger-status.sh` to get some realish XML you can use as a test fixture or example.

If you have it installed, you can use `xmllint --format -` and `xmllint --noblanks -` to make Passenger's XML readable vs compact.

You can release a new version of the gem with `rake release`.

# Copyright

Copyright (c) 2018 by Paul A. Jungwirth.
See LICENSE.txt for further details.

# fluent-plugin-buffer-pullpool

[Fluentd](http://fluentd.org) file buffer plugin to store events until output plugin's pull actions.

**NOTICE:** PullPool buffer plugin works just as same as normal file buffer plugin for normal buffered/time-sliced output plugins. Use this plugin with output plugins written to use this plugin.

## Installation

Do `gem install fluent-plugin-buffer-pullpool` or `fluent-gem ...`.

## Configuration

PullPool buffer plugin has options just same with File buffer plugin. `buffer_path` option must be specified.

```
<match data.**>
  type buffered_plugin_to_use_pullpool
  
  buffer_type pullpool
  buffer_path /home/myuser/tmp/pullbuffer
  buffer_chunk_limit 256M
  buffer_queue_limit 256
</match>
```

Specifing short time for `flush_interval` makes a lot of chunk files.

## TODO

* patches welcome!

## Copyright

* Copyright (c) 2014- TAGOMORI Satoshi (tagomoris)
* License
  * Apache License, Version 2.0

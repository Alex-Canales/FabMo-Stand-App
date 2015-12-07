# FabMo-Stand-App

This app generates the GCode used to create a stand device (for phone, etc).
The goal of this app is to prove that it can be easy to create an app for
Shopbot's FabMo, even by using an other language than JavaScript (if this
language is compiled/translated into JavaScript at the end).

This app is written in Haxe.

## Description of the app functionality

TODO (after finishing "design")

## Description of the code

The code is written in Haxe. It was written to use a lot of functionalities that
are not implemented in JavaScript. Therefore this code is an "enterprise
version" app: it is more complicated and uses more functionalities that it
should (inheritance, accessors, interface...). Though the code is still readable
and documented.

### Communication with FabMo

#### General explanation for every apps

To communicate with FabMo, the app must use ``dashboard.js``. This file
generates an object called ``fabmoDashboard`` (which is an instance of
``FabMoDashboard``). ``fabmoDashboard`` contains functions for communicating
with FabMo, which will communicate to the tool.

In this app, we use the function ``submitJob``. This function sends data to
FabMo: the data we send here are GCode commands. FabMo will generate a file from
the sent GCode that can be executed by the tool through the "Job manager".

#### Explanation specific for Haxe

Haxe can communicate with JavaScript by using [extern
class](http://old.haxe.org/doc/js/extern_libraries) (see link). A class in Haxe
must start with capital case. ``fabmoDashboard`` does not start with capital
case so we need to wrap it with an other JavaScript object.

For that, we wrote job.js:

    var Job = {};
    Job.submitJob = function(data, config, callback) {
        fabmoDashboard.submitJob(data, config, callback);
    };

This object is just a wrapper. Then, we can make a class for the object. This
class is in Job.hx:

    extern class Job
    {
        public static function submitJob(data:String, config:Dynamic,
                ?callback:Dynamic):Void;
    }

We are not specialised in Haxe and maybe a more simple solution exists.

At the end, the class Job is used by other classes in Haxe to communicate with
FabMo (see state/Final.hx).

ASGConsole
==========

Description
------------
ASGConsole provides a user friendly manage console for the AWS AutoScaling Service, which AWS don't have currently.
Basic function includes Display/Create/Delete/Edit Launch Configuration Group, AutoScaling Group and Scaling Policy 
Group. Advanced funciton is you can remotely enter command to the instances in AutoScaling Group, and it support to do 
this to multiple instances at the same time. 

Start using it
----------
Since it's a webapp, just launch it to some server that you like, e.g. Tomcat. Then run it on some browser. If you want 
use the Remote Command function, you must make sure your instances have some private key associated, and also on the 
webpage, you need to provide the exact filepath of the private key file(.pem), as I has tested, on Mac OS and Windows
you can provide the whole filepath, on the AWS Linux Instance it seems not work, but you can put the .pem file into the 
server directory, and instead of the whole filepath, you can just enter the file name of it.

A bug
----------
One big problem is on the command enter page, you have to provide the correct username, private key path, otherwise 
the server would crash, and then you need to start the server again.

Some notes
-------
1. On the Log in page, you have to enter the corret AWS Access key and Security key, otherwise it would load into some 
default error page, I don't provide some check function.
2. The session time is 30 mins, so if you don't do anything during the 30 mins, you would be logged out and need to log 
in again. 
3. Once create a new AutoScaling Group, some related instances need several secs or mins to launch, so don't worry if 
you don't see anything changed in the instance list, just refresh the page after some time. 
4. If you want to delete some Launch Configuration Group, make sure no AutoScaling Group are using it, also if you want
delete some AutoScaling Group, make sure no instances are related to it.

Screen shots
---------
Just see the <a href="https://docs.google.com/file/d/0B4HuB0nTzQgpS0wxTlRtVC1Gelk/edit?usp=sharing">ASGConsole Screenshots</a>

Contact me
-------------
If you have some questions, or want to give some advice, which I appreicated, just feel free to contact me.
Email: xiaoma318@yahoo.com


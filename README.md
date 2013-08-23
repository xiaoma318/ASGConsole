ASGConsole
==========

Description
------------
ASGConsole provides a user friendly manage console for the AWS AutoScaling Service, which AWS don't have currently.
Basic function includes Display/Create/Delete/Edit Launch Configuration Group, AutoScaling Group and Scaling Policy 
Group. Advanced funciton is you can remotely enter command to the instances in AutoScaling Group, and it support to do 
this to multiple instances at the same time. Besides, it also include log funciton, you can check the logs under ASGLog
directory. 

Start using it
----------
Since it's a webapp, just launch it to some server that you like, e.g. Tomcat. Then run it on some browser. If you want 
use the Remote Command function, you must make sure your instances have some private key associated, and also on the 
webpage, you need to provide the exact filepath of the private key file(.pem), as I has tested, on Mac OS and Windows
you can provide the whole filepath, on the AWS Linux Instance it seems not work, but you can put the .pem file into the 
server directory, and instead of the whole filepath, you can just enter the file name of it.
<br>Here's a guide video for it.http://www.youtube.com/watch?v=Vfx8XIMrVIM&feature=em-upload_owner

Some notes
-------

1. The session time is 30 mins, so if you don't do anything during the 30 mins, you would be logged out and need to log 
in again. 
2. Once create a new AutoScaling Group, some related instances need several secs or mins to launch, so don't worry if 
you don't see anything changed in the instance list, just refresh the page after some time. 

Screen shots
---------
Just see the <a href="https://docs.google.com/file/d/0B4HuB0nTzQgpS0wxTlRtVC1Gelk/edit?usp=sharing">ASGConsole Screenshots</a>

Contact me
-------------
If you have some questions, or want to give some advice, which I'd be really appreicated, just feel free to contact me.
<br>Email: xiaoma318@yahoo.com


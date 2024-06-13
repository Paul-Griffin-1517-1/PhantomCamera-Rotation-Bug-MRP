# PhantomCamera regression

The main branch includes the latest version of PhantomCamera (0.7.2) where the issue is present, the alternate branch includes v0.7.0.6 (confirmed to work).
Between these releases, the player spawn setup recreated in this project has ceased working. I believe it is ultimately based on some change to how nodes are initialized (or something like that), but the end result is that setting the PhantomCamera's rotation when adding the scene breaks the transformations of the camera.

Unrelated to that bug is https://github.com/ramokz/phantom-camera/issues/326, which is reproducible within this project in both branches by setting tweening to 0 or disabling tween on startup.

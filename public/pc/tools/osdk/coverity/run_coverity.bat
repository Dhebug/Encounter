::
:: curl --form token=BSIgdxm4bkjzZiSOsAHaAA \
::  --form email=mike@defence-force.org \
::  --form file=@tarball/file/location \
::  --form version="Version" \
::  --form description="Description" \
::  https://scan.coverity.com/builds?project=OSDK
::

set path=D:\svn\public\pc\tools\osdk\coverity\cov-analysis-win64-7.7.0.4\bin;%path%
cov-build --dir cov-int run_visualstudio_build.bat

pause

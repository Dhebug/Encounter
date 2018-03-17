pushd D:\svn\public\pc\tools\osdk\main
call "%VS110COMNTOOLS%\vsvars32.bat"
devenv /build "Release|Win32" osdk-vsnet.sln 
popd

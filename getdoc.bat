@echo off
set pythonPath=c:\Python27
set mongoPath=c:\mongodb\bin\mongod.exe
set mongoDbPath=c:\mongodb\data\db
set elasticSearchPath=c:\elasticsearch-0.19.9\bin\elasticsearch.bat
set appPath=c:\gsapi
set docFolder=%appPath%\doc
set confFolder=%docFolder%\conf
set testsFolder=%appPath%\gsapi\tests
set mainApiFile=%docFolder%\api.rst

REM cleanup the existing files and directories
del /S *.pyc
rmdir /s /q "%docFolder%\_build\html"
rmdir /s /q "%docFolder%\_build"
rmdir /s /q "%docFolder%\_static"
rmdir /s /q "%docFolder%\_templates"
del "%docFolder%\Makefile"
del "%docFolder%\make.bat"
del "%docFolder%\*.rst"


REM copy the configuration file to doc root folder
cp %confFolder%\conf.py.orig %docFolder%\conf.py
cp %confFolder%\index.rst.orig %docFolder%\index.rst
cp %confFolder%\intro.rst.orig %docFolder%\intro.rst

REM get api doc
"%pythonPath%\Scripts\sphinx-apidoc.exe" -F -o %docFolder% gsapi

REM create the main Api file
echo .. include:: intro.rst >> %mainApiFile%
echo .. toctree:: >> %mainApiFile%
echo     :maxdepth: 2 >> %mainApiFile%
echo. >> %mainApiFile%
FOR /f %%a in ('DIR %testsFolder%\*.py /B /A:-D') do ( IF NOT "%%a" == "__init__.py" (echo     %%a >> %mainApiFile%))

REM run tests and append the rest of .rst files to the mainApiFile
 FOR /f %%a in ('DIR %testsFolder%\*.py /B /A:-D') do ( IF NOT "%%a" == "__init__.py" (nosetests -v --nocapture %testsFolder%\%%a >> %docFolder%\%%a.rst))

REM build the docs
"%pythonPath%\Scripts\sphinx-build.exe" -b html "%docFolder%" "%docFolder%\_build\html"

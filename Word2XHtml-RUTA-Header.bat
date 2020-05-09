TITLE HTML CONVERSION - EPUB3 - Version1

COLOR a
@echo off
cls
@echo Start time: %time%
set STARTTIME=%TIME%

XCOPY /Y \\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\02-Remove-xmlns.xslt
REN *.xml *.sgml
REM set CP=\\10.1.1.100\Automation\Saxon\saxon9.jar;
set CP=\\C:\Saxon\saxon-he-9.3.0.5.jar;
CLS



for /R %%b IN (*.docx) DO (
 TITLE HTML CONVERSION - EPUB3: %%~nb.docx
 set filename="%%~nb"
 echo File: %%~nb
REM  start "" "\\10.1.1.100\Automation\WORD2XML\JoinTags\1.0.5\JoinTags.exe" "%CD%"
 "\\10.1.1.100\Automation\Perl\bin\perl.exe" "\\10.1.1.100\automation\WORD2XML\Word2HTML5-EPUB\00-UNZIP.pl" "%%b"
pause

 cls
)
echo unzip
TIMEOUT /T 3
for /R %%f IN (*.xml) DO (


java -cp %CP% net.sf.saxon.Transform -t -o:"%%~nf-out2.xml" "%%~nf.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\01-W2H-Header.xslt"
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out2.xml" "%%~nf.xml" "01-W2H-Prasanth.xslt"
echo MAIN
pause
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out3.xml" "%%~nf-out2.xml" "02-Remove-xmlns.xslt" 

echo chkkkkkkkkkkkkkkkkk
pause
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out4.xml" "%%~nf-out3.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\1-LIST.xslt"
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out5.xml" "%%~nf-out4.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\2-LIST.xslt"
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\3-LIST.xslt"
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\35-LIST.xslt"
REM java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\4-LIST.xslt"

java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out4.xml" "%%~nf-out3.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\1-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out5.xml" "%%~nf-out4.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\2-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\3-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\35-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\4-LIST.xslt"
cls
echo list converted
pause

java -cp %CP% net.sf.saxon.Transform -o:"%%~nf.xhtml" "%%~nf-out8.xml" "\\10.1.1.100\automation\WORD2XML\W2HTMLsanthanam\03-Final-Ruta.xslt"



echo completed
pause

 del %%~nf.xml
 del %%~nf-out2.xml
del %%~nf-out3.xml
del %%~nf-out4.xml
del %%~nf-out5.xml
del %%~nf-out6.xml
del %%~nf-out7.xml
del %%~nf-out8.xml

echo minus 5seconds

REM pause

)
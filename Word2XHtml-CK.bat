TITLE HTML CONVERSION - EPUB3 - Version1

COLOR a
@echo off
cls
@echo Start time: %time%
set STARTTIME=%TIME%

XCOPY /Y \\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\02-Remove-xmlns.xslt
REN *.xml *.sgml
rem set CP=C:\Saxon\saxon-he-9.3.0.5.jar;
rem set CP=\\D:\Saxon\saxon-he-9.3.0.5.jar;
set CP=\\C:\Saxon\saxon-he-9.3.0.5.jar;
rem CLS



for /R %%b IN (*.docx) DO (
 TITLE HTML CONVERSION - EPUB3: %%~nb.docx
 set filename="%%~nb"
 echo File: %%~nb
 REM start "" "\\10.1.1.100\Automation\WORD2XML\JoinTags\1.0.5\JoinTags.exe" "%CD%"
 rem "\\10.1.1.100\Automation\Perl\bin\perl.exe" "\\10.1.1.100\automation\WORD2XML\Word2HTML5-EPUB\00-UNZIP.pl" "%%b"
 "C:\Perl\bin\perl.exe" "00-UNZIP.pl" "%%b"
echo
echo hai
pause
)



TIMEOUT /T 3
for /R %%f IN (*.xml) DO (
rem java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out2.xml" "%%~nf.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\Bookmark.xslt"
java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out2.xml" "%%~nf.xml" "Bookmark.xslt"
rem cls
echo 11111111111
rem pause

 java -cp %CP% net.sf.saxon.Transform -t -o:"%%~nf-out222.xml" "%%~nf-out2.xml" "02-Remove-xmlns.xslt"
 rem pause
java -cp %CP% net.sf.saxon.Transform  -t -o:"%%~nf-out3.xml" "%%~nf-out222.xml" "01-W2H-CK.xslt"
echo 01-W2H-CK.xslt
pause
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out4.xml" "%%~nf-out3.xml" "02-Remove-xmlns.xslt" 

java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out5.xml" "%%~nf-out4.xml" "1-LIST.xslt"

rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\2-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out6.xml" "%%~nf-out5.xml" "2-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\3-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out7.xml" "%%~nf-out6.xml" "3-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\35-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out8.xml" "%%~nf-out7.xml" "35-LIST.xslt"
rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out9.xml" "%%~nf-out8.xml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\4-LIST.xslt"
java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-out9.xml" "%%~nf-out8.xml" "4-LIST.xslt"
echo 4-list completed - out8

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ JOIN-ELEMENTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

 java -cp %CP% net.sf.saxon.Transform -t -o:"%%~nf-out10.xml" "%%~nf-out9.xml" "02-Remove-xmlns.xslt"

REM @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ JOIN-ELEMENTS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    java -cp %CP% net.sf.saxon.Transform -o:"%%~nf.xhtml" "%%~nf-out10.xml" "03-Final.xslt"
   rem java -cp %CP% net.sf.saxon.Transform -o:"%%~nf.xhtml" "%%~nf.xhtml" "\\10.1.1.100\automation\WORD2XML\W2HTML-CKeditor\join-elements.xslt"
   java -cp %CP% net.sf.saxon.Transform -o:"%%~nf.xhtml" "%%~nf.xhtml" "join-elements.xslt"
    echo finallllll
    java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-RemoveNameSpace.xml" "%%~nf.xhtml" "01_RemoveNameSpace.xsl"
    echo RemoveNameSpace
    pause
    java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-head1_split_into_scetion.xml" "%%~nf-RemoveNameSpace.xml" "head1_split_into_scetion.xslt"
     echo head1_split_into_scetion
    pause
    java -cp %CP% net.sf.saxon.Transform -o:"%%~nf-Final_Out.xml" "%%~nf-head1_split_into_scetion.xml" "Final_Xml.xslt"
    echo dita files
pause
del %%~nf.xml
del %%~nf-out2.xml
del %%~nf-out3.xml
del %%~nf-out4.xml
del %%~nf-out5.xml
del %%~nf-out6.xml
del %%~nf-out7.xml
del %%~nf-out8.xml
del %%~nf-out9.xml
del %%~nf-out10.xml
del %%~nf-out11.xml
echo minus 5seconds

REM pause

)






#Global Module Declaration...
#use strict;
#use warnings;
use Win32;
use Win32::ODBC;
use File::Basename;
use File::Copy;
use Cwd;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);
# Global Variable Declaration...
my ($filepath, $filename,$dbh) = ("", "","");
my $chapNum;
my $titi;
# Argument Checking...
if(!defined($ARGV[0]) || $ARGV[0] eq "") {
	Win32::MsgBox("Argument not passed!. Specify File Path", MB_ICONSTOP, "DOCX");
	exit;
} else {
	if(!-e "$ARGV[0]") {
		Win32::MsgBox("$ARGV[0] File Not found", MB_ICONSTOP, "DOCX");
		exit;
	} elsif($ARGV[0] !~ m/\.docx$/i) {
		Win32::MsgBox("Input file should be docx only", MB_ICONSTOP, "DOCX");
		exit;
	} else {
		$filepath = dirname($ARGV[0]);
		$filename = basename($ARGV[0]);
		$filename =~ s/\.docx$//i;
		if($filepath =~ m/^\.$/) {
			$filepath = cwd;
		}
  
	}
}
# Document Unpack
my $document = "";
my $inputFile = $ARGV[0];
#my $zip = Archive::Zip->new("$filepath\\$filename.docx");
#my $zip = Archive::Zip->new("$filename.docx");
my $zip = Archive::Zip->new();
if ($zip->read($inputFile) == AZ_OK) {
	  my @members = $zip->memberNames();
  $document = $zip->contents("word/document.xml");
  foreach my $member (@members) {
 	  	if($member =~ m/(word\/(comments|endnotes|fontTable|footer1|footer2|footnotes|header1|header2|numbering|settings|styles|webSettings)\.xml|_rels\/document\.xml\.rels|_rels\/endnotes.xml\.rels|_rels\/footnotes.xml\.rels)/i) {
  	  	my $membercontent = $zip->contents($member);
  	  	$document =~ s/<\/w:document>/$membercontent<\/w:document>/i;
  	  	  my $result = rindex($membercontent, "/");
							$result1 = substr ($membercontent, $result+1);
							$result2 .= "del $result1\n";
  	  	
  	
  	}
  }
}

$document =~ s/<\?xml version=\"1.0\"[^>]*\?>[\r\n]*//sgi;
$document =~ s/<w:document/<\?xml version=\"1\.0\" encoding=\"UTF-8\" standalone=\"yes\"\?>\n<w:document/si;
$document =~ s/Relationships xmlns\=\"http\:\/\/schemas\.openxmlformats\.org\/package\/2006\/relationships\"\>/Relationships\>/si;
#$document =~ s/></>\n</sg;

# XML File Open
open(DOCUMENT, ">$filepath\\$filename.xml") or die Win32::MsgBox("Can't create the documents\.xml : $!", MB_ICONSTOP, "DOCX");
print DOCUMENT $document;
close DOCUMENT;
print BATFL "$result2";
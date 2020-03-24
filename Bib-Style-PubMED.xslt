<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" 
   xmlns:wsp="http://schemas.microsoft.com/office/word/2003/wordml/sp2" xmlns:v="urn:schemas-microsoft-com:vml" 
   xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:sl="http://schemas.microsoft.com/schemaLibrary/2003/core" 
   xmlns:util="java:java.util.UUID" xmlns:uuid="java.util.UUID" xmlns:java="java"
   xmlns:ns="some:ns"
   xmlns:b="http://schemas.openxmlformats.org/officeDocument/2006/bibliography"
   xmlns="http://schemas.openxmlformats.org/officeDocument/2006/bibliography"
  
  exclude-result-prefixes="b"
   version="2.0">
   <xsl:output omit-xml-declaration="no" indent="yes" method="xml"/>
   <xsl:strip-space elements="*"/>
   
   
   
   <xsl:template match="node()|@*">      
      <xsl:copy>
         <xsl:element name="b:{name()}" namespace="">
            <xsl:copy-of select="@*"></xsl:copy-of>
            <xsl:copy-of select="namespace::*" />
            <xsl:apply-templates select="node()" />
         </xsl:element>
      </xsl:copy>      
   </xsl:template>
   
   <ns:WhiteList>
      <name>ArticleTitle</name>
      <name>Title</name>
      <name>Volume</name>
      <name>Issue</name>
      <name>PubDate</name>
      <name>LastName</name>
      <name>Initials</name>
      <name>ArticleDate</name>
   </ns:WhiteList>
   <xsl:template match=
      "*[not(descendant-or-self::*[name()=document('')/*/ns:WhiteList/*])]"/>
   <xsl:template match="*">    
      <xsl:element name="b:{name()}" namespace="http://schemas.openxmlformats.org/officeDocument/2006/bibliography">     
         <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>
   <!--<xsl:template match="*"> 
      <xsl:element name="{concat('b:',name())}" namespace="http://schemas.openxmlformats.org/officeDocument/2006/bibliography">
         <xsl:copy-of select="@*"></xsl:copy-of>
         <xsl:copy-of select="namespace::*" />
         <xsl:apply-templates select="node()" />
      </xsl:element>
   </xsl:template> -->  
   <xsl:template match="root"> 
      <xsl:element name="b:Sources" namespace="http://schemas.openxmlformats.org/officeDocument/2006/bibliography">
      <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>
   
   <xsl:template match="pre">      
      <xsl:text>&#x000A;</xsl:text>    
      <xsl:text disable-output-escaping="yes">&lt;b:Source&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:Source&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
</xsl:template>
   <xsl:template match="Author"> 
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;b:Author&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;b:NameList&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;b:Person&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:Person&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:NameList&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:Author&gt;</xsl:text>
   </xsl:template>
   <xsl:template match="AuthorList">
      <xsl:text>&#x000A;</xsl:text>   
      <xsl:text disable-output-escaping="yes">&lt;b:Author&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&#x000A;</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:Author&gt;</xsl:text>
   </xsl:template>
   <xsl:template match="Journal">
      <xsl:text>&#x000A;</xsl:text>   
      <xsl:text disable-output-escaping="yes">&lt;b:SourceType&gt;</xsl:text>
      <xsl:text>JournalArticle</xsl:text>
      <xsl:text disable-output-escaping="yes">&lt;/b:SourceType&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>  
<!-- Generating Random b:Tag id -->
      <xsl:text disable-output-escaping="yes">&lt;b:Tag&gt;</xsl:text>
         <xsl:value-of select="generate-id()"/>
      <xsl:text disable-output-escaping="yes">&lt;/b:Tag&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>  
                        <!-- Generating GUUD: Refer: http://www.pure-xml.com/cblog/index.php?/archives/8-Generating-UUIDs-with-XSL-and-Java.html -->      
                        <!-- <xsl:value-of select="guid:NewGuid()"/>-->
                        <xsl:text disable-output-escaping="yes">&lt;b:Guid&gt;</xsl:text>
                        <!--<xsl:variable name="uid" select="util:randomUUID()"/>      
                        <xsl:value-of select="$uid"/>-->   
                       <xsl:variable name="uid" select="java:util.UUID.randomUUID()"/>
                        <xsl:value-of select="$uid"/>      
                        <xsl:text disable-output-escaping="yes">&lt;/b:Guid&gt;</xsl:text>
      <xsl:text>&#x000A;</xsl:text>   
      <xsl:apply-templates/>
   </xsl:template>
   <xsl:template match="LastName">
      <xsl:text disable-output-escaping="yes">&lt;b:Last&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text disable-output-escaping="yes">&lt;/b:Last&gt;</xsl:text>
   </xsl:template>
   <xsl:template match="Initials">
      <xsl:text>&#x000A;</xsl:text>   
      <xsl:text disable-output-escaping="yes">&lt;b:First&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text disable-output-escaping="yes">&lt;/b:First&gt;</xsl:text>
   </xsl:template>
   

   <xsl:template match="Article|PubmedArticle|MedlineCitation|JournalIssue|ArticleDate">   
      <xsl:apply-templates/>
</xsl:template>
   
</xsl:stylesheet>

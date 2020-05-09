<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
  xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing"
  xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
  xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"
  xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:v="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:o="http://schemas.openxmlformats.org/drawingml/2006/main"
  xmlns:sw8="http://schemas.openxmlformats.org/package/2006/relationships"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:my-scripts="urn:my-scripts"
  exclude-result-prefixes="#all" version="2.0">
  <!-- xmlns="http://www.w3.org/1999/xhtml"-->
  <!--<xsl:output method="html" use-character-maps="Ascii2Unicode" doctype-system="html"/>-->

  <xsl:output indent="no"/>

  
  <xsl:variable name="filename" select="substring-before(tokenize(base-uri(.), '/')[last()],'.')"/>

   
  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates/>  
    </xsl:copy>
    
  </xsl:template>
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>    
  </xsl:template>
  
 
  
  
  <xsl:template match="w:document">
    
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
      
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('settings.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('fontTable.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('Styles.xml') | document('styles.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('fontTable.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('numbering.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('footnotes.xml')" />
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('endnotes.xml')" /> 
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('comments.xml')" /> 
      <xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('theme1.xml')" /> 
      <xsl:text>&#x000A;</xsl:text>
<!--      <xsl:copy-of select="document('document.xml.rels')//sw8:Relationship"/> -->
      <xsl:apply-templates select="document('document.xml.rels')//sw8:Relationships"/>
    </xsl:copy>
      
      <!--<xsl:copy-of select="document('document.xml')" />-->
      <!--<xsl:text>&#x000A;</xsl:text>
      <xsl:copy-of select="document('settings.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('fontTable.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('Styles.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('fontTable.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('numbering.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('footnotes.xml')" />
      <xsl:text>&#x000A;</xsl:text>
    <xsl:copy-of select="document('endnotes.xml')" /> -->
      
    
  </xsl:template>
  
  <xsl:template match="sw8:Relationships|sw8:Relationship">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates></xsl:apply-templates>
    </xsl:element>
  </xsl:template>
  
  
  
 </xsl:stylesheet>

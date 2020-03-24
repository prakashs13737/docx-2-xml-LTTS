<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mf="http://example.com/mf" exclude-result-prefixes="xs mf" 
    xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
    xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml"
    xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" 
    xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" 
    xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml"
    xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" 
    xmlns:dt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882" xmlns:pic="http://schemas.openxmlformats.org/drawingml/2006/picture"  xmlns:a14="http://schemas.microsoft.com/office/drawing/2010/main">
    
    <xsl:output method="text" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="w:document">
        <xsl:apply-templates select="w:body"/>
    </xsl:template>
    
    <xsl:template match="w:body">
        <xsl:apply-templates select="//w:p"/>
    </xsl:template>
    
    <xsl:template match="w:p">
        <xsl:variable name="self" select="self::w:p"/>
        <xsl:apply-templates select="descendant::w:r[ancestor::w:p[1] = $self]"/>
        <xsl:text>&#x000A;</xsl:text>
    </xsl:template>
    
    <xsl:template match="w:r">
        <xsl:variable name="parent" select="ancestor::w:p[1]"/>
        <xsl:apply-templates select="descendant::w:t[ancestor::w:p[1] = $parent]"/>
    </xsl:template>
    
    <xsl:template match="w:t">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
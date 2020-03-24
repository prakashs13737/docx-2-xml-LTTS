<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mf="http://example.com/mf"
    xmlns:bpmn2="http://www.omg.org/spec/BPMN/20100524/MODEL"
    xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI"
    xmlns:dc="http://www.omg.org/spec/DD/20100524/DC"
    xmlns:di="http://www.omg.org/spec/DD/20100524/DI"
   
    exclude-result-prefixes="bpmndi bpmn2 xs mf"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" version="2.0">    
    <!--To Delete the "row_delete" tr and "table_delete" for table and  26-7-2019-->    
    <xsl:output method="xml"/>
    <!--<xsl:strip-space elements="*"/>-->
    <xsl:template match="*">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="@* | node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- template to copy attributes -->
    <xsl:template match="@*">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
    <!-- template to copy the rest of the nodes -->
    <xsl:template match="text()">
        <xsl:copy/>
    </xsl:template>
    
    <!--    <xsl:template match="comment()| processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>-->
</xsl:stylesheet>
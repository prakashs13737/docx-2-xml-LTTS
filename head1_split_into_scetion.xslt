<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsw="http://coko.foundation/xsweet"     
    exclude-result-prefixes="#all">
    
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="@*|node()">        
        <xsl:copy>            
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="//body">
        <xsl:for-each-group select="*" group-starting-with="p[@class = 'Head1'] | p[@class = 'SectionTitle']">
            <xsl:choose>
                <xsl:when test="self::p[@class = 'Head1']">
                    <xsl:apply-templates select="." mode="group"/>
                </xsl:when>
                <xsl:when test="self::p[@class = 'SectionTitle']">
                    <xsl:apply-templates select="." mode="group"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy>
                        <xsl:apply-templates select="current-group()"/>
                    </xsl:copy>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template  match="p[@class = 'Head1'] | p[@class = 'SectionTitle']" mode="group">
        <xsl:element name="section">
            <xsl:attribute name="class">
                <xsl:value-of select="@class"/>
            </xsl:attribute>
            <xsl:for-each-group select="current-group()" group-starting-with="p[@class = 'Head1'] | p[@class = 'SectionTitle']">
                <xsl:apply-templates select="current-group()"/>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:choose>
            <xsl:when test="child::img">
                <xsl:variable name="image_name">
                    <xsl:value-of select="child::img/@src[1]"/>    
                </xsl:variable>
                
                <xsl:element name="fig">
                    <xsl:element name="title">
                        <xsl:choose>
                            <xsl:when test="following::p[@class = 'FigureLegend']">
                                <xsl:value-of select="following::p[@class = 'FigureLegend'][1]/."/>
                            </xsl:when>
                            <xsl:when test="following::p[@class = 'FigureLegend']">                              
                            </xsl:when>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="image">
                        <xsl:attribute name="rev">
                            
                        </xsl:attribute>
                        <xsl:attribute name="href">
                            <xsl:value-of select="substring-after($image_name,'../images/')"/>
                        </xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p">
                    <xsl:attribute name="class">
                        <xsl:value-of select="@class"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:element>        
            </xsl:otherwise>
        </xsl:choose>    
        
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:copy>
            <xsl:element name="title"></xsl:element>
            <xsl:element name="tgroup">
                <xsl:attribute name="align">
                    <xsl:value-of select="'center'"/>
                </xsl:attribute>
                <xsl:attribute name="cols">
                    <xsl:value-of select="colgroup/@cols"/>
                </xsl:attribute>
               <xsl:apply-templates/>
            </xsl:element>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="table/child::colgroup/child::col">
        <xsl:variable name="colCount">
            <xsl:number/>
        </xsl:variable>
            
        <xsl:element name="colspec">
            <xsl:attribute name="colname">
                <xsl:value-of select="concat('col',$colCount)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
   <xsl:template match="tr">
       <xsl:choose>
           <xsl:when test="child::td/p[@class = 'TableColumnHead1']">
               <xsl:element name="thead">
               <xsl:element name="row">
                   <xsl:attribute name="valign">
                       <xsl:value-of select="'middle'"/>
                   </xsl:attribute>
                   <xsl:apply-templates/>            
               </xsl:element>        
               </xsl:element>
           </xsl:when>
           <xsl:otherwise>
               <xsl:element name="row">
                   <xsl:attribute name="valign">
                       <xsl:value-of select="'middle'"/>
                   </xsl:attribute>
                   <xsl:apply-templates/>            
               </xsl:element>
           </xsl:otherwise>
       </xsl:choose>
       
    </xsl:template>
    
     <xsl:template match="td/child::p">
         <xsl:element name="entry">
             <!--<xsl:choose>
                 <xsl:when test="parent::td/contains(@style,'align')">
                     <xsl:attribute name="valign">
                         <xsl:value-of select="'haii'"/>    
                     </xsl:attribute>                     
                 </xsl:when>
             </xsl:choose>-->
             <xsl:apply-templates/> 
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="span">
        <xsl:apply-templates/>
    </xsl:template>
      
    <xsl:template match="td">
      <xsl:apply-templates/>   
    </xsl:template>
    
    <xsl:template match="colgroup">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="td/descendant::img">
        <xsl:element name="fig">
            <xsl:element name="title"></xsl:element>
            <xsl:element name="image">
                <xsl:attribute name="rev">
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:value-of select="substring-after(@src,'../images/')"/>
                </xsl:attribute>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div">
        <xsl:choose>
            <xsl:when test="@data-type = 'textbox'">
                <xsl:element name="p">
                    <xsl:value-of select="normalize-space(.)"/> 
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    
    
    <xsl:template match="head"/>
    <xsl:template match="link"/>
    <xsl:template match="styles"/>
    <xsl:template match="Relationships"/>
    <xsl:template match="hdr"/>
    <xsl:template match="ftr"/>
    <xsl:template match="settings"/>
    <xsl:template match="numbering"/>
    <xsl:template match="fonts"/>
    <xsl:template match="sectPr"/>
    <xsl:template match="@*"/>
    
        
</xsl:stylesheet>
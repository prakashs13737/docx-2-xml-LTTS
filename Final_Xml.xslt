
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  
  exclude-result-prefixes="#all" version="2.0">
   <xsl:strip-space elements="*"/>
   <xsl:output method="xml" indent="yes" omit-xml-declaration="no"/>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="html">
              
         <xsl:for-each select="section">
            <!--<xsl:variable name="head" select="normalize-space(self::section/p[@class = 'Head1'][1])"/>-->
             <xsl:variable name="head1">
                 <xsl:choose>
                     <xsl:when test="self::section/p[@class = 'Head1']">
                         <xsl:value-of select="normalize-space(self::section/p[@class = 'Head1'][1])"/>
                     </xsl:when>
                     <xsl:when test="self::section/p[@class = 'SectionTitle']">
                         <xsl:value-of select="normalize-space(self::section/p[@class = 'SectionTitle'][1])"/>
                     </xsl:when>
                 </xsl:choose>
             </xsl:variable>
             
            <xsl:variable name="taskNumber">
                <xsl:number/>                    
            </xsl:variable>
             <xsl:choose>
                 <xsl:when test="child::p[@class = 'Task']">
                    <xsl:result-document href="{$head1}.dita">
                    <xsl:text>&#x000A;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;?Pub UDT instructions _comment FontColor="red"?&gt;</xsl:text>    
                    <xsl:text>&#x000A;</xsl:text>
                    <xsl:text disable-output-escaping="yes">&lt;task </xsl:text>
                    <xsl:text disable-output-escaping="yes">xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" </xsl:text>
                    <xsl:text disable-output-escaping="yes">base="</xsl:text>
                    <xsl:value-of select="$head1"/>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">id="</xsl:text>
                    <xsl:value-of select="concat('task-',$taskNumber,'-','XXXXX')"/>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">props="</xsl:text>
                    <xsl:value-of select="$head1"/>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">rev="XXX</xsl:text>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">translate="yes</xsl:text>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">xml:lang="en-US</xsl:text>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">xsi:noNamespaceSchemaLocation="urn:ptc:names:arbortext:dita:xsd:techinfo.xsd</xsl:text>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">xtrc="ADJ</xsl:text>
                    <xsl:text disable-output-escaping="yes">" </xsl:text>
                    <xsl:text disable-output-escaping="yes">xtrf="000</xsl:text>
                    <xsl:text disable-output-escaping="yes">"</xsl:text>
                    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                    <xsl:text>&#x000A;</xsl:text><xsl:element name="title">
                        <xsl:value-of select="$head1"/>
                    </xsl:element>
                     <xsl:element name="taskbody">
                    <xsl:element name="context">     
                        <xsl:apply-templates select="node()"/>
                    </xsl:element>
                    </xsl:element><xsl:text>&#x000A;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;/task&gt;</xsl:text>
                </xsl:result-document>
                 </xsl:when>
                 <xsl:otherwise>
                     <xsl:result-document href="{$head1}.dita">
                         <xsl:text>&#x000A;</xsl:text>
                         <xsl:text disable-output-escaping="yes">&lt;?Pub UDT instructions _comment FontColor="red"?&gt;</xsl:text> 
                         <xsl:text>&#x000A;</xsl:text>
                         <xsl:text disable-output-escaping="yes">&lt;concept </xsl:text>
                         <xsl:text disable-output-escaping="yes">xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" </xsl:text>
                         <xsl:text disable-output-escaping="yes">base="</xsl:text>
                         <xsl:value-of select="$head1"/>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">id="</xsl:text>
                         <xsl:value-of select="concat('task-',$taskNumber,'-','XXXXX')"/>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">props="</xsl:text>
                         <xsl:value-of select="$head1"/>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">rev="XXX</xsl:text>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">translate="yes</xsl:text>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">xml:lang="en-US</xsl:text>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">xsi:noNamespaceSchemaLocation="urn:ptc:names:arbortext:dita:xsd:techinfo.xsd</xsl:text>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">xtrc="ADJ</xsl:text>
                         <xsl:text disable-output-escaping="yes">" </xsl:text>
                         <xsl:text disable-output-escaping="yes">xtrf="000</xsl:text>
                         <xsl:text disable-output-escaping="yes">"</xsl:text>
                         <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                         <xsl:text>&#x000A;</xsl:text><xsl:element name="title">
                             <xsl:value-of select="$head1"/>
                         </xsl:element>
                         <xsl:element name="conbody">                    
                             <xsl:apply-templates/>
                         </xsl:element><xsl:text>&#x000A;</xsl:text>
                         <xsl:text disable-output-escaping="yes">&lt;/concept&gt;</xsl:text>
                     </xsl:result-document>
                 </xsl:otherwise>
             </xsl:choose>
        </xsl:for-each>
          
        <!--<xsl:text>&#x000A;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;task </xsl:text>
        <xsl:text disable-output-escaping="yes">xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" </xsl:text>
        <xsl:text disable-output-escaping="yes">base="</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">id="</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">props="</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">rev="XXX</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">translate="yes</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">xml:lang="en-US</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">xsi:noNamespaceSchemaLocation="urn:ptc:names:arbortext:dita:xsd:techinfo.xsd</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">xtrc="ADJ</xsl:text>
        <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">xtrf="000</xsl:text>
        <xsl:text disable-output-escaping="yes">"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        
        <xsl:text>&#x000A;</xsl:text><xsl:element name="title">
            <xsl:value-of select="'Title'"/>
        </xsl:element>
            <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;/task&gt;</xsl:text>-->
        
    </xsl:template>
    <xsl:template match="@class"/>
    <xsl:template match="p[@class = 'FigureLegend']"/>
    <xsl:template match="p[string-length(.) &lt;= 0]"/>
</xsl:stylesheet>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:test="http://www.w3.org/1999/xhtml"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:mynamespace="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="#default"
    version="2.0">
    
    <!-- Moving DIV inside P, to outside P -->
    <!-- 15-AUG-18: Condition added to remove empty style attribute -->
    <!-- 19-Sep-18: Comment Range highlight -->
    <!-- 20-Sep-18: Ascii2Unicode changed -->
    
    
    <!-- 28-Sep-18: Taking value from endnote citations @data-numval  -->    
    <!-- 03-oct-18 retaining endnote hyperlinks if any-->
    
    <!-- 24-oct-18: Added No-B-IT property Sindhu; data obtained from 01-W2H-CK.xslt-->
    <!-- 28-JUNE-19: To remove full b-i-u -->
    <!--To Remove dummy para if it has "normal" data-name only 18-7-2019-->
    
    <xsl:output method="xhtml" use-character-maps="Ascii2Unicode" indent="no"/>    
   <!-- <xsl:output method="xml" use-character-maps="Ascii2Unicode" indent="no"/>-->
    <xsl:param name="myNameSpace" select="'http://www.w3.org/1999/xhtml'"/>
    <!--<xsl:variable name="css" select="document('css.xml')"/>-->
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*">        
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:variable name="filename" select="substring-before(tokenize(base-uri(.), '/')[last()],'.')"/>
    
    
    <xsl:template match="html">
        
        <xsl:text disable-output-escaping="yes">&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;</xsl:text>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
        <xsl:text>&#x000A;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;/html&gt;</xsl:text>
    </xsl:template>
    
    <!--Added for cic-Group 16-8-2019-->
    <xsl:template match="body">
        <xsl:copy>
            <xsl:if test="descendant::p[contains(.,'FMGroup')]">
                <xsl:text disable-output-escaping="yes">&lt;div data-alias="FMGroup"&gt;</xsl:text>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
            <xsl:if test="descendant::p[contains(.,'BodyGroup')]">
                <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
            </xsl:if>
        </xsl:copy>
      </xsl:template>
    <!--End-->
    
    <xsl:template match="ol">
        <xsl:variable name="class" select="."/>
        <xsl:variable name="start" select="."/>
        <xsl:variable name="listType" select="child::*[1]/@listtype"/>
        <xsl:variable name="numberFormat" select="child::*[1]/@numberFormat"/>
        <xsl:variable name="numberType">
            <xsl:choose>
                <xsl:when test="child::*[1]/@numberType">
                    <xsl:value-of select="child::*[1]/@numberType"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@numberType"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(preceding-sibling::*[1][self::ol])">
                <xsl:text>&#x000A;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
                <xsl:choose>
                    <xsl:when test="@indent">
                        <xsl:text> margin-left:</xsl:text>
                        <xsl:value-of select="@indent"/> 
                        <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--<xsl:value-of select="@class"/>
                        <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                        <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>&#x000A;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;ol</xsl:text>
                <xsl:if test="@class">
                    <xsl:text> class="</xsl:text>
                    <xsl:value-of select="@class"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@start">
                    <xsl:text> start="</xsl:text>
                    <xsl:value-of select="@start"/>
                    <xsl:text>"</xsl:text>
                </xsl:if> 
                <xsl:if test="@numberFormat">
                    <xsl:text> type="</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(@numberFormat, 'decimal')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                                    
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                            <xsl:value-of select="'a'"/>        
                        </xsl:when>                             
                        <xsl:when test="contains(@numberFormat, 'upperLetter')">
                            <xsl:value-of select="'A'"/>                      
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                            <xsl:value-of select="'i'"/>                       
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'upperRoman')">
                            <xsl:value-of select="'I'"/>
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'bullet')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                           
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>"</xsl:text>
                </xsl:if> 
                <xsl:if test="@data-ilvl">
                    <xsl:text> data-ilvl="</xsl:text>
                    <xsl:value-of select="@data-ilvl"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-numFmt">
                    <xsl:text> data-numFmt="</xsl:text>
                    <xsl:value-of select="@data-numFmt"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-lvlText">
                    <xsl:text> data-lvlText="</xsl:text>
                    <xsl:value-of select="@data-lvlText"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#x000A;</xsl:text>
            </xsl:when>
            <xsl:when test="preceding-sibling::*[1][self::ol[@type]]">
                <xsl:text>&#x000A;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
                <xsl:choose>
                    <xsl:when test="@indent">
                        <xsl:text> margin-left:</xsl:text>
                        <xsl:value-of select="@indent"/> 
                        <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--<xsl:value-of select="@class"/>
                        <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                        <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>&#x000A;</xsl:text> 
                <xsl:text disable-output-escaping="yes">&lt;ol</xsl:text>
                <xsl:if test="@class">
                    <xsl:text> class="</xsl:text>
                    <xsl:value-of select="@class"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@start">
                    <xsl:text> start="</xsl:text>
                    <xsl:value-of select="@start"/>
                    <xsl:text>"</xsl:text>
                </xsl:if> 
                <xsl:if test="@numberFormat">
                    <xsl:text> type="</xsl:text>
                    <!--<xsl:value-of select="@numberFormat"/>-->
                    <xsl:choose>
                        <xsl:when test="contains(@numberFormat, 'decimal')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                                    
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                            <xsl:value-of select="'a'"/>        
                        </xsl:when>                             
                        <xsl:when test="contains(@numberFormat, 'upperLetter')">
                            <xsl:value-of select="'A'"/>                      
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                            <xsl:value-of select="'i'"/>                       
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'upperRoman')">
                            <xsl:value-of select="'I'"/>
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'bullet')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                           
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-ilvl">
                    <xsl:text> data-ilvl="</xsl:text>
                    <xsl:value-of select="@data-ilvl"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-numFmt">
                    <xsl:text> data-numFmt="</xsl:text>
                    <xsl:value-of select="@data-numFmt"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-lvlText">
                    <xsl:text> data-lvlText="</xsl:text>
                    <xsl:value-of select="@data-lvlText"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#x000A;</xsl:text>  
            </xsl:when>
            <xsl:when test="preceding-sibling::*[1][self::ol[@start]] and not(self::ol[@start])">
                <xsl:text>&#x000A;</xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
                <xsl:choose>
                    <xsl:when test="@indent">
                        <xsl:text> margin-left:</xsl:text>
                        <xsl:value-of select="@indent"/> 
                        <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--<xsl:value-of select="@class"/>
                        <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                        <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:text>&#x000A;</xsl:text> 
                <xsl:text disable-output-escaping="yes">&lt;ol</xsl:text>
                <xsl:if test="@class">
                    <xsl:text> class="</xsl:text>
                    <xsl:value-of select="@class"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@start">
                    <xsl:text> start="</xsl:text>
                    <xsl:value-of select="@start"/>
                    <xsl:text>"</xsl:text>
                </xsl:if>  
                <xsl:if test="@numberFormat">
                    <xsl:text> type="</xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains(@numberFormat, 'decimal')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                                    
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                            <xsl:value-of select="'a'"/>        
                        </xsl:when>                             
                        <xsl:when test="contains(@numberFormat, 'upperLetter')">
                            <xsl:value-of select="'A'"/>                      
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                            <xsl:value-of select="'i'"/>                       
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'upperRoman')">
                            <xsl:value-of select="'I'"/>
                        </xsl:when>
                        <xsl:when test="contains(@numberFormat, 'bullet')">
                            <xsl:choose>
                                <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                    <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="@numberFormat"/>
                                </xsl:otherwise>
                            </xsl:choose>                           
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>"</xsl:text>
                </xsl:if>                
                <xsl:if test="@data-ilvl">
                    <xsl:text> data-ilvl="</xsl:text>
                    <xsl:value-of select="@data-ilvl"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-numFmt">
                    <xsl:text> data-numFmt="</xsl:text>
                    <xsl:value-of select="@data-numFmt"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:if test="@data-lvlText">
                    <xsl:text> data-lvlText="</xsl:text>
                    <xsl:value-of select="@data-lvlText"/>                    
                    <xsl:text>"</xsl:text>
                </xsl:if>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#x000A;</xsl:text>  
            </xsl:when>            
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ol])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> 
        </xsl:if>
        <xsl:if
            test="following-sibling::*[1][self::ol[@type]]">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> 
        </xsl:if>
    </xsl:template>
    
    
    
    <xsl:template match="p[@type]">
        <xsl:variable name="class" select="@class"/>
        <xsl:variable name="type" select="@type"/>

            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative; margin-left:</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@type"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;p class="</xsl:text>
                <xsl:value-of select="$class"/>        
            <xsl:text disable-output-escaping="yes">" </xsl:text>
        <xsl:text disable-output-escaping="yes">type="</xsl:text>
        <xsl:value-of select="$type"/>        
        <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text disable-output-escaping="yes">&lt;/p&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>  
    </xsl:template>
    
    
    
    <xsl:template match="mynamespace:FIGURE-REF1 | mynamespace:TABLE-REF1">

        <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat($filename, '#', ./@POINTER)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
        </xsl:element>        
    </xsl:template>
    
    <xsl:template match="FIGURE-REF | TABLE-REF"/>
    
    <xsl:template match="mynamespace:FIGURE">       
        <FIGURE>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </FIGURE>
    </xsl:template>
    
    <xsl:template match="mynamespace:TABLE-WRAPPER">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="table">
        <xsl:element name="{name(.)}" namespace="{$myNameSpace}">
            <xsl:if test="parent::mynamespace:TABLE-WRAPPER/@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="parent::mynamespace:TABLE-WRAPPER/@id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="imgg">  
        <xsl:element name="img">
        <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>
    
    <!-- 09-04-16: This below template match is to move imgs,tables inside ul/ol to outside of ulol -->
    <xsl:template match="div">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
        <xsl:if test="child::ul/table">
            <xsl:for-each select="child::ul/table">
                <xsl:text>&#x000A;</xsl:text>
                <xsl:element name="table">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ul[not(parent::div)] | ol[not(parent::div)]">
        <xsl:element name="{local-name()}">
            <xsl:apply-templates select="node()|@*"/>
        </xsl:element>
        <xsl:if test="child::div">
            <xsl:for-each select="child::div">
                <xsl:text>&#x000A;</xsl:text> 
                <xsl:element name="div">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element>
                <xsl:text>&#x000A;</xsl:text> 
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="child::table">
            <xsl:for-each select="child::table">
                <xsl:text>&#x000A;</xsl:text>
                <xsl:element name="table">
                    <xsl:apply-templates select="node()|@*"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ul//div"/>
    <xsl:template match="ul//table"/>
    <xsl:template match="div//ul/table"/>
    <xsl:template match="@v"/>
    <xsl:template match="@m"/>
    <xsl:template match="@o"/>
    <xsl:template match="@v2"/>
    <xsl:template match="@v3"/>
    <xsl:template match="bibsurname">
        <xsl:element name="span">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="bibyear">
        <xsl:element name="span">
            <xsl:attribute name="class" select="@class"/>
            <xsl:attribute name="data-name" select="@data-name"/>            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
  
    <xsl:template match="span[@style = '']"><!-- 15-AUG-18: Condition added to remove empty style attribute -->
        <xsl:element name="span">
            <xsl:copy-of select="@*[not(name()='style')]"/>
                <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="div[@class = 'WordSection1']">
          <xsl:apply-templates/>
    </xsl:template>    
    
<!-- 15-June-17: added attribute "data-split" for the elements asked by Mariappan-->     
    <xsl:template match="//p|img|li|divNO">
        <xsl:element name="{local-name()}">
            <xsl:attribute name="data-split">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
<!-- 15-June-17: added attribute "data-split" for the elements asked by Mariappan-->
  

    
    
    <!-- Do not hide this. Must Required  -->
        <!--<xsl:template match="//p[@class = 'MsoEndnoteText']/a"/>--><!-- 03-sep-18 retaining endnote hyperlinks if any-->
        <xsl:template match="p[@class = 'MsoEndnoteText']/a[contains(@href,'#eref')]"/>
        <xsl:template match="EN"/>
    <!-- Do not hide above -->
     
    <xsl:template match="p[@class = 'MsoEndnoteText']">
        <xsl:element name="p">
            <xsl:attribute name="data-split"><!-- Added on 28-Mar-18 -->
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:copy-of select="@class"/>
            <xsl:copy-of select="@data-name"/>
            <xsl:attribute name="id" select="concat('e',substring-after(child::a[1]/@href,'#eref'))"/>
            <xsl:apply-templates/>        
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="span[@class = 'EndnoteReference']">
        <xsl:choose>
            <xsl:when test="ancestor::div[@style = 'mso-element:endnote']">
                <xsl:variable name="endnote-id" select="preceding-sibling::a/@style"/>
                <xsl:variable name="endnote-id2" select="substring-after($endnote-id,':')"/>
                <xsl:choose>
                    <xsl:when test="//EN">
                        <xsl:element name="a">
                            <xsl:copy-of select="preceding-sibling::a/@*"/>
                            <xsl:element name="span">
                            <xsl:copy-of select="@*"/>
                            <xsl:value-of select="//EN[@ENid = $endnote-id2]"></xsl:value-of>
                            </xsl:element>                        
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="span">
                            <xsl:copy-of select="@*"/>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
     <!-- 16-Jan-18; Then see next XSLT (continued from 4-List.xslt) -->
     <xsl:template match="tr/td[1][preceding-sibling::span[@data-bkmark]]">
         <xsl:element name="td">             
             <xsl:copy-of select="@*"/>
             <xsl:text>&#x000A;</xsl:text>             
                 <xsl:apply-templates select="preceding-sibling::span" mode="span"/>             
             <xsl:text>&#x000A;</xsl:text> 
             <xsl:choose>
                 <xsl:when test="@Themeformat = 'BI'">
                     <xsl:element name="B">
                         <xsl:element name="I">
                             <xsl:apply-templates/>
                         </xsl:element>
                     </xsl:element>
                 </xsl:when>
                 <xsl:when test="@Themeformat = 'B'">
                     <xsl:element name="B">                         
                             <xsl:apply-templates/>                         
                     </xsl:element>
                 </xsl:when>
                 <xsl:when test="@Themeformat = 'I'">
                     <xsl:element name="I">                         
                         <xsl:apply-templates/>                         
                     </xsl:element>
                 </xsl:when>
                 <xsl:otherwise>                     
                             <xsl:apply-templates/>                         
                 </xsl:otherwise>
             </xsl:choose>
             <!--<xsl:apply-templates/>-->
         </xsl:element>
     </xsl:template>     
     <xsl:template match="span[parent::tr][@data-bkmark]" mode="span">         
         <xsl:element name="span">
             <xsl:copy-of select="@*"/>
         </xsl:element>
     </xsl:template>
     <xsl:template match="span[parent::tr]"/>
    <xsl:template match="td">
        <xsl:element name="td">             
            <xsl:copy-of select="@style"/>
            <xsl:copy-of select="@colspan"/>
            <xsl:copy-of select="@rowspan"/>
            <xsl:choose>
                <xsl:when test="@Themeformat = 'BI'">
                    <xsl:element name="b">
                        <xsl:element name="i">
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@Themeformat = 'B'">
                    <xsl:element name="b">                         
                        <xsl:apply-templates/>                         
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@Themeformat = 'i'">
                    <xsl:element name="I">                         
                        <xsl:apply-templates/>                         
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>                     
                    <xsl:apply-templates/>                         
                </xsl:otherwise>
            </xsl:choose>
            <!--<xsl:apply-templates/>-->
        </xsl:element>
    </xsl:template> 
    <xsl:template match="//td/@Themeformat"/>
     <!-- 16-Jan-18; Then see next XSLT-->
    
    <!-- 19-Sep-18: Comment Range highlight --><!--|li[descendant::span[@data-commentrange]]//text()-->
    <xsl:template match="p[descendant::span[@data-commentrange]]//text()">
        <xsl:choose>
            <xsl:when test=".[preceding::*[@data-commentrange = 'cmtStart']/@data-comment = following::*[@data-commentrange='cmtEnd']/@data-comment]">
                <xsl:element name="span"><!--Panneer change spanX to span 19-12-2018-->
                    <xsl:attribute name="style" select="'background: rgba(159, 190, 131, 0.38);'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>        
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."></xsl:value-of>
            </xsl:otherwise>
        </xsl:choose>
        
        
    </xsl:template>
    <!--<xsl:template match="//text()[preceding::*[@data-commentrange = 'cmtStart']/@data-comment = following::*[@data-commentrange='cmtEnd']/@data-comment]">
        <xsl:element name="span">
            <xsl:attribute name="style" select="'background: rgba(159, 190, 131, 0.38);'"/>
            <xsl:copy-of select="."/>
        </xsl:element>
    </xsl:template>-->
    <!--  commented by hari for testing purposes 14.12.2018  -->
    <!--<xsl:template match="span[@data-commentrange]"/>-->
    <!-- 19-Sep-18: Comment Range highlight -->
    <!-- 24-oct-18: Added No-B-IT property Sindhu; data obtained from 01-W2H-CK.xslt-->
    
    <!--<xsl:template match="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Italic]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid]">
        <xsl:element name="span">
            <xsl:attribute name="data-Italic" select="'REMOVE'"/>
            <xsl:copy-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Bold]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid]">
        <xsl:element name="span">
            <xsl:attribute name="data-Bold" select="'REMOVE'"/>
            <xsl:copy-of select="."/>
        </xsl:element>
            
        
    </xsl:template>
    <xsl:template match="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Underline]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid]">
        <xsl:element name="span">            
            <xsl:attribute name="data-Underline" select="'REMOVE'"/>
            <xsl:copy-of select="."/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Italic]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid 
        and preceding::*[@data-PROrange = 'proStart'][@data-Bold]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid 
        and preceding::*[@data-PROrange = 'proStart'][@data-Underline]/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid]">
        <xsl:element name="span">
            <xsl:attribute name="data-Italic" select="'REMOVE'"/>
            <xsl:attribute name="data-Bold" select="'REMOVE'"/>
            <xsl:attribute name="data-Underline" select="'REMOVE'"/>
            <xsl:copy-of select="."/>
        </xsl:element>
    </xsl:template>
    
    
    -->
    
    
    
    <!--<xsl:template match="//text()[preceding::*[@data-PROrange = 'proStart']/@data-PROid = following::*[@data-PROrange='proEnd']/@data-PROid]">
        <!-\-<xsl:element name="span">
            <xsl:if test="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Italic]] and //text()[preceding::*[@data-PROrange = 'proStart'][@data-Bold]] 
                and //text()[preceding::*[@data-PROrange = 'proStart'][@data-Underline]]">
            <xsl:attribute name="data-ItalicBoldUnderline" select="'REMOVE'"/>
            </xsl:if>
            <xsl:if test="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Italic]]">
                <xsl:attribute name="data-Italic" select="'REMOVE'"/>
            </xsl:if>
            <xsl:if test="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Bold]]">
            <xsl:attribute name="data-Bold" select="'REMOVE'"/>
            </xsl:if>
            <xsl:if test="//text()[preceding::*[@data-PROrange = 'proStart'][@data-Underline]]">
            <xsl:attribute name="data-Underline" select="'REMOVE'"/>
            </xsl:if>
            <xsl:copy-of select="."/>
        </xsl:element>-\->
        <xsl:choose>
            <xsl:when test="preceding::*[@data-PROrange = 'proStart'][@data-Italic] and preceding::*[@data-PROrange = 'proStart'][@data-Bold] and preceding::*[@data-PROrange = 'proStart'][@data-Underline]">
                <xsl:element name="spanBIU">
                    <xsl:attribute name="data-Italic" select="'REMOVE'"/>
                    <xsl:attribute name="data-Bold" select="'REMOVE'"/>
                    <xsl:attribute name="data-Underline" select="'REMOVE'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>
            </xsl:when>            
            <xsl:when test="preceding::span[@data-PROrange = 'proStart']/@data-Italic">
                <xsl:element name="spanI">
                    <xsl:attribute name="data-Italic" select="'REMOVE'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="preceding::span[@data-PROrange = 'proStart']/@data-Bold">
                <xsl:element name="spanB">
                    <xsl:attribute name="data-Bold" select="'REMOVE'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="preceding::span[@data-PROrange = 'proStart']/@data-Underline">
                <xsl:element name="span">
                    <xsl:attribute name="data-Underline" select="'REMOVE'"/>
                    <xsl:copy-of select="."/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>      
        
    </xsl:template>-->
    <!--<xsl:template match="//span[@data-PROrange]"/>-->
    <!-- 24-oct-18: Added No-B-IT property Sindhu -->
    
    
     <!-- Moving DIV inside P, to outside P -->
     <xsl:template match="//p">
         <xsl:element name="{name()}">
             <xsl:attribute name="data-split"><!-- Added on 28-Mar-18 -->
                 <xsl:value-of select="generate-id()"/>
             </xsl:attribute>
             <xsl:copy-of select="@*"/>
             <xsl:apply-templates select="@*|node()"/>         
         </xsl:element>
         <xsl:if test="descendant-or-self::div">
             <xsl:for-each select="descendant-or-self::div">
                 <xsl:text>&#x000A;</xsl:text>
                 <xsl:element name="div">
                     <xsl:copy-of select="@*"/>
                     <xsl:apply-templates select="@*|node()"/>
                 </xsl:element>
             </xsl:for-each>
         </xsl:if>         
     </xsl:template>    
     <xsl:template match="p//div"/>
     <!-- Moving DIV inside P, to outside P ENDS here-->
    
    
    
    
    <xsl:template match="p[following-sibling::*[1][self::span[@data-bkmark]]]">
        <xsl:element name="p">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <xsl:apply-templates select="following-sibling::*[1][self::span[@data-bkmark]]" mode="movespan"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="span[@data-bkmark]" mode="movespan">
        <xsl:element name="span">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="span[@data-bkmark]">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][self::p]"></xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!-- 28-AUG-18: Footnote number, getting from its callout -->
    <xsl:template match="div[@style = 'mso-element:footnote']/a/sup">
        <xsl:variable name="a" select="substring-after(parent::a/@href, '#')"></xsl:variable>
        <xsl:element name="sup">
            <xsl:choose>
                <xsl:when test="//a[@name = $a]">
                    <xsl:value-of select="//a[@name = $a]"></xsl:value-of>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:element>
    </xsl:template>
    <xsl:template match="ol[@type = 'nolist']">
        <xsl:for-each select="li">
            <xsl:element name="p">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ol[@type = 'a']">
        <xsl:if
            test="not(preceding-sibling::*[1][self::ol[@type = 'a']])">
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:text> margin-left:</xsl:text>
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:value-of select="@class"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                    <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>            
            <xsl:text disable-output-escaping="yes">&lt;ol type="a"</xsl:text>
            <xsl:if test="@class">
                <xsl:text> class="</xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@start">
                <xsl:text> start="</xsl:text>
                <xsl:value-of select="@start"/>
                <xsl:text>"</xsl:text>
            </xsl:if>                
            <xsl:if test="@numberFormat">
                <xsl:text> type="</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@numberFormat, 'decimal')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                                    
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                        <xsl:value-of select="'a'"/>        
                    </xsl:when>                             
                    <xsl:when test="contains(@numberFormat, 'upperLetter')">
                        <xsl:value-of select="'A'"/>                      
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                        <xsl:value-of select="'i'"/>                       
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'upperRoman')">
                        <xsl:value-of select="'I'"/>
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'bullet')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                           
                    </xsl:when>
                </xsl:choose>
                <xsl:text>"</xsl:text>
            </xsl:if>                
            <xsl:if test="@data-ilvl">
                <xsl:text> data-ilvl="</xsl:text>
                <xsl:value-of select="@data-ilvl"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-numFmt">
                <xsl:text> data-numFmt="</xsl:text>
                <xsl:value-of select="@data-numFmt"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-lvlText">
                <xsl:text> data-lvlText="</xsl:text>
                <xsl:value-of select="@data-lvlText"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>                        
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ol[@type = 'a']])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ol[@type = 'A']">       
        <xsl:if
            test="not(preceding-sibling::*[1][self::ol[@type = 'A']])">
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:text> margin-left:</xsl:text>
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:value-of select="@class"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                    <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;ol type="A"</xsl:text>
            <xsl:if test="@class">
                <xsl:text> class="</xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@start">
                <xsl:text> start="</xsl:text>
                <xsl:value-of select="@start"/>
                <xsl:text>"</xsl:text>
            </xsl:if> 
            <xsl:if test="@numberFormat">
                <xsl:text> type="</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@numberFormat, 'decimal')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                                    
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                        <xsl:value-of select="'a'"/>        
                    </xsl:when>                             
                    <xsl:when test="contains(@numberFormat, 'upperLetter')">
                        <xsl:value-of select="'A'"/>                      
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                        <xsl:value-of select="'i'"/>                       
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'upperRoman')">
                        <xsl:value-of select="'I'"/>
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'bullet')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                           
                    </xsl:when>
                </xsl:choose>
                <xsl:text>"</xsl:text>
            </xsl:if>                
            <xsl:if test="@data-ilvl">
                <xsl:text> data-ilvl="</xsl:text>
                <xsl:value-of select="@data-ilvl"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-numFmt">
                <xsl:text> data-numFmt="</xsl:text>
                <xsl:value-of select="@data-numFmt"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-lvlText">
                <xsl:text> data-lvlText="</xsl:text>
                <xsl:value-of select="@data-lvlText"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>                        
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ol[@type = 'A']])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> 
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ol[@type = 'i']">       
        <xsl:if
            test="not(preceding-sibling::*[1][self::ol[@type = 'i']])">
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:text> margin-left:</xsl:text>
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:value-of select="@class"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                    <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;ol type="i"</xsl:text>
            <xsl:if test="@class">
                <xsl:text> class="</xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@start">
                <xsl:text> start="</xsl:text>
                <xsl:value-of select="@start"/>
                <xsl:text>"</xsl:text>
            </xsl:if>  
            <xsl:if test="@numberFormat">
                <xsl:text> type="</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@numberFormat, 'decimal')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                                    
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                        <xsl:value-of select="'a'"/>        
                    </xsl:when>                             
                    <xsl:when test="contains(@numberFormat, 'upperLetter')">
                        <xsl:value-of select="'A'"/>                      
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                        <xsl:value-of select="'i'"/>                       
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'upperRoman')">
                        <xsl:value-of select="'I'"/>
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'bullet')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                           
                    </xsl:when>
                </xsl:choose>
                <xsl:text>"</xsl:text>
            </xsl:if>                
            <xsl:if test="@data-ilvl">
                <xsl:text> data-ilvl="</xsl:text>
                <xsl:value-of select="@data-ilvl"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-numFmt">
                <xsl:text> data-numFmt="</xsl:text>
                <xsl:value-of select="@data-numFmt"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-lvlText">
                <xsl:text> data-lvlText="</xsl:text>
                <xsl:value-of select="@data-lvlText"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>                        
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ol[@type = 'i']])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ol[@type = 'I']">       
        <xsl:if
            test="not(preceding-sibling::*[1][self::ol[@type = 'I']])">
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative;</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:text> margin-left:</xsl:text>
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                   <!-- <xsl:value-of select="@class"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>-->
                    <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;ol type="I"</xsl:text>
            <xsl:if test="@class">
                <xsl:text> class="</xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@start">
                <xsl:text> start="</xsl:text>
                <xsl:value-of select="@start"/>
                <xsl:text>"</xsl:text>
            </xsl:if> 
            <xsl:if test="@numberFormat">
                <xsl:text> type="</xsl:text>
                <xsl:choose>
                    <xsl:when test="contains(@numberFormat, 'decimal')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                                    
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerLetter')">
                        <xsl:value-of select="'a'"/>        
                    </xsl:when>                             
                    <xsl:when test="contains(@numberFormat, 'upperLetter')">
                        <xsl:value-of select="'A'"/>                      
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'lowerRoman')">
                        <xsl:value-of select="'i'"/>                       
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'upperRoman')">
                        <xsl:value-of select="'I'"/>
                    </xsl:when>
                    <xsl:when test="contains(@numberFormat, 'bullet')">
                        <xsl:choose>
                            <xsl:when test="contains(@numberFormat, '&#x0025;')">
                                <xsl:value-of select="substring-after(@numberFormat,'&#x0025;')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@numberFormat"/>
                            </xsl:otherwise>
                        </xsl:choose>                           
                    </xsl:when>
                </xsl:choose>
                <xsl:text>"</xsl:text>
            </xsl:if>                
            <xsl:if test="@data-ilvl">
                <xsl:text> data-ilvl="</xsl:text>
                <xsl:value-of select="@data-ilvl"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-numFmt">
                <xsl:text> data-numFmt="</xsl:text>
                <xsl:value-of select="@data-numFmt"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:if test="@data-lvlText">
                <xsl:text> data-lvlText="</xsl:text>
                <xsl:value-of select="@data-lvlText"/>                    
                <xsl:text>"</xsl:text>
            </xsl:if>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>                        
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ol[@type = 'I']])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ol&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> 
        </xsl:if>
    </xsl:template>
    
    <!-- 07-JUNE-18: custom ol has only one li, removing its class (like *paren*) by it child li-class-->
    <xsl:template match="ol[contains(@class, 'Paren') and not(@start = 1)]">        
        <xsl:variable name="li-class" select="child::li[1]/@class"/>   
        <xsl:text>&#x000A;</xsl:text>
        <xsl:element name="ol">
            <xsl:attribute name="class" select="$li-class"/>
            <xsl:copy-of select="@* except (@ColumnValue|@StoryValue|@txtFrameId|@class|@listtype|@numberFormat|@numberType)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="ol[contains(@class, 'step') and not(@start = 1)]">        
        <xsl:variable name="li-class" select="child::li[1]/@class"/>
        <xsl:text>&#x000A;</xsl:text>
        <xsl:element name="ol">
            <xsl:attribute name="class" select="$li-class"/>
            <xsl:copy-of select="@* except (@ColumnValue|@StoryValue|@txtFrameId|@class|@listtype|@numberFormat|@numberType)"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="ul[@style = 'o']">       
        <xsl:if
            test="not(preceding-sibling::*[1][self::ul[@style = 'o']])">
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;div style="position:relative; margin-left:</xsl:text>
            <xsl:choose>
                <xsl:when test="@indent">
                    <xsl:value-of select="@indent"/> 
                    <xsl:text disable-output-escaping="yes">;"&gt;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@class"/>
                    <xsl:text disable-output-escaping="yes">em;"&gt;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;ul style="o" class="</xsl:text>
            <xsl:value-of select="@class"/>
            <xsl:text disable-output-escaping="yes">"&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>                        
        </xsl:if>
        <xsl:apply-templates/>
        <xsl:if
            test="not(following-sibling::*[1][self::ul[@style = 'o']])">            
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/ul&gt;</xsl:text>
            <xsl:text>&#x000A;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text> 
        </xsl:if>
    </xsl:template>
    
    <!-- 28-Sep-18: Taking value from endnote citations @data-numval  -->
    <xsl:template match="a[contains(@href,'#eref')]">
        <xsl:variable name="href" select="substring-after(@href,'#')"/>
        <xsl:element name="a">
            <xsl:copy-of select="@*"/>
            <xsl:choose>
                <xsl:when test="//a[@id = $href]/@data-numval">
                    <xsl:value-of select="//a[@id = $href]/@data-numval"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="@data-en-num|@data-numval"></xsl:template>
    <xsl:template match="a[@href = '#eref0']"></xsl:template>
    <!-- 28-Sep-18: Taking value from endnote citations @data-numval  ENDs -->
    
 <!-- 30-oct-18: Remove RANGE bookmarks -->
    <xsl:template match="span[contains(@data-bkmark,'RANGE')]"/>
 <!-- 30-oct-18: Remove RANGE bookmarks -->
        
    
  <xsl:character-map name="Ascii2Unicode">
<xsl:output-character character="┐" string="&amp;#x2510;"/>
<xsl:output-character character="╕" string="&amp;#x2556;"/>
<xsl:output-character character="╖" string="&amp;#x2557;"/>
<xsl:output-character character="╗" string="&amp;#x2555;"/>
<xsl:output-character character="┌" string="&amp;#x250C;"/>
<xsl:output-character character="╒" string="&amp;#x2554;"/>
<xsl:output-character character="╓" string="&amp;#x2553;"/>
<xsl:output-character character="╔" string="&amp;#x2552;"/>
<xsl:output-character character="─" string="&amp;#x2500;"/>
<xsl:output-character character="═" string="&amp;#x2550;"/>
<xsl:output-character character="┬" string="&amp;#x252C;"/>
<xsl:output-character character="╥" string="&amp;#x2564;"/>
<xsl:output-character character="╤" string="&amp;#x2566;"/>
<xsl:output-character character="╦" string="&amp;#x2565;"/>
<xsl:output-character character="┴" string="&amp;#x2534;"/>
<xsl:output-character character="╨" string="&amp;#x2567;"/>
<xsl:output-character character="╧" string="&amp;#x2569;"/>
<xsl:output-character character="╩" string="&amp;#x2568;"/>
<xsl:output-character character="┘" string="&amp;#x2518;"/>
<xsl:output-character character="╛" string="&amp;#x255D;"/>
<xsl:output-character character="╜" string="&amp;#x255C;"/>
<xsl:output-character character="╝" string="&amp;#x255B;"/>
<xsl:output-character character="└" string="&amp;#x2514;"/>
<xsl:output-character character="╘" string="&amp;#x2559;"/>
<xsl:output-character character="╙" string="&amp;#x255A;"/>
<xsl:output-character character="╚" string="&amp;#x2558;"/>
<xsl:output-character character="│" string="&amp;#x2502;"/>
<xsl:output-character character="║" string="&amp;#x2551;"/>
<xsl:output-character character="┼" string="&amp;#x253C;"/>
<xsl:output-character character="╪" string="&amp;#x256A;"/>
<xsl:output-character character="╫" string="&amp;#x256C;"/>
<xsl:output-character character="╬" string="&amp;#x256B;"/>
<xsl:output-character character="┤" string="&amp;#x2524;"/>
<xsl:output-character character="╡" string="&amp;#x2561;"/>
<xsl:output-character character="╢" string="&amp;#x2563;"/>
<xsl:output-character character="╣" string="&amp;#x2562;"/>
<xsl:output-character character="├" string="&amp;#x251C;"/>
<xsl:output-character character="╞" string="&amp;#x255E;"/>
<xsl:output-character character="╟" string="&amp;#x2560;"/>
<xsl:output-character character="╠" string="&amp;#x255F;"/>
    <!-- isocyr1map.xsl -->
<xsl:output-character character="а" string="&amp;#x0430;"/>
<xsl:output-character character="А" string="&amp;#x0410;"/>
<xsl:output-character character="б" string="&amp;#x0431;"/>
<xsl:output-character character="Б" string="&amp;#x0411;"/>
<xsl:output-character character="ч" string="&amp;#x0447;"/>
<xsl:output-character character="Ч" string="&amp;#x0427;"/>
<xsl:output-character character="д" string="&amp;#x0434;"/>
<xsl:output-character character="Д" string="&amp;#x0414;"/>
<xsl:output-character character="э" string="&amp;#x044D;"/>
<xsl:output-character character="Э" string="&amp;#x042D;"/>
<xsl:output-character character="ф" string="&amp;#x0444;"/>
<xsl:output-character character="Ф" string="&amp;#x0424;"/>
<xsl:output-character character="г" string="&amp;#x0433;"/>
<xsl:output-character character="Г" string="&amp;#x0413;"/>
<xsl:output-character character="ъ" string="&amp;#x044A;"/>
<xsl:output-character character="Ъ" string="&amp;#x042A;"/>
<xsl:output-character character="и" string="&amp;#x0438;"/>
<xsl:output-character character="И" string="&amp;#x0418;"/>
<xsl:output-character character="е" string="&amp;#x0435;"/>
<xsl:output-character character="Е" string="&amp;#x0415;"/>
<xsl:output-character character="ё" string="&amp;#x0451;"/>
<xsl:output-character character="Ё" string="&amp;#x0401;"/>
<xsl:output-character character="й" string="&amp;#x0439;"/>
<xsl:output-character character="Й" string="&amp;#x0419;"/>
<xsl:output-character character="к" string="&amp;#x043A;"/>
<xsl:output-character character="К" string="&amp;#x041A;"/>
<xsl:output-character character="х" string="&amp;#x0445;"/>
<xsl:output-character character="Х" string="&amp;#x0425;"/>
<xsl:output-character character="л" string="&amp;#x043B;"/>
<xsl:output-character character="Л" string="&amp;#x041B;"/>
<xsl:output-character character="м" string="&amp;#x043C;"/>
<xsl:output-character character="М" string="&amp;#x041C;"/>
<xsl:output-character character="н" string="&amp;#x043D;"/>
<xsl:output-character character="Н" string="&amp;#x041D;"/>
<xsl:output-character character="№" string="&amp;#x2116;"/>
<xsl:output-character character="о" string="&amp;#x043E;"/>
<xsl:output-character character="О" string="&amp;#x041E;"/>
<xsl:output-character character="п" string="&amp;#x043F;"/>
<xsl:output-character character="П" string="&amp;#x041F;"/>
<xsl:output-character character="р" string="&amp;#x0440;"/>
<xsl:output-character character="Р" string="&amp;#x0420;"/>
<xsl:output-character character="с" string="&amp;#x0441;"/>
<xsl:output-character character="С" string="&amp;#x0421;"/>
<xsl:output-character character="щ" string="&amp;#x0449;"/>
<xsl:output-character character="Щ" string="&amp;#x0429;"/>
<xsl:output-character character="ш" string="&amp;#x0448;"/>
<xsl:output-character character="Ш" string="&amp;#x0428;"/>
<xsl:output-character character="ь" string="&amp;#x044C;"/>
<xsl:output-character character="Ь" string="&amp;#x042C;"/>
<xsl:output-character character="т" string="&amp;#x0442;"/>
<xsl:output-character character="Т" string="&amp;#x0422;"/>
<xsl:output-character character="ц" string="&amp;#x0446;"/>
<xsl:output-character character="Ц" string="&amp;#x0426;"/>
<xsl:output-character character="у" string="&amp;#x0443;"/>
<xsl:output-character character="У" string="&amp;#x0423;"/>
<xsl:output-character character="в" string="&amp;#x0432;"/>
<xsl:output-character character="В" string="&amp;#x0412;"/>
<xsl:output-character character="я" string="&amp;#x044F;"/>
<xsl:output-character character="Я" string="&amp;#x042F;"/>
<xsl:output-character character="ы" string="&amp;#x044B;"/>
<xsl:output-character character="Ы" string="&amp;#x042B;"/>
<xsl:output-character character="ю" string="&amp;#x044E;"/>
<xsl:output-character character="Ю" string="&amp;#x042E;"/>
<xsl:output-character character="з" string="&amp;#x0437;"/>
<xsl:output-character character="З" string="&amp;#x0417;"/>
<xsl:output-character character="ж" string="&amp;#x0436;"/>
<xsl:output-character character="Ж" string="&amp;#x0416;"/>
    <!-- isocyr2map.xsl -->
<xsl:output-character character="ђ" string="&amp;#x0452;"/>
<xsl:output-character character="Ђ" string="&amp;#x0402;"/>
<xsl:output-character character="ѕ" string="&amp;#x0455;"/>
<xsl:output-character character="Ѕ" string="&amp;#x0405;"/>
<xsl:output-character character="џ" string="&amp;#x045F;"/>
<xsl:output-character character="Џ" string="&amp;#x040F;"/>
<xsl:output-character character="ѓ" string="&amp;#x0453;"/>
<xsl:output-character character="Ѓ" string="&amp;#x0403;"/>
<xsl:output-character character="і" string="&amp;#x0456;"/>
<xsl:output-character character="І" string="&amp;#x0406;"/>
<xsl:output-character character="ј" string="&amp;#x0458;"/>
<xsl:output-character character="Ј" string="&amp;#x0408;"/>
<xsl:output-character character="є" string="&amp;#x0454;"/>
<xsl:output-character character="Є" string="&amp;#x0404;"/>
<xsl:output-character character="ќ" string="&amp;#x045C;"/>
<xsl:output-character character="Ќ" string="&amp;#x040C;"/>
<xsl:output-character character="љ" string="&amp;#x0459;"/>
<xsl:output-character character="Љ" string="&amp;#x0409;"/>
<xsl:output-character character="њ" string="&amp;#x045A;"/>
<xsl:output-character character="Њ" string="&amp;#x040A;"/>
<xsl:output-character character="ћ" string="&amp;#x045B;"/>
<xsl:output-character character="Ћ" string="&amp;#x040B;"/>
<xsl:output-character character="ў" string="&amp;#x045E;"/>
<xsl:output-character character="Ў" string="&amp;#x040E;"/>
<xsl:output-character character="ї" string="&amp;#x0457;"/>
<xsl:output-character character="Ї" string="&amp;#x0407;"/>
    <!-- isodiamap.xsl -->
<xsl:output-character character="´" string="&amp;#x00B4;"/>
<xsl:output-character character="˘" string="&amp;#x02D8;"/>
<xsl:output-character character="ˇ" string="&amp;#x02C7;"/>
<xsl:output-character character="¸" string="&amp;#x00B8;"/>
<xsl:output-character character="ˆ" string="&amp;#x2218;"/>
<xsl:output-character character="˝" string="&amp;#x02DD;"/>
<xsl:output-character character="¨" string="&amp;#x00A8;"/>
<xsl:output-character character="˙" string="&amp;#x02D9;"/>
    <!--U00060 grave-->
<!--<xsl:output-character character="¯" string="&amp;#x00AF;"/>-->
<xsl:output-character character="˛" string="&amp;#x02DB;"/>
<xsl:output-character character="˚" string="&amp;#x02DA;"/>
<xsl:output-character character="˜" string="&amp;#x007E;"/>
<xsl:output-character character="¨" string="&amp;#x00A8;"/>
    <!-- isolat1map.xsl -->
<xsl:output-character character="á" string="&amp;#x00E1;"/>
<xsl:output-character character="Á" string="&amp;#x00C1;"/>
<xsl:output-character character="â" string="&amp;#x00E2;"/>
<xsl:output-character character="Â" string="&amp;#x00C2;"/>
<xsl:output-character character="æ" string="&amp;#x00E6;"/>
<xsl:output-character character="Æ" string="&amp;#x00C6;"/>
<xsl:output-character character="à" string="&amp;#x00E0;"/>
<xsl:output-character character="À" string="&amp;#x00C0;"/>
<xsl:output-character character="å" string="&amp;#x00E5;"/>
<xsl:output-character character="Å" string="&amp;#x00C5;"/>
<xsl:output-character character="ã" string="&amp;#x00E3;"/>
<xsl:output-character character="Ã" string="&amp;#x00C3;"/>
<xsl:output-character character="ä" string="&amp;#x00E4;"/>
<xsl:output-character character="Ä" string="&amp;#x00C4;"/>
<xsl:output-character character="ç" string="&amp;#x00E7;"/>
<xsl:output-character character="Ç" string="&amp;#x00C7;"/>
<xsl:output-character character="é" string="&amp;#x00E9;"/>
<xsl:output-character character="É" string="&amp;#x00C9;"/>
<xsl:output-character character="ê" string="&amp;#x00EA;"/>
<xsl:output-character character="Ê" string="&amp;#x00CA;"/>
<xsl:output-character character="è" string="&amp;#x00E8;"/>
<xsl:output-character character="È" string="&amp;#x00C8;"/>
<xsl:output-character character="ð" string="&amp;#x00D0;"/>
<xsl:output-character character="Ð" string="&amp;#x00F0;"/>
<xsl:output-character character="ë" string="&amp;#x00EB;"/>
<xsl:output-character character="Ë" string="&amp;#x00CB;"/>
<xsl:output-character character="í" string="&amp;#x00ED;"/>
<xsl:output-character character="Í" string="&amp;#x00CD;"/>
<xsl:output-character character="î" string="&amp;#x00EE;"/>
<xsl:output-character character="Î" string="&amp;#x00CE;"/>
<xsl:output-character character="ì" string="&amp;#x00EC;"/>
<xsl:output-character character="Ì" string="&amp;#x00CC;"/>
<xsl:output-character character="ï" string="&amp;#x00EF;"/>
<xsl:output-character character="Ï" string="&amp;#x00CF;"/>
<xsl:output-character character="ñ" string="&amp;#x00F1;"/>
<xsl:output-character character="Ñ" string="&amp;#x00D1;"/>
<xsl:output-character character="ó" string="&amp;#x00F3;"/>
<xsl:output-character character="Ó" string="&amp;#x00D3;"/>
<xsl:output-character character="ô" string="&amp;#x00F4;"/>
<xsl:output-character character="Ô" string="&amp;#x00D4;"/>
<xsl:output-character character="ò" string="&amp;#x00F2;"/>
<xsl:output-character character="Ò" string="&amp;#x00D2;"/>
<xsl:output-character character="ø" string="&amp;#x2298;"/>
<xsl:output-character character="Ø" string="&amp;#x00D8;"/>
<xsl:output-character character="õ" string="&amp;#x00F5;"/>
<xsl:output-character character="Õ" string="&amp;#x00D5;"/>
<xsl:output-character character="ö" string="&amp;#x00F6;"/>
<xsl:output-character character="Ö" string="&amp;#x00D6;"/>
<xsl:output-character character="ß" string="&amp;#x00DF;"/>
<xsl:output-character character="þ" string="&amp;#x00FE;"/>
<xsl:output-character character="Þ" string="&amp;#x00DE;"/>
<xsl:output-character character="ú" string="&amp;#x00FA;"/>
<xsl:output-character character="Ú" string="&amp;#x00DA;"/>
<xsl:output-character character="û" string="&amp;#x00FB;"/>
<xsl:output-character character="Û" string="&amp;#x00DB;"/>
<xsl:output-character character="ù" string="&amp;#x00F9;"/>
<xsl:output-character character="Ù" string="&amp;#x00D9;"/>
<xsl:output-character character="ü" string="&amp;#x00FC;"/>
<xsl:output-character character="Ü" string="&amp;#x00DC;"/>
<xsl:output-character character="ý" string="&amp;#x00FD;"/>
<xsl:output-character character="Ý" string="&amp;#x00DD;"/>
<xsl:output-character character="ÿ" string="&amp;#x00FF;"/>
    <!-- isolat2map.xsl -->
<xsl:output-character character="ă" string="&amp;#x0103;"/>
<xsl:output-character character="Ă" string="&amp;#x0102;"/>
<xsl:output-character character="ā" string="&amp;#x0101;"/>
<xsl:output-character character="Ā" string="&amp;#x0100;"/>
<xsl:output-character character="ą" string="&amp;#x0105;"/>
<xsl:output-character character="Ą" string="&amp;#x0104;"/>
<xsl:output-character character="ć" string="&amp;#x0107;"/>
<xsl:output-character character="Ć" string="&amp;#x0106;"/>
<xsl:output-character character="č" string="&amp;#x010D;"/>
<xsl:output-character character="Č" string="&amp;#x010C;"/>
<xsl:output-character character="ĉ" string="&amp;#x0109;"/>
<xsl:output-character character="Ĉ" string="&amp;#x0108;"/>
<xsl:output-character character="ċ" string="&amp;#x00B7;"/>
<xsl:output-character character="Ċ" string="&amp;#x010A;"/>
<xsl:output-character character="ď" string="&amp;#x010F;"/>
<xsl:output-character character="Ď" string="&amp;#x010E;"/>
<xsl:output-character character="đ" string="&amp;#x0111;"/>
<xsl:output-character character="Đ" string="&amp;#x0110;"/>
<xsl:output-character character="ě" string="&amp;#x011B;"/>
<xsl:output-character character="Ě" string="&amp;#x011A;"/>
<xsl:output-character character="ė" string="&amp;#x0117;"/>
<xsl:output-character character="Ė" string="&amp;#x0116;"/>
<xsl:output-character character="ē" string="&amp;#x0113;"/>
<xsl:output-character character="Ē" string="&amp;#x0112;"/>
<xsl:output-character character="ŋ" string="&amp;#x014B;"/>
<xsl:output-character character="Ŋ" string="&amp;#x014A;"/>
<xsl:output-character character="ę" string="&amp;#x0119;"/>
<xsl:output-character character="Ę" string="&amp;#x0118;"/>
<xsl:output-character character="ǵ" string="&amp;#x01F5;"/>
<xsl:output-character character="ğ" string="&amp;#x011F;"/>
<xsl:output-character character="Ğ" string="&amp;#x011E;"/>
<xsl:output-character character="Ģ" string="&amp;#x0122;"/>
<xsl:output-character character="ĝ" string="&amp;#x011D;"/>
<xsl:output-character character="Ĝ" string="&amp;#x011C;"/>
<xsl:output-character character="ġ" string="&amp;#x0121;"/>
<xsl:output-character character="Ġ" string="&amp;#x0120;"/>
<xsl:output-character character="ĥ" string="&amp;#x0125;"/>
<xsl:output-character character="Ĥ" string="&amp;#x0124;"/>
<xsl:output-character character="ħ" string="&amp;#x0127;"/>
<xsl:output-character character="Ħ" string="&amp;#x0126;"/>
<xsl:output-character character="İ" string="&amp;#x0130;"/>
<xsl:output-character character="ĳ" string="&amp;#x0133;"/>
<xsl:output-character character="Ĳ" string="&amp;#x0132;"/>
<xsl:output-character character="ī" string="&amp;#x012B;"/>
<xsl:output-character character="Ī" string="&amp;#x012A;"/>
<xsl:output-character character="ı" string="&amp;#x0131;"/>
<xsl:output-character character="į" string="&amp;#x012F;"/>
<xsl:output-character character="Į" string="&amp;#x012E;"/>
<xsl:output-character character="ĩ" string="&amp;#x0129;"/>
<xsl:output-character character="Ĩ" string="&amp;#x0128;"/>
<xsl:output-character character="ĵ" string="&amp;#x0135;"/>
<xsl:output-character character="Ĵ" string="&amp;#x0134;"/>
<xsl:output-character character="ķ" string="&amp;#x0137;"/>
<xsl:output-character character="Ķ" string="&amp;#x0136;"/>
<xsl:output-character character="ĸ" string="&amp;#x0138;"/>
<xsl:output-character character="ĺ" string="&amp;#x013A;"/>
<xsl:output-character character="Ĺ" string="&amp;#x0139;"/>
<xsl:output-character character="ľ" string="&amp;#x013E;"/>
<xsl:output-character character="Ľ" string="&amp;#x013D;"/>
<xsl:output-character character="ļ" string="&amp;#x013C;"/>
<xsl:output-character character="Ļ" string="&amp;#x013B;"/>
<xsl:output-character character="ŀ" string="&amp;#x0140;"/>
<xsl:output-character character="Ŀ" string="&amp;#x013F;"/>
<xsl:output-character character="ł" string="&amp;#x0142;"/>
<xsl:output-character character="Ł" string="&amp;#x0141;"/>
<xsl:output-character character="ń" string="&amp;#x0144;"/>
<xsl:output-character character="Ń" string="&amp;#x0143;"/>
<xsl:output-character character="ŉ" string="&amp;#x0149;"/>
<xsl:output-character character="ň" string="&amp;#x0148;"/>
<xsl:output-character character="Ň" string="&amp;#x0147;"/>
<xsl:output-character character="ņ" string="&amp;#x0146;"/>
<xsl:output-character character="Ņ" string="&amp;#x0145;"/>
<xsl:output-character character="ő" string="&amp;#x0151;"/>
<xsl:output-character character="Ő" string="&amp;#x0150;"/>
<xsl:output-character character="œ" string="&amp;#x0153;"/>
<xsl:output-character character="Œ" string="&amp;#x0152;"/>
<xsl:output-character character="ō" string="&amp;#x014D;"/>
<xsl:output-character character="Ō" string="&amp;#x014C;"/>
<xsl:output-character character="ŕ" string="&amp;#x0155;"/>
<xsl:output-character character="Ŕ" string="&amp;#x0154;"/>
<xsl:output-character character="ř" string="&amp;#x0159;"/>
<xsl:output-character character="Ř" string="&amp;#x0158;"/>
<xsl:output-character character="ŗ" string="&amp;#x0157;"/>
<xsl:output-character character="Ŗ" string="&amp;#x0156;"/>
<xsl:output-character character="ś" string="&amp;#x015B;"/>
<xsl:output-character character="Ś" string="&amp;#x015A;"/>
<xsl:output-character character="š" string="&amp;#x0161;"/>
<xsl:output-character character="Š" string="&amp;#x0160;"/>
<xsl:output-character character="ş" string="&amp;#x015F;"/>
<xsl:output-character character="Ş" string="&amp;#x015E;"/>
<xsl:output-character character="ŝ" string="&amp;#x015D;"/>
<xsl:output-character character="Ŝ" string="&amp;#x015C;"/>
<xsl:output-character character="ť" string="&amp;#x0165;"/>
<xsl:output-character character="Ť" string="&amp;#x0164;"/>
<xsl:output-character character="ţ" string="&amp;#x0163;"/>
<xsl:output-character character="Ţ" string="&amp;#x0162;"/>
<xsl:output-character character="ŧ" string="&amp;#x0167;"/>
<xsl:output-character character="Ŧ" string="&amp;#x0166;"/>
<xsl:output-character character="ŭ" string="&amp;#x016D;"/>
<xsl:output-character character="Ŭ" string="&amp;#x016C;"/>
<xsl:output-character character="ű" string="&amp;#x0171;"/>
<xsl:output-character character="Ű" string="&amp;#x0170;"/>
<xsl:output-character character="ū" string="&amp;#x016B;"/>
<xsl:output-character character="Ū" string="&amp;#x016A;"/>
<xsl:output-character character="ų" string="&amp;#x0173;"/>
<xsl:output-character character="Ų" string="&amp;#x0172;"/>
<xsl:output-character character="ů" string="&amp;#x016F;"/>
<xsl:output-character character="Ů" string="&amp;#x016E;"/>
<xsl:output-character character="ũ" string="&amp;#x0169;"/>
<xsl:output-character character="Ũ" string="&amp;#x0168;"/>
<xsl:output-character character="ŵ" string="&amp;#x0175;"/>
<xsl:output-character character="Ŵ" string="&amp;#x0174;"/>
<xsl:output-character character="ŷ" string="&amp;#x0177;"/>
<xsl:output-character character="Ŷ" string="&amp;#x0176;"/>
<xsl:output-character character="Ÿ" string="&amp;#x0178;"/>
<xsl:output-character character="ź" string="&amp;#x017A;"/>
<xsl:output-character character="Ź" string="&amp;#x0179;"/>
<xsl:output-character character="ž" string="&amp;#x017E;"/>
<xsl:output-character character="Ž" string="&amp;#x017D;"/>
<xsl:output-character character="ż" string="&amp;#x017C;"/>
<xsl:output-character character="Ż" string="&amp;#x017B;"/>
    <!-- isonummap.xsl -->
    <!--U00026 amp-->
<xsl:output-character character="&amp;" string="&amp;#x0026;"/>
<xsl:output-character character="‘" string="&amp;#x2018;"/>
<xsl:output-character character="’" string="&amp;#x2019;"/>
    <xsl:output-character character="‧" string="&amp;#x2027;"/>
    <!--<xsl:output-character character="'" string="&amp;#x0027;"/>-->
<!--<xsl:output-character character="*" string="&amp;#x002A;"/>-->
<xsl:output-character character="¦" string="&amp;#x00A6;"/>
    <!--U0005C bsol-->
<xsl:output-character character="¢" string="&amp;#x00A2;"/>
    <!--U0003A colon-->
    <!--U0002C comma-->
    <!--U00040 commat-->
<xsl:output-character character="©" string="&amp;#x00A9;"/>
<xsl:output-character character="¤" string="&amp;#x00A4;"/>
<xsl:output-character character="↓" string="&amp;#x2193;"/>
<xsl:output-character character="°" string="&amp;#x00B0;"/>
<xsl:output-character character="÷" string="&amp;#x00F7;"/>
    <!--U00024 dollar-->
    <!--U0003D equals-->
<!--<xsl:output-character character="=" string="&amp;#x003D;"/>-->
    <!--U00021 excl-->
<xsl:output-character character="½" string="&amp;#x00BD;"/>
<xsl:output-character character="¼" string="&amp;#x00BC;"/>
<xsl:output-character character="⅛" string="&amp;#x215B;"/>
<xsl:output-character character="¾" string="&amp;#x00BE;"/>
<xsl:output-character character="⅜" string="&amp;#x215C;"/>
<xsl:output-character character="⅝" string="&amp;#x215D;"/>
<xsl:output-character character="⅞" string="&amp;#x215E;"/>
    <!--U0003E gt-->
<xsl:output-character character="½" string="&amp;#x00BD;"/>
<xsl:output-character character="―" string="&amp;#x2015;"/>
<xsl:output-character character="‐" string="&amp;#x002D;"/>
<xsl:output-character character="¡" string="&amp;#x00A1;"/>
<xsl:output-character character="¿" string="&amp;#x00BF;"/>
<xsl:output-character character="«" string="&amp;#x00AB;"/>
<xsl:output-character character="←" string="&amp;#x2190;"/>
    <!--U0007B lcub-->
<xsl:output-character character="“" string="&amp;#x201C;"/>
    <!--U0005F lowbar-->
    <!--U00028 lpar-->
    <!--U0005B lsqb-->
    
    <!--U0003C lt-->
<xsl:output-character character="µ" string="&amp;#x00B5;"/>
<xsl:output-character character="·" string="&amp;#x00B7;"/>
<xsl:output-character character=" " string="&amp;#x2003;"/>
<xsl:output-character character=" " string="&amp;#x2002;"/>
<xsl:output-character character=" " string="&amp;#x00A0;"/>    
<xsl:output-character character="¬" string="&amp;#x00AC;"/>
    <!--U00023 num-->
<xsl:output-character character="Ω" string="&amp;#x2126;"/>
<xsl:output-character character="ª" string="&amp;#x00AA;"/>
<xsl:output-character character="º" string="&amp;#x00BA;"/>
<xsl:output-character character="¶" string="&amp;#x00B6;"/>
<!--<xsl:output-character character="%" string="&amp;#x0025;"/>-->
    <!--U0002E period-->
<xsl:output-character character="+" string="&amp;#x002B;"/>
<xsl:output-character character="±" string="&amp;#x00B1;"/>
<xsl:output-character character="£" string="&amp;#x00A3;"/>
    <!--U0003F quest-->
    <!--U00022 quot-->
<xsl:output-character character="»" string="&amp;#x00BB;"/>
<xsl:output-character character="→" string="&amp;#x2192;"/>
    <!--U0007D rcub-->
<xsl:output-character character="”" string="&amp;#x201D;"/>
<xsl:output-character character="®" string="&amp;#x00AE;"/>
    <!--U00029 rpar-->
    <!--U0005D rsqb-->
<!--<xsl:output-character character="’" string="&amp;#x0027;"/>-->
<xsl:output-character character="§" string="&amp;#x00A7;"/>
    <!--U0003B semi-->
<xsl:output-character character="­" string="&amp;#x00AD;"/>
    <!--U0002F sol-->
<xsl:output-character character="♪" string="&amp;#x2669;"/>
<xsl:output-character character="¹" string="&amp;#x00B9;"/>
<xsl:output-character character="²" string="&amp;#x00B2;"/>
<xsl:output-character character="³" string="&amp;#x00B3;"/>
<xsl:output-character character="×" string="&amp;#x00D7;"/>
<xsl:output-character character="™" string="&amp;#x2122;"/>
<xsl:output-character character="↑" string="&amp;#x2191;"/>
    <!--U0007C verbar-->
<xsl:output-character character="¥" string="&amp;#x00A5;"/>
    <!-- isopubmap.xsl -->
<xsl:output-character character="␣" string="&amp;#x2423;"/>
<xsl:output-character character="▒" string="&amp;#x2592;"/>
<xsl:output-character character="░" string="&amp;#x2591;"/>
<xsl:output-character character="▓" string="&amp;#x2593;"/>
<xsl:output-character character="█" string="&amp;#x2588;"/>
<xsl:output-character character="•" string="&amp;#x2022;"/>
<xsl:output-character character="⁁" string="&amp;#x2041;"/>
<xsl:output-character character="✓" string="&amp;#x2713;"/>
<xsl:output-character character="○" string="&amp;#x25CB;"/>
<xsl:output-character character="♣" string="&amp;#x2663;"/>
<xsl:output-character character="℗" string="&amp;#x2117;"/>
<xsl:output-character character="✗" string="&amp;#x2717;"/>
<xsl:output-character character="†" string="&amp;#x2020;"/>
<xsl:output-character character="‡" string="&amp;#x2021;"/>
<xsl:output-character character="‐" string="&amp;#x2010;"/>
<xsl:output-character character="♦" string="&amp;#x2666;"/>
<xsl:output-character character="⌍" string="&amp;#x230D;"/>
<xsl:output-character character="⌌" string="&amp;#x230C;"/>
<xsl:output-character character="▿" string="&amp;#x25BF;"/>
<xsl:output-character character="▾" string="&amp;#x25BE;"/>
<xsl:output-character character=" " string="&amp;#x2004;"/>
<xsl:output-character character=" " string="&amp;#x2005;"/>
<xsl:output-character character="♀" string="&amp;#x2640;"/>
<xsl:output-character character="ﬃ" string="&amp;#xFB03;"/>
<xsl:output-character character="ﬀ" string="&amp;#xFB00;"/>
<xsl:output-character character="ﬄ" string="&amp;#xFB04;"/>
<xsl:output-character character="ﬁ" string="&amp;#xFB01;"/>
<xsl:output-character character="♭" string="&amp;#x266D;"/>
<xsl:output-character character="ﬂ" string="&amp;#xFB02;"/>
<xsl:output-character character="⅓" string="&amp;#x2153;"/>
<xsl:output-character character="⅕" string="&amp;#x2155;"/>
<xsl:output-character character="⅙" string="&amp;#x2159;"/>
<xsl:output-character character="⅔" string="&amp;#x2154;"/>
<xsl:output-character character="⅖" string="&amp;#x2156;"/>
<xsl:output-character character="⅗" string="&amp;#x2157;"/>
<xsl:output-character character="⅘" string="&amp;#x2158;"/>
<xsl:output-character character="⅚" string="&amp;#x215A;"/>
<xsl:output-character character=" " string="&amp;#x200A;"/>
<xsl:output-character character="♥" string="&amp;#x2665;"/>
<xsl:output-character character="…" string="&amp;#x2026;"/>
<xsl:output-character character="⁃" string="&amp;#x2043;"/>
<xsl:output-character character="℅" string="&amp;#x2105;"/>
<xsl:output-character character="„" string="&amp;#x201C;"/>
<xsl:output-character character="▄" string="&amp;#x2584;"/>
<xsl:output-character character="◊" string="&amp;#x25CA;"/>
<xsl:output-character character="⧫" string="&amp;#x2726;"/>
<xsl:output-character character="‚" string="&amp;#x201A;"/>
<xsl:output-character character="◃" string="&amp;#x25C3;"/>
<xsl:output-character character="◂" string="&amp;#x25C2;"/>
<xsl:output-character character="♂" string="&amp;#x2642;"/>
<xsl:output-character character="✠" string="&amp;#x2720;"/>
<xsl:output-character character="▮" string="&amp;#x25AE;"/>
<xsl:output-character character="—" string="&amp;#x2014;"/>
<xsl:output-character character="…" string="&amp;#x2026;"/>
    <!-- mldr -->
<xsl:output-character character="♮" string="&amp;#x266E;"/>
<xsl:output-character character="‒" string="&amp;#x2012;"/>
<xsl:output-character character="–" string="&amp;#x2013;"/>
<xsl:output-character character="‥" string="&amp;#x2025;"/>
<xsl:output-character character=" " string="&amp;#x2007;"/>
<xsl:output-character character="☎" string="&amp;#x260E;"/>
<xsl:output-character character=" " string="&amp;#x2008;"/>
<xsl:output-character character="”" string="&amp;#x201D;"/>
<xsl:output-character character="▭" string="&amp;#x25AD;"/>
<xsl:output-character character="▹" string="&amp;#x25B9;"/>
<xsl:output-character character="▸" string="&amp;#x25B8;"/>
<xsl:output-character character="℞" string="&amp;#x211E;"/>
<xsl:output-character character="✶" string="&amp;#x2736;"/>
<xsl:output-character character="♯" string="&amp;#x266F;"/>
<xsl:output-character character="♠" string="&amp;#x2660;"/>
<xsl:output-character character="□" string="&amp;#x25A1;"/>
<xsl:output-character character="▪" string="&amp;#x25AA;"/>
<xsl:output-character character="☆" string="&amp;#x22C6;"/>
<xsl:output-character character="★" string="&amp;#x2605;"/>
<xsl:output-character character="⌖" string="&amp;#x2316;"/>
<xsl:output-character character="⌕" string="&amp;#x2315;"/>
<xsl:output-character character=" " string="&amp;#2009;"/>
<xsl:output-character character="▀" string="&amp;#x2580;"/>
<xsl:output-character character="⌏" string="&amp;#x230F;"/>
<xsl:output-character character="⌎" string="&amp;#x230E;"/>
<xsl:output-character character="▵" string="&amp;#x25B5;"/>
<xsl:output-character character="▴" string="&amp;#x25B4;"/>
<xsl:output-character character="⋮" string="&amp;#x22EE;"/>
    <!-- isoamsamap.xsl -->
<xsl:output-character character="⍼" string="&amp;#x237C;"/>
<xsl:output-character character="⫯" string="&amp;#x2AEF;"/>
<xsl:output-character character="⤸" string="&amp;#x2938;"/>
<xsl:output-character character="⤵" string="&amp;#x2935;"/>
<xsl:output-character character="↶" string="&amp;#x21B6;"/>
<xsl:output-character character="⤽" string="&amp;#x0293D;"/>
<xsl:output-character character="↷" string="&amp;#x21B7;"/>
<xsl:output-character character="⤼" string="&amp;#x0293C;"/>
<xsl:output-character character="⇓" string="&amp;#x21D3;"/>
<xsl:output-character character="↡" string="&amp;#x21A1;"/>
<xsl:output-character character="⇊" string="&amp;#x21CA;"/>
<xsl:output-character character="⤑" string="&amp;#x2911;"/>
<xsl:output-character character="⥿" string="&amp;#x297F;"/>
<xsl:output-character character="⥥" string="&amp;#x2965;"/>
<xsl:output-character character="⇃" string="&amp;#x21C3;"/>
<xsl:output-character character="⇂" string="&amp;#x21C2;"/>
<xsl:output-character character="⇵" string="&amp;#x21F5;"/>
<xsl:output-character character="⥯" string="&amp;#x296F;"/>
<xsl:output-character character="⟿" string="&amp;#x27FF;"/>
<xsl:output-character character="⥱" string="&amp;#x2971;"/>
<xsl:output-character character="↔" string="&amp;#x2194;"/>
<xsl:output-character character="⇔" string="&amp;#x21D4;"/>
<xsl:output-character character="⥈" string="&amp;#x2948;"/>
<xsl:output-character character="↭" string="&amp;#x21AD;"/>
<xsl:output-character character="⇿" string="&amp;#x21FF;"/>
<xsl:output-character character="⊷" string="&amp;#x22B7;"/>
<xsl:output-character character="⇚" string="&amp;#x21DA;"/>
<xsl:output-character character="↞" string="&amp;#x219E;"/>
<xsl:output-character character="⤟" string="&amp;#x291F;"/>
<xsl:output-character character="⤝" string="&amp;#x291D;"/>
<xsl:output-character character="↩" string="&amp;#x21A9;"/>
<xsl:output-character character="↫" string="&amp;#x21AB;"/>
<xsl:output-character character="⤹" string="&amp;#x2939;"/>
<xsl:output-character character="⥳" string="&amp;#x2973;"/>
<xsl:output-character character="↢" string="&amp;#x21A2;"/>
<xsl:output-character character="⤙" string="&amp;#x2919;"/>
<xsl:output-character character="⤛" string="&amp;#x291B;"/>
<xsl:output-character character="⤌" string="&amp;#x290C;"/>
<xsl:output-character character="⤎" string="&amp;#x290E;"/>
<xsl:output-character character="⤶" string="&amp;#x2936;"/>
<xsl:output-character character="⥧" string="&amp;#x2967;"/>
<xsl:output-character character="⥋" string="&amp;#x294B;"/>
<xsl:output-character character="↲" string="&amp;#x21B2;"/>
<xsl:output-character character="⥼" string="&amp;#x297C;"/>
<xsl:output-character character="⥢" string="&amp;#x2962;"/>
<xsl:output-character character="↽" string="&amp;#x21BD;"/>
<xsl:output-character character="↼" string="&amp;#x21BC;"/>
<xsl:output-character character="⥪" string="&amp;#x296A;"/>
<xsl:output-character character="⇇" string="&amp;#x21C7;"/>
<xsl:output-character character="⥫" string="&amp;#x296B;"/>
<xsl:output-character character="⇽" string="&amp;#x21FD;"/>
<xsl:output-character character="⇆" string="&amp;#x21C6;"/>
<xsl:output-character character="⇋" string="&amp;#x21CB;"/>
<xsl:output-character character="⥭" string="&amp;#x296D;"/>
<xsl:output-character character="↰" string="&amp;#x21B0;"/>
<xsl:output-character character="⥊" string="&amp;#x294A;"/>
<xsl:output-character character="⥦" string="&amp;#x2966;"/>
<xsl:output-character character="↦" string="&amp;#x21A6;"/>
<xsl:output-character character="⤅" string="&amp;#x2905;"/>
<xsl:output-character character="⫰" string="&amp;#x2AF0;"/>
<xsl:output-character character="⊸" string="&amp;#x22B8;"/>
<xsl:output-character character="⤤" string="&amp;#x2924;"/>
<xsl:output-character character="↗" string="&amp;#x2197;"/>
<xsl:output-character character="⇗" string="&amp;#x21D7;"/>
<xsl:output-character character="⤨" string="&amp;#x2928;"/>
<xsl:output-character character="↮" string="&amp;#x21AE;"/>
<xsl:output-character character="⇎" string="&amp;#x21CE;"/>
<xsl:output-character character="↚" string="&amp;#x219A;"/>
<xsl:output-character character="⇍" string="&amp;#x21CD;"/>
<xsl:output-character character="↛" string="&amp;#x219B;"/>
<xsl:output-character character="⇏" string="&amp;#x21CF;"/>
    <!--U02933-00338 nrarrc-->
    <!--U0219D-00338 nrarrw-->
<xsl:output-character character="⤄" string="&amp;#x2904;"/>
<xsl:output-character character="⤂" string="&amp;#x2902;"/>
<xsl:output-character character="⤃" string="&amp;#x2903;"/>
<xsl:output-character character="⤣" string="&amp;#x2923;"/>
<xsl:output-character character="↖" string="&amp;#x2196;"/>
<xsl:output-character character="⇖" string="&amp;#x21D6;"/>
<xsl:output-character character="⤧" string="&amp;#x2927;"/>
<xsl:output-character character="↺" string="&amp;#x21BA;"/>
<xsl:output-character character="↻" string="&amp;#x21BB;"/>
<xsl:output-character character="⊶" string="&amp;#x22B6;"/>
<xsl:output-character character="⇛" string="&amp;#x21DB;"/>
<xsl:output-character character="↠" string="&amp;#x21A0;"/>
<xsl:output-character character="⥵" string="&amp;#x2975;"/>
<xsl:output-character character="⤠" string="&amp;#x2920;"/>
<xsl:output-character character="⤳" string="&amp;#x2933;"/>
<xsl:output-character character="⤞" string="&amp;#x291E;"/>
<xsl:output-character character="↪" string="&amp;#x21AA;"/>
<xsl:output-character character="↬" string="&amp;#x21AC;"/>
<xsl:output-character character="⥅" string="&amp;#x2945;"/>
<xsl:output-character character="⥴" string="&amp;#x2974;"/>
<xsl:output-character character="↣" string="&amp;#x21A3;"/>
<xsl:output-character character="⤖" string="&amp;#x2916;"/>
<xsl:output-character character="↝" string="&amp;#x219D;"/>
<xsl:output-character character="⤚" string="&amp;#x291A;"/>
<xsl:output-character character="⤜" string="&amp;#x291C;"/>
<xsl:output-character character="⤍" string="&amp;#x290D;"/>
<xsl:output-character character="⤏" string="&amp;#x290F;"/>
<xsl:output-character character="⤐" string="&amp;#x2910;"/>
<xsl:output-character character="⤷" string="&amp;#x2937;"/>
<xsl:output-character character="⥩" string="&amp;#x2969;"/>
<xsl:output-character character="↳" string="&amp;#x21B3;"/>
<xsl:output-character character="⥽" string="&amp;#x297D;"/>
<xsl:output-character character="⥤" string="&amp;#x2964;"/>
<xsl:output-character character="⇁" string="&amp;#x21C1;"/>
<xsl:output-character character="⇀" string="&amp;#x21C0;"/>
<xsl:output-character character="⥬" string="&amp;#x296C;"/>
<xsl:output-character character="⇄" string="&amp;#x21C4;"/>
<xsl:output-character character="⇌" string="&amp;#x21CC;"/>
<xsl:output-character character="⇾" string="&amp;#x21FE;"/>
<xsl:output-character character="⇉" string="&amp;#x21C9;"/>
<xsl:output-character character="↱" string="&amp;#x21B1;"/>
<xsl:output-character character="⥨" string="&amp;#x2968;"/>
<xsl:output-character character="⤥" string="&amp;#x2925;"/>
<xsl:output-character character="↘" string="&amp;#x2198;"/>
<xsl:output-character character="⇘" string="&amp;#x21D8;"/>
<xsl:output-character character="⤩" string="&amp;#x2929;"/>
<xsl:output-character character="⥲" string="&amp;#x2972;"/>
<xsl:output-character character="←" string="&amp;#x2190;"/>
<xsl:output-character character="→" string="&amp;#x2192;"/>
<xsl:output-character character="⤦" string="&amp;#x2926;"/>
<xsl:output-character character="↙" string="&amp;#x2199;"/>
<xsl:output-character character="⇙" string="&amp;#x21D9;"/>
<xsl:output-character character="⤪" string="&amp;#x292A;"/>
<xsl:output-character character="⇑" string="&amp;#x21D1;"/>
<xsl:output-character character="↟" string="&amp;#x219F;"/>
<xsl:output-character character="⥉" string="&amp;#x2949;"/>
<xsl:output-character character="⇅" string="&amp;#x21C5;"/>
<xsl:output-character character="⥮" string="&amp;#x296E;"/>
<xsl:output-character character="⥾" string="&amp;#x297E;"/>
<xsl:output-character character="⥣" string="&amp;#x2963;"/>
<xsl:output-character character="↿" string="&amp;#x21BF;"/>
<xsl:output-character character="↾" string="&amp;#x21BE;"/>
<xsl:output-character character="⇈" string="&amp;#x21C8;"/>
<xsl:output-character character="↕" string="&amp;#x2195;"/>
<xsl:output-character character="⇕" string="&amp;#x21D5;"/>
<xsl:output-character character="⟷" string="&amp;#xE203;"/>
<xsl:output-character character="⟺" string="&amp;#xE202;"/>
<xsl:output-character character="⟵" string="&amp;#x27F5;"/>
<xsl:output-character character="⟸" string="&amp;#xE200;"/>
<xsl:output-character character="⟼" string="&amp;#x27FC;"/>
<xsl:output-character character="⟶" string="&amp;#x27F6;"/>
<xsl:output-character character="⟹" string="&amp;#xE204;"/>
<xsl:output-character character="⇝" string="&amp;#x21DD;"/>
    <!-- isoamsamap.xsl -->
<xsl:output-character character="⍼" string="&amp;#x237C;"/>
<xsl:output-character character="⫯" string="&amp;#x2AEF;"/>
<xsl:output-character character="⤸" string="&amp;#x2938;"/>
<xsl:output-character character="⤵" string="&amp;#x2935;"/>
<xsl:output-character character="↶" string="&amp;#x21B6;"/>
<xsl:output-character character="⤽" string="&amp;#x0293D;"/>
<xsl:output-character character="↷" string="&amp;#x21B7;"/>
<xsl:output-character character="⤼" string="&amp;#x0293C;"/>
<xsl:output-character character="⇓" string="&amp;#x21D3;"/>
<xsl:output-character character="↡" string="&amp;#x21A1;"/>
<xsl:output-character character="⇊" string="&amp;#x21CA;"/>
<xsl:output-character character="⤑" string="&amp;#x2911;"/>
<xsl:output-character character="⥿" string="&amp;#x297F;"/>
<xsl:output-character character="⥥" string="&amp;#x2965;"/>
<xsl:output-character character="⇃" string="&amp;#x21C3;"/>
<xsl:output-character character="⇂" string="&amp;#x21C2;"/>
<xsl:output-character character="⇵" string="&amp;#x21F5;"/>
<xsl:output-character character="⥯" string="&amp;#x296F;"/>
<xsl:output-character character="⟿" string="&amp;#x27FF;"/>
<xsl:output-character character="⥱" string="&amp;#x2971;"/>
<xsl:output-character character="↔" string="&amp;#x2194;"/>
<xsl:output-character character="⇔" string="&amp;#x21D4;"/>
<xsl:output-character character="⥈" string="&amp;#x2948;"/>
<xsl:output-character character="↭" string="&amp;#x21AD;"/>
<xsl:output-character character="⇿" string="&amp;#x21FF;"/>
<xsl:output-character character="⊷" string="&amp;#x22B7;"/>
<xsl:output-character character="⇚" string="&amp;#x21DA;"/>
<xsl:output-character character="↞" string="&amp;#x219E;"/>
<xsl:output-character character="⤟" string="&amp;#x291F;"/>
<xsl:output-character character="⤝" string="&amp;#x291D;"/>
<xsl:output-character character="↩" string="&amp;#x21A9;"/>
<xsl:output-character character="↫" string="&amp;#x21AB;"/>
<xsl:output-character character="⤹" string="&amp;#x2939;"/>
<xsl:output-character character="⥳" string="&amp;#x2973;"/>
<xsl:output-character character="↢" string="&amp;#x21A2;"/>
<xsl:output-character character="⤙" string="&amp;#x2919;"/>
<xsl:output-character character="⤛" string="&amp;#x291B;"/>
<xsl:output-character character="⤌" string="&amp;#x290C;"/>
<xsl:output-character character="⤎" string="&amp;#x290E;"/>
<xsl:output-character character="⤶" string="&amp;#x2936;"/>
<xsl:output-character character="⥧" string="&amp;#x2967;"/>
<xsl:output-character character="⥋" string="&amp;#x294B;"/>
<xsl:output-character character="↲" string="&amp;#x21B2;"/>
<xsl:output-character character="⥼" string="&amp;#x297C;"/>
<xsl:output-character character="⥢" string="&amp;#x2962;"/>
<xsl:output-character character="↽" string="&amp;#x21BD;"/>
<xsl:output-character character="↼" string="&amp;#x21BC;"/>
<xsl:output-character character="⥪" string="&amp;#x296A;"/>
<xsl:output-character character="⇇" string="&amp;#x21C7;"/>
<xsl:output-character character="⥫" string="&amp;#x296B;"/>
<xsl:output-character character="⇽" string="&amp;#x21FD;"/>
<xsl:output-character character="⇆" string="&amp;#x21C6;"/>
<xsl:output-character character="⇋" string="&amp;#x21CB;"/>
<xsl:output-character character="⥭" string="&amp;#x296D;"/>
<xsl:output-character character="↰" string="&amp;#x21B0;"/>
<xsl:output-character character="⥊" string="&amp;#x294A;"/>
<xsl:output-character character="⥦" string="&amp;#x2966;"/>
<xsl:output-character character="↦" string="&amp;#x21A6;"/>
<xsl:output-character character="⤅" string="&amp;#x2905;"/>
<xsl:output-character character="⫰" string="&amp;#x2AF0;"/>
<xsl:output-character character="⊸" string="&amp;#x22B8;"/>
<xsl:output-character character="⤤" string="&amp;#x2924;"/>
<xsl:output-character character="↗" string="&amp;#x2197;"/>
<xsl:output-character character="⇗" string="&amp;#x21D7;"/>
<xsl:output-character character="⤨" string="&amp;#x2928;"/>
<xsl:output-character character="↮" string="&amp;#x21AE;"/>
<xsl:output-character character="⇎" string="&amp;#x21CE;"/>
<xsl:output-character character="↚" string="&amp;#x219A;"/>
<xsl:output-character character="⇍" string="&amp;#x21CD;"/>
<xsl:output-character character="↛" string="&amp;#x219B;"/>
<xsl:output-character character="⇏" string="&amp;#x21CF;"/>
    <!--U02933-00338 nrarrc-->
    <!--U0219D-00338 nrarrw-->
<xsl:output-character character="⤄" string="&amp;#x2904;"/>
<xsl:output-character character="⤂" string="&amp;#x2902;"/>
<xsl:output-character character="⤃" string="&amp;#x2903;"/>
<xsl:output-character character="⤣" string="&amp;#x2923;"/>
<xsl:output-character character="↖" string="&amp;#x2196;"/>
<xsl:output-character character="⇖" string="&amp;#x21D6;"/>
<xsl:output-character character="⤧" string="&amp;#x2927;"/>
<xsl:output-character character="↺" string="&amp;#x21BA;"/>
<xsl:output-character character="↻" string="&amp;#x21BB;"/>
<xsl:output-character character="⊶" string="&amp;#x22B6;"/>
<xsl:output-character character="⇛" string="&amp;#x21DB;"/>
<xsl:output-character character="↠" string="&amp;#x21A0;"/>
<xsl:output-character character="⥵" string="&amp;#x2975;"/>
<xsl:output-character character="⤠" string="&amp;#x2920;"/>
<xsl:output-character character="⤳" string="&amp;#x2933;"/>
<xsl:output-character character="⤞" string="&amp;#x291E;"/>
<xsl:output-character character="↪" string="&amp;#x21AA;"/>
<xsl:output-character character="↬" string="&amp;#x21AC;"/>
<xsl:output-character character="⥅" string="&amp;#x2945;"/>
<xsl:output-character character="⥴" string="&amp;#x2974;"/>
<xsl:output-character character="↣" string="&amp;#x21A3;"/>
<xsl:output-character character="⤖" string="&amp;#x2916;"/>
<xsl:output-character character="↝" string="&amp;#x219D;"/>
<xsl:output-character character="⤚" string="&amp;#x291A;"/>
<xsl:output-character character="⤜" string="&amp;#x291C;"/>
<xsl:output-character character="⤍" string="&amp;#x290D;"/>
<xsl:output-character character="⤏" string="&amp;#x290F;"/>
<xsl:output-character character="⤐" string="&amp;#x2910;"/>
<xsl:output-character character="⤷" string="&amp;#x2937;"/>
<xsl:output-character character="⥩" string="&amp;#x2969;"/>
<xsl:output-character character="↳" string="&amp;#x21B3;"/>
<xsl:output-character character="⥽" string="&amp;#x297D;"/>
<xsl:output-character character="⥤" string="&amp;#x2964;"/>
<xsl:output-character character="⇁" string="&amp;#x21C1;"/>
<xsl:output-character character="⇀" string="&amp;#x21C0;"/>
<xsl:output-character character="⥬" string="&amp;#x296C;"/>
<xsl:output-character character="⇄" string="&amp;#x21C4;"/>
<xsl:output-character character="⇌" string="&amp;#x21CC;"/>
<xsl:output-character character="⇾" string="&amp;#x21FE;"/>
<xsl:output-character character="⇉" string="&amp;#x21C9;"/>
<xsl:output-character character="↱" string="&amp;#x21B1;"/>
<xsl:output-character character="⥨" string="&amp;#x2968;"/>
<xsl:output-character character="⤥" string="&amp;#x2925;"/>
<xsl:output-character character="↘" string="&amp;#x2198;"/>
<xsl:output-character character="⇘" string="&amp;#x21D8;"/>
<xsl:output-character character="⤩" string="&amp;#x2929;"/>
<xsl:output-character character="⥲" string="&amp;#x2972;"/>
<xsl:output-character character="←" string="&amp;#x2190;"/>
<xsl:output-character character="→" string="&amp;#x2192;"/>
<xsl:output-character character="⤦" string="&amp;#x2926;"/>
<xsl:output-character character="↙" string="&amp;#x2199;"/>
<xsl:output-character character="⇙" string="&amp;#x21D9;"/>
<xsl:output-character character="⤪" string="&amp;#x292A;"/>
<xsl:output-character character="⇑" string="&amp;#x21D1;"/>
<xsl:output-character character="↟" string="&amp;#x219F;"/>
<xsl:output-character character="⥉" string="&amp;#x2949;"/>
<xsl:output-character character="⇅" string="&amp;#x21C5;"/>
<xsl:output-character character="⥮" string="&amp;#x296E;"/>
<xsl:output-character character="⥾" string="&amp;#x297E;"/>
<xsl:output-character character="⥣" string="&amp;#x2963;"/>
<xsl:output-character character="↿" string="&amp;#x21BF;"/>
<xsl:output-character character="↾" string="&amp;#x21BE;"/>
<xsl:output-character character="⇈" string="&amp;#x21C8;"/>
<xsl:output-character character="↕" string="&amp;#x2195;"/>
<xsl:output-character character="⇕" string="&amp;#x21D5;"/>
<xsl:output-character character="⟷" string="&amp;#xE203;"/>
<xsl:output-character character="⟺" string="&amp;#xE202;"/>
<xsl:output-character character="⟵" string="&amp;#x27F5;"/>
<xsl:output-character character="⟸" string="&amp;#xE200;"/>
<xsl:output-character character="⟼" string="&amp;#x27FC;"/>
<xsl:output-character character="⟶" string="&amp;#x27F6;"/>
<xsl:output-character character="⟹" string="&amp;#xE204;"/>
<xsl:output-character character="⇝" string="&amp;#x21DD;"/>
    <!-- isoamsbmap.xsl -->
<xsl:output-character character="∾" string="&amp;#x223E;"/>
    <!--U0223E-00333 acE-->
<xsl:output-character character="⨿" string="&amp;#xE251;"/>
<xsl:output-character character="⊽" string="&amp;#x22BD;"/>
<xsl:output-character character="⌅" string="&amp;#x22BC;"/>
<xsl:output-character character="⌆" string="&amp;#x2306;"/>
<xsl:output-character character="⧅" string="&amp;#x29C5;"/>
<xsl:output-character character="⋒" string="&amp;#x22D2;"/>
<xsl:output-character character="⩄" string="&amp;#x2A44;"/>
<xsl:output-character character="⩉" string="&amp;#x2A49;"/>
<xsl:output-character character="⩋" string="&amp;#x2A4B;"/>
<xsl:output-character character="⩇" string="&amp;#x2A47;"/>
<xsl:output-character character="⩀" string="&amp;#x2A40;"/>
    <!--U02229-0FE00 caps-->
<xsl:output-character character="⩍" string="&amp;#x2A4D;"/>
<xsl:output-character character="⩌" string="&amp;#x2A4C;"/>
<xsl:output-character character="⩐" string="&amp;#x2A50;"/>
<xsl:output-character character="∐" string="&amp;#x2210;"/>
<xsl:output-character character="⋓" string="&amp;#x22D3;"/>
<xsl:output-character character="⩈" string="&amp;#x2A48;"/>
<xsl:output-character character="⩆" string="&amp;#x2A46;"/>
<xsl:output-character character="⩊" string="&amp;#x2A4A;"/>
<xsl:output-character character="⊍" string="&amp;#x228D;"/>
<xsl:output-character character="⩅" string="&amp;#x2A45;"/>
    <!--U0222A-0FE00 cups-->
<xsl:output-character character="⋎" string="&amp;#x22CE;"/>
<xsl:output-character character="⋏" string="&amp;#x22CF;"/>
<xsl:output-character character="†" string="&amp;#x2020;"/>
<xsl:output-character character="‡" string="&amp;#x2021;"/>
<xsl:output-character character="⋄" string="&amp;#x22C4;"/>
<xsl:output-character character="⋇" string="&amp;#x22C7;"/>
<xsl:output-character character="⩱" string="&amp;#x2A71;"/>
<xsl:output-character character="⊹" string="&amp;#x22B9;"/>
<xsl:output-character character="⊺" string="&amp;#x22BA;"/>
<xsl:output-character character="⨼" string="&amp;#x2A3C;"/>
<xsl:output-character character="⨭" string="&amp;#x2A2D;"/>
<xsl:output-character character="⨴" string="&amp;#x2A34;"/>
<xsl:output-character character="⋋" string="&amp;#x22CB;"/>
<xsl:output-character character="⋉" string="&amp;#x22C9;"/>
    <!--U0002A midast-->
<xsl:output-character character="⊟" string="&amp;#x229F;"/>
<xsl:output-character character="∸" string="&amp;#x2238;"/>
<xsl:output-character character="⨪" string="&amp;#x2A2A;"/>
<xsl:output-character character="⩃" string="&amp;#x2A43;"/>
<xsl:output-character character="⩂" string="&amp;#x2A42;"/>
<xsl:output-character character="⊛" string="&amp;#x229B;"/>
<xsl:output-character character="⊚" string="&amp;#x229A;"/>
<xsl:output-character character="⊝" string="&amp;#x229D;"/>
<xsl:output-character character="⨸" string="&amp;#x2A38;"/>
<xsl:output-character character="⊙" string="&amp;#x2299;"/>
<xsl:output-character character="⦼" string="&amp;#x29BC;"/>
<xsl:output-character character="⦿" string="&amp;#x29BF;"/>
<xsl:output-character character="⧁" string="&amp;#x29C1;"/>
<xsl:output-character character="⦵" string="&amp;#x29B5;"/>
<xsl:output-character character="⦾" string="&amp;#x29BE;"/>
<xsl:output-character character="⧀" string="&amp;#x29C0;"/>
<xsl:output-character character="⦶" string="&amp;#x29B6;"/>
<xsl:output-character character="⊖" string="&amp;#x2296;"/>
<xsl:output-character character="⦷" string="&amp;#x29B7;"/>
<xsl:output-character character="⦹" string="&amp;#x29B9;"/>
<xsl:output-character character="⊕" string="&amp;#x2295;"/>
<xsl:output-character character="⊘" string="&amp;#x2298;"/>
<xsl:output-character character="⊗" string="&amp;#x2297;"/>
<xsl:output-character character="⨷" string="&amp;#x2A37;"/>
<xsl:output-character character="⨶" string="&amp;#x2A36;"/>
<xsl:output-character character="⌽" string="&amp;#x233D;"/>
<xsl:output-character character="⨣" string="&amp;#x2A23;"/>
<xsl:output-character character="⊞" string="&amp;#x229E;"/>
<xsl:output-character character="⨢" string="&amp;#x2A22;"/>
<xsl:output-character character="∔" string="&amp;#x2214;"/>
<xsl:output-character character="⨥" string="&amp;#x2A25;"/>
<xsl:output-character character="⩲" string="&amp;#x2A72;"/>
<xsl:output-character character="⨦" string="&amp;#x2A26;"/>
<xsl:output-character character="⨧" string="&amp;#x2A27;"/>
<xsl:output-character character="∏" string="&amp;#x220F;"/>
<xsl:output-character character="⧚" string="&amp;#x29DA;"/>
<xsl:output-character character="⨮" string="&amp;#x2A2E;"/>
<xsl:output-character character="⨵" string="&amp;#x2A35;"/>
<xsl:output-character character="⋌" string="&amp;#x22CC;"/>
<xsl:output-character character="⋊" string="&amp;#x22CA;"/>
<xsl:output-character character="⋅" string="&amp;#x22C5;"/>
<xsl:output-character character="⊡" string="&amp;#x22A1;"/>
<xsl:output-character character="∖" string="&amp;#x2216;"/>
<xsl:output-character character="⨤" string="&amp;#x2A24;"/>
<xsl:output-character character="⨳" string="&amp;#x2A33;"/>
<xsl:output-character character="⧄" string="&amp;#x29C4;"/>
<xsl:output-character character="⊓" string="&amp;#x2293;"/>
    <!--U02293-0FE00 sqcaps-->
<xsl:output-character character="⊔" string="&amp;#x2294;"/>
    <!--U02294-0FE00 sqcups-->
<xsl:output-character character="∖" string="&amp;#xE844;"/>
<xsl:output-character character="⋆" string="&amp;#x22C6;"/>
<xsl:output-character character="⪽" string="&amp;#x2ABD;"/>
<xsl:output-character character="∑" string="&amp;#x2211;"/>
<xsl:output-character character="⪾" string="&amp;#x2ABE;"/>
<xsl:output-character character="⊠" string="&amp;#x22A0;"/>
<xsl:output-character character="⨱" string="&amp;#x2A31;"/>
<xsl:output-character character="⨰" string="&amp;#x2A30;"/>
<xsl:output-character character="◬" string="&amp;#x25EC;"/>
<xsl:output-character character="⨺" string="&amp;#x2A3A;"/>
<xsl:output-character character="⨹" string="&amp;#x2A39;"/>
<xsl:output-character character="⧍" string="&amp;#x29CD;"/>
<xsl:output-character character="⨻" string="&amp;#x2A3B;"/>
<xsl:output-character character="⊎" string="&amp;#x228E;"/>
<xsl:output-character character="⊻" string="&amp;#x22BB;"/>
<xsl:output-character character="⩟" string="&amp;#x2A5F;"/>
<xsl:output-character character="≀" string="&amp;#x2240;"/>
<xsl:output-character character="⋂" string="&amp;#x22C2;"/>
<xsl:output-character character="◯" string="&amp;#x25CB;"/>
<xsl:output-character character="⋃" string="&amp;#x22C3;"/>
<xsl:output-character character="▽" string="&amp;#x25BD;"/>
<xsl:output-character character="⨀" string="&amp;#x2A00;"/>
<xsl:output-character character="⨁" string="&amp;#x2A01;"/>
<xsl:output-character character="⨂" string="&amp;#x2A02;"/>
<xsl:output-character character="⨆" string="&amp;#x2A06;"/>
<xsl:output-character character="⨄" string="&amp;#x2A04;"/>
<xsl:output-character character="△" string="&amp;#x25B3;"/>
<xsl:output-character character="⋁" string="&amp;#x22C1;"/>
<xsl:output-character character="⋀" string="&amp;#x22C0;"/>
    <!-- isoamscmap.xsl -->
<xsl:output-character character="⌞" string="&amp;#x231E;"/>
<xsl:output-character character="⌟" string="&amp;#x231F;"/>
<xsl:output-character character="⦕" string="&amp;#x2995;"/>
<xsl:output-character character="⦑" string="&amp;#x2991;"/>
<xsl:output-character character="⦋" string="&amp;#x298B;"/>
<xsl:output-character character="⦏" string="&amp;#x298F;"/>
<xsl:output-character character="⦍" string="&amp;#x298D;"/>
<xsl:output-character character="⌈" string="&amp;#x2308;"/>
<xsl:output-character character="⌊" string="&amp;#x230A;"/>
<xsl:output-character character="⎰" string="&amp;#x23B0;"/>
<xsl:output-character character="⦓" string="&amp;#x2993;"/>
<xsl:output-character character="⦖" string="&amp;#x2996;"/>
<xsl:output-character character="⦒" string="&amp;#x2992;"/>
<xsl:output-character character="⦌" string="&amp;#x298C;"/>
<xsl:output-character character="⦎" string="&amp;#x298E;"/>
<xsl:output-character character="⦐" string="&amp;#x2990;"/>
<xsl:output-character character="⌉" string="&amp;#x2309;"/>
<xsl:output-character character="⌋" string="&amp;#x230B;"/>
<xsl:output-character character="⎱" string="&amp;#x23B1;"/>
<xsl:output-character character="⦔" string="&amp;#xE291;"/>
<xsl:output-character character="⌜" string="&amp;#x231C;"/>
<xsl:output-character character="⌝" string="&amp;#x231D;"/>
    <!-- isoamsnmap.xsl -->
<xsl:output-character character="⪊" string="&amp;#xE411;"/>
<xsl:output-character character="⪈" string="&amp;#x2269;"/>
<xsl:output-character character="≩" string="&amp;#x2269;"/>
<xsl:output-character character="⋧" string="&amp;#x22E7;"/>
    <!--U02269-0FE00 gvnE-->
<xsl:output-character character="⪉" string="&amp;#xE2A2;"/>
<xsl:output-character character="⪇" string="&amp;#x2268;"/>
<xsl:output-character character="≨" string="&amp;#x2268;"/>
<xsl:output-character character="⋦" string="&amp;#x22E6;"/>
    <!--U02268-0FE00 lvnE-->
<xsl:output-character character="≉" string="&amp;#x2249;"/>
    <!--U02A70-00338 napE-->
    <!--U0224B-00338 napid-->
<xsl:output-character character="≇" string="&amp;#x2247;"/>
    <!--U02A6D-00338 ncongdot-->
<xsl:output-character character="≢" string="&amp;#x2262;"/>
<xsl:output-character character="≱" string="&amp;#xE2A6;"/>
    <!--U02267-00338 ngE-->
    <!--U02A7E-00338 nges-->
    <!--U022D9-00338 nGg-->
<xsl:output-character character="≵" string="&amp;#x2275;"/>
<xsl:output-character character="≯" string="&amp;#x226F;"/>
    <!--U0226B-020D2 nGt-->
    <!--U0226B-00338 nGtv-->
<xsl:output-character character="≰" string="&amp;#xE2A7;"/>
    <!--U02266-00338 nlE-->
    <!--U02A7D-00338 nles-->
    <!--U022D8-00338 nLl-->
<xsl:output-character character="≴" string="&amp;#x2274;"/>
<xsl:output-character character="≮" string="&amp;#x226E;"/>
    <!--U0226A-020D2 nLt-->
<xsl:output-character character="⋪" string="&amp;#x22EA;"/>
<xsl:output-character character="⋬" string="&amp;#x22EC;"/>
    <!--U0226A-00338 nLtv-->
<xsl:output-character character="∤" string="&amp;#x2224;"/>
<xsl:output-character character="∦" string="&amp;#x2226;"/>
<xsl:output-character character="⊀" string="&amp;#x2280;"/>
<xsl:output-character character="⋠" string="&amp;#x22E0;"/>
    <!--U02AAF-00338 npre-->
<xsl:output-character character="⋫" string="&amp;#x22EB;"/>
<xsl:output-character character="⋭" string="&amp;#x22ED;"/>
<xsl:output-character character="⊁" string="&amp;#x2281;"/>
<xsl:output-character character="⋡" string="&amp;#x22E1;"/>
    <!--U02AB0-00338 nsce-->
<xsl:output-character character="≁" string="&amp;#x2241;"/>
<xsl:output-character character="≄" string="&amp;#x2244;"/>
<xsl:output-character character="∤" string="&amp;#xE2AA;"/>
<xsl:output-character character="∦" string="&amp;#xE2AB;"/>
<xsl:output-character character="⋢" string="&amp;#x22E2;"/>
<xsl:output-character character="⋣" string="&amp;#x22E3;"/>
<xsl:output-character character="⊄" string="&amp;#x2284;"/>
<xsl:output-character character="⊈" string="&amp;#x2288;"/>
    <!--U02AC5-00338 nsubE-->
<xsl:output-character character="⊅" string="&amp;#x2285;"/>
<xsl:output-character character="⊉" string="&amp;#x2289;"/>
    <!--U02AC6-00338 nsupE-->
<xsl:output-character character="≹" string="&amp;#x2279;"/>
<xsl:output-character character="≸" string="&amp;#x2278;"/>
    <!--U0224D-020D2 nvap-->
<xsl:output-character character="⊬" string="&amp;#x22AC;"/>
<xsl:output-character character="⊭" string="&amp;#x22AD;"/>
<xsl:output-character character="⊮" string="&amp;#x22AE;"/>
<xsl:output-character character="⊯" string="&amp;#x22AF;"/>
    <!--U02265-020D2 nvge-->
    <!--U0003E-020D2 nvgt-->
    <!--U02264-020D2 nvle-->
    <!--U0003C-020D2 nvlt-->
    <!--U022B4-020D2 nvltrie-->
    <!--U022B5-020D2 nvrtrie-->
    <!--U0223C-020D2 nvsim-->
<xsl:output-character character="⫳" string="&amp;#x2AF3;"/>
<xsl:output-character character="⪹" string="&amp;#x22E8;"/>
<xsl:output-character character="⪵" string="&amp;#xE2B3;"/>
<xsl:output-character character="⋨" string="&amp;#x22E8;"/>
<xsl:output-character character="⫮" string="&amp;#x2AEE;"/>
<xsl:output-character character="⪺" string="&amp;#x22E9;"/>
<xsl:output-character character="⪶" string="&amp;#xE2B5;"/>
<xsl:output-character character="⋩" string="&amp;#x22E9;"/>
<xsl:output-character character="≆" string="&amp;#x2246;"/>
<xsl:output-character character="⌿" string="&amp;#x233F;"/>
<xsl:output-character character="⊊" string="&amp;#x228A;"/>
<xsl:output-character character="⫋" string="&amp;#x228A;"/>
<xsl:output-character character="⊋" string="&amp;#x228B;"/>
<xsl:output-character character="⫌" string="&amp;#x228B;"/>
    <!--U02282-020D2 vnsub-->
    <!--U02283-020D2 vnsup-->
    <!--U0228A-0FE00 vsubne-->
    <!--U02ACB-0FE00 vsubnE-->
    <!--U0228B-0FE00 vsupne-->
    <!--U02ACC-0FE00 vsupnE-->
    <!-- isoamsomap.xsl -->
<xsl:output-character character="∠" string="&amp;#x2220;"/>
<xsl:output-character character="⦤" string="&amp;#x29A4;"/>
<xsl:output-character character="∡" string="&amp;#x2221;"/>
<xsl:output-character character="⦨" string="&amp;#x29A8;"/>
<xsl:output-character character="⦩" string="&amp;#x29A9;"/>
<xsl:output-character character="⦪" string="&amp;#x29AA;"/>
<xsl:output-character character="⦫" string="&amp;#x29AB;"/>
<xsl:output-character character="⦬" string="&amp;#x29AC;"/>
<xsl:output-character character="⦭" string="&amp;#x29AD;"/>
<xsl:output-character character="⦮" string="&amp;#x29AE;"/>
<xsl:output-character character="⦯" string="&amp;#x29AF;"/>
<xsl:output-character character="⊾" string="&amp;#x22BE;"/>
<xsl:output-character character="⦝" string="&amp;#x299D;"/>
<xsl:output-character character="⎵" string="&amp;#x23B5;"/>
<xsl:output-character character="⎶" string="&amp;#x23B6;"/>
<xsl:output-character character="⦰" string="&amp;#x29B0;"/>
<xsl:output-character character="ℶ" string="&amp;#x2136;"/>
<xsl:output-character character="⧉" string="&amp;#x29C9;"/>
<xsl:output-character character="‵" string="&amp;#x2035;"/>
<xsl:output-character character="⁏" string="&amp;#x204F;"/>
<xsl:output-character character="⦲" string="&amp;#x29B2;"/>
<xsl:output-character character="⧃" string="&amp;#x29C3;"/>
<xsl:output-character character="⧂" string="&amp;#x29C2;"/>
<xsl:output-character character="∁" string="&amp;#x2201;"/>
<xsl:output-character character="ℸ" string="&amp;#x2138;"/>
<xsl:output-character character="⦱" string="&amp;#x29B1;"/>
<xsl:output-character character="ℓ" string="&amp;#x2113;"/>
<xsl:output-character character="∅" string="&amp;#xE2D3;"/>
<xsl:output-character character="∅" string="&amp;#x2205;"/>
<xsl:output-character character="ℷ" string="&amp;#x2137;"/>
<xsl:output-character character="℩" string="&amp;#x2129;"/>
<xsl:output-character character="ℑ" string="&amp;#x2111;"/>
<xsl:output-character character="ı" string="&amp;#x0131;"/>
    <!--U0006A jmath-->
<xsl:output-character character="⦴" string="&amp;#x29B4;"/>
<xsl:output-character character="◺" string="&amp;#x25FA;"/>
<xsl:output-character character="⊿" string="&amp;#x22BF;"/>
<xsl:output-character character="℧" string="&amp;#x2127;"/>
    <!--U02220-020D2 nang-->
<xsl:output-character character="∄" string="&amp;#x2204;"/>
<xsl:output-character character="Ⓢ" string="&amp;#xE41D;"/>
<xsl:output-character character="ℏ" string="&amp;#x210F;"/>
<xsl:output-character character="ℏ" string="&amp;#x210F;"/>
<xsl:output-character character="⦳" string="&amp;#x29B3;"/>
<xsl:output-character character="⦥" string="&amp;#x29A5;"/>
<xsl:output-character character="ℜ" string="&amp;#x211C;"/>
<xsl:output-character character="⎴" string="&amp;#x23B4;"/>
<xsl:output-character character="�" string="&amp;#xFFFD;"/>
<xsl:output-character character="◸" string="&amp;#x25F8;"/>
<xsl:output-character character="◹" string="&amp;#x25F9;"/>
<xsl:output-character character="⦚" string="&amp;#x299A;"/>
<xsl:output-character character="℘" string="&amp;#x2118;"/>
    <!-- isoamsrmap.xsl -->
<xsl:output-character character="≊" string="&amp;#x224A;"/>
<xsl:output-character character="⩰" string="&amp;#x2A70;"/>
<xsl:output-character character="≋" string="&amp;#x224B;"/>
<xsl:output-character character="≈" string="&amp;#x224D;"/>
<xsl:output-character character="⫧" string="&amp;#x2AE7;"/>
<xsl:output-character character="≌" string="&amp;#x224C;"/>
<xsl:output-character character="϶" string="&amp;#xE420;"/>
<xsl:output-character character="⋈" string="&amp;#x22C8;"/>
<xsl:output-character character="∽" string="&amp;#x223D;"/>
<xsl:output-character character="⋍" string="&amp;#x22CD;"/>
    <!--U0005C-02282 bsolhsub-->
<xsl:output-character character="≎" string="&amp;#x224E;"/>
<xsl:output-character character="≏" string="&amp;#x224F;"/>
<xsl:output-character character="⪮" string="&amp;#x2AAE;"/>
<xsl:output-character character="≗" string="&amp;#x2257;"/>
<xsl:output-character character="∷" string="&amp;#x2237;"/>
<xsl:output-character character="≔" string="&amp;#x2254;"/>
<xsl:output-character character="⩴" string="&amp;#x2A74;"/>
<xsl:output-character character="⩭" string="&amp;#x2A6D;"/>
<xsl:output-character character="⫏" string="&amp;#x2ACF;"/>
<xsl:output-character character="⫑" string="&amp;#x2AD1;"/>
<xsl:output-character character="⫐" string="&amp;#x2AD0;"/>
<xsl:output-character character="⫒" string="&amp;#x2AD2;"/>
<xsl:output-character character="⋞" string="&amp;#x22DE;"/>
<xsl:output-character character="⋟" string="&amp;#x22DF;"/>
<xsl:output-character character="⊣" string="&amp;#x22A3;"/>
<xsl:output-character character="⫤" string="&amp;#x2AE4;"/>
<xsl:output-character character="⩮" string="&amp;#x2A6E;"/>
<xsl:output-character character="≖" string="&amp;#x2256;"/>
<xsl:output-character character="≕" string="&amp;#x2255;"/>
<xsl:output-character character="⩷" string="&amp;#x2A77;"/>
<xsl:output-character character="≑" string="&amp;#x2251;"/>
<xsl:output-character character="≒" string="&amp;#x2252;"/>
<xsl:output-character character="⪚" string="&amp;#x2A9A;"/>
<xsl:output-character character="⪖" string="&amp;#x22DD;"/>
<xsl:output-character character="⪘" string="&amp;#x2A98;"/>
<xsl:output-character character="⪙" string="&amp;#x2A99;"/>
<xsl:output-character character="⪕" string="&amp;#x22DC;"/>
<xsl:output-character character="⪗" string="&amp;#x2A97;"/>
<xsl:output-character character="≟" string="&amp;#x225F;"/>
<xsl:output-character character="⩸" string="&amp;#x2A78;"/>
<xsl:output-character character="≓" string="&amp;#x2253;"/>
<xsl:output-character character="≐" string="&amp;#x2250;"/>
<xsl:output-character character="≂" string="&amp;#x2242;"/>
<xsl:output-character character="⩳" string="&amp;#x2A73;"/>
<xsl:output-character character="⋔" string="&amp;#x22D4;"/>
<xsl:output-character character="⫙" string="&amp;#x2AD9;"/>
<xsl:output-character character="⌢" string="&amp;#x2322;"/>
<xsl:output-character character="⪆" string="&amp;#x2273;"/>
<xsl:output-character character="≧" string="&amp;#x2267;"/>
<xsl:output-character character="⋛" string="&amp;#x22DB;"/>
<xsl:output-character character="⪌" string="&amp;#x22DB;"/>
<xsl:output-character character="⩾" string="&amp;#x227D;"/>
<xsl:output-character character="⪩" string="&amp;#x2AA9;"/>
<xsl:output-character character="⪀" string="&amp;#x2A80;"/>
<xsl:output-character character="⪂" string="&amp;#x2A82;"/>
<xsl:output-character character="⪄" string="&amp;#x2A84;"/>
    <!--U022DB-0FE00 gesl-->
<xsl:output-character character="⪔" string="&amp;#x2A94;"/>
<xsl:output-character character="⋙" string="&amp;#x22D9;"/>
<xsl:output-character character="≷" string="&amp;#x2277;"/>
<xsl:output-character character="⪥" string="&amp;#x2AA5;"/>
<xsl:output-character character="⪒" string="&amp;#x2A92;"/>
<xsl:output-character character="⪤" string="&amp;#x2AA4;"/>
<xsl:output-character character="≳" string="&amp;#x2273;"/>
<xsl:output-character character="⪎" string="&amp;#x2A8E;"/>
<xsl:output-character character="⪐" string="&amp;#x2A90;"/>
<xsl:output-character character="≫" string="&amp;#x226B;"/>
<xsl:output-character character="⪧" string="&amp;#x2AA7;"/>
<xsl:output-character character="⩺" string="&amp;#x2A7A;"/>
<xsl:output-character character="⋗" string="&amp;#x22D7;"/>
<xsl:output-character character="⩼" string="&amp;#x2A7C;"/>
<xsl:output-character character="⥸" string="&amp;#x2978;"/>
<xsl:output-character character="∻" string="&amp;#x223B;"/>
<xsl:output-character character="⪅" string="&amp;#x2272;"/>
<xsl:output-character character="⪫" string="&amp;#x2AAB;"/>
<xsl:output-character character="⪭" string="&amp;#x2AAD;"/>
    <!--U02AAD-0FE00 lates-->
<xsl:output-character character="≦" string="&amp;#x2266;"/>
<xsl:output-character character="⋚" string="&amp;#x22DA;"/>
<xsl:output-character character="⪋" string="&amp;#x22DA;"/>
<xsl:output-character character="⩽" string="&amp;#xE425;"/>
<xsl:output-character character="⪨" string="&amp;#x2AA8;"/>
<xsl:output-character character="⩿" string="&amp;#x2A7F;"/>
<xsl:output-character character="⪁" string="&amp;#x2A81;"/>
<xsl:output-character character="⪃" string="&amp;#x2A83;"/>
    <!--U022DA-0FE00 lesg-->
<xsl:output-character character="⪓" string="&amp;#x2A93;"/>
<xsl:output-character character="≶" string="&amp;#x2276;"/>
<xsl:output-character character="⪑" string="&amp;#x2A91;"/>
<xsl:output-character character="⋘" string="&amp;#x22D8;"/>
<xsl:output-character character="≲" string="&amp;#x2272;"/>
<xsl:output-character character="⪍" string="&amp;#x2A8D;"/>
<xsl:output-character character="⪏" string="&amp;#x2A8F;"/>
<xsl:output-character character="≪" string="&amp;#x226A;"/>
<xsl:output-character character="⪦" string="&amp;#x2AA6;"/>
<xsl:output-character character="⩹" string="&amp;#x2A79;"/>
<xsl:output-character character="⋖" string="&amp;#x22D6;"/>
<xsl:output-character character="⥶" string="&amp;#x2976;"/>
<xsl:output-character character="⩻" string="&amp;#x2A7B;"/>
<xsl:output-character character="⊴" string="&amp;#x22B4;"/>
<xsl:output-character character="⨩" string="&amp;#x2A29;"/>
<xsl:output-character character="∺" string="&amp;#x223A;"/>
<xsl:output-character character="∣" string="&amp;#x2223;"/>
<xsl:output-character character="⫛" string="&amp;#x2ADB;"/>
<xsl:output-character character="⊧" string="&amp;#x22A7;"/>
<xsl:output-character character="∾" string="&amp;#x223E;"/>
<xsl:output-character character="≺" string="&amp;#x227A;"/>
<xsl:output-character character="⪻" string="&amp;#x2ABB;"/>
<xsl:output-character character="⪷" string="&amp;#x227E;"/>
<xsl:output-character character="≼" string="&amp;#x227C;"/>
<xsl:output-character character="⪯" string="&amp;#x227C;"/>
<xsl:output-character character="⪳" string="&amp;#x2AB3;"/>
<xsl:output-character character="≾" string="&amp;#x227E;"/>
<xsl:output-character character="⊰" string="&amp;#x22B0;"/>
<xsl:output-character character="∶" string="&#160;:&#160;"/>
<xsl:output-character character="⊵" string="&amp;#x22B5;"/>
<xsl:output-character character="⧎" string="&amp;#x29CE;"/>
<xsl:output-character character="≻" string="&amp;#x227B;"/>
<xsl:output-character character="⪼" string="&amp;#x2ABC;"/>
<xsl:output-character character="⪸" string="&amp;#x227F;"/>
<xsl:output-character character="≽" string="&amp;#x227D;"/>
<xsl:output-character character="⪰" string="&amp;#x227D;"/>
<xsl:output-character character="⪴" string="&amp;#x2AB4;"/>
<xsl:output-character character="≿" string="&amp;#x227F;"/>
<xsl:output-character character="⩦" string="&amp;#x2A66;"/>
<xsl:output-character character="⌢" string="&amp;#xE426;"/>
<xsl:output-character character="⪞" string="&amp;#x2A9E;"/>
<xsl:output-character character="⪠" string="&amp;#x2AA0;"/>
<xsl:output-character character="⪝" string="&amp;#x2A9D;"/>
<xsl:output-character character="⪟" string="&amp;#x2A9F;"/>
<xsl:output-character character="∣" string="&amp;#xE301;"/>
<xsl:output-character character="⌣" string="&amp;#x2323;"/>
<xsl:output-character character="⪪" string="&amp;#x2AAA;"/>
<xsl:output-character character="⪬" string="&amp;#x2AAC;"/>
    <!--U02AAC-0FE00 smtes-->
<xsl:output-character character="∥" string="&amp;#xE302;"/>
<xsl:output-character character="⊏" string="&amp;#x228F;"/>
<xsl:output-character character="⊑" string="&amp;#x2291;"/>
<xsl:output-character character="⊐" string="&amp;#x2290;"/>
<xsl:output-character character="⊒" string="&amp;#x2292;"/>
<xsl:output-character character="⌣" string="&amp;#xE303;"/>
<xsl:output-character character="⋐" string="&amp;#x22D0;"/>
<xsl:output-character character="⫅" string="&amp;#x2286;"/>
<xsl:output-character character="⫃" string="&amp;#x2AC3;"/>
<xsl:output-character character="⫁" string="&amp;#x2AC1;"/>
<xsl:output-character character="⪿" string="&amp;#x2ABF;"/>
<xsl:output-character character="⥹" string="&amp;#x2979;"/>
<xsl:output-character character="⫇" string="&amp;#x2AC7;"/>
<xsl:output-character character="⫕" string="&amp;#x2AD5;"/>
<xsl:output-character character="⫓" string="&amp;#x2AD3;"/>
<xsl:output-character character="⋑" string="&amp;#x22D1;"/>
<xsl:output-character character="⫘" string="&amp;#x2AD8;"/>
<xsl:output-character character="⫆" string="&amp;#x2287;"/>
<xsl:output-character character="⫄" string="&amp;#x2AC4;"/>
    <!--U02283-0002F suphsol-->
<xsl:output-character character="⫗" string="&amp;#x2AD7;"/>
<xsl:output-character character="⥻" string="&amp;#x297B;"/>
<xsl:output-character character="⫂" string="&amp;#x2AC2;"/>
<xsl:output-character character="⫀" string="&amp;#x2AC0;"/>
<xsl:output-character character="⫈" string="&amp;#x2AC8;"/>
<xsl:output-character character="⫔" string="&amp;#x2AD4;"/>
<xsl:output-character character="⫖" string="&amp;#x2AD6;"/>
<xsl:output-character character="≈" string="&amp;#xE306;"/>
<xsl:output-character character="∼" string="&amp;#xE429;"/>
<xsl:output-character character="⫚" string="&amp;#x2ADA;"/>
<xsl:output-character character="≜" string="&amp;#x225C;"/>
<xsl:output-character character="≬" string="&amp;#x226C;"/>
<xsl:output-character character="⫨" string="&amp;#x2AE8;"/>
<xsl:output-character character="⫫" string="&amp;#x2AEB;"/>
<xsl:output-character character="⫩" string="&amp;#x2AE9;"/>
<xsl:output-character character="⊢" string="&amp;#x22A2;"/>
<xsl:output-character character="⊨" string="&amp;#x22A8;"/>
<xsl:output-character character="⊩" string="&amp;#x22A9;"/>
<xsl:output-character character="⊫" string="&amp;#x22AB;"/>
<xsl:output-character character="⫦" string="&amp;#x2AE6;"/>
<xsl:output-character character="⊲" string="&amp;#x22B2;"/>
<xsl:output-character character="∝" string="&amp;#x221D;"/>
<xsl:output-character character="⊳" string="&amp;#x22B3;"/>
<xsl:output-character character="⊪" string="&amp;#x22AA;"/>
    <!-- isogrk1map.xsl -->
<xsl:output-character character="α" string="&amp;#x03B1;"/>
<xsl:output-character character="Α" string="&amp;#x0391;"/>
<xsl:output-character character="β" string="&amp;#x03B2;"/>
<xsl:output-character character="Β" string="&amp;#x0392;"/>
<xsl:output-character character="δ" string="&amp;#x03B4;"/>
<xsl:output-character character="Δ" string="&amp;#x0394;"/>
<xsl:output-character character="η" string="&amp;#x03B7;"/>
<xsl:output-character character="Η" string="&amp;#x0397;"/>
<xsl:output-character character="ε" string="&amp;#x03B5;"/>
<xsl:output-character character="Ε" string="&amp;#x0395;"/>
<xsl:output-character character="γ" string="&amp;#x03B3;"/>
<xsl:output-character character="Γ" string="&amp;#x0393;"/>
<xsl:output-character character="ι" string="&amp;#x03B9;"/>
<xsl:output-character character="Ι" string="&amp;#x0399;"/>
<xsl:output-character character="κ" string="&amp;#x03BA;"/>
<xsl:output-character character="Κ" string="&amp;#x039A;"/>
<xsl:output-character character="χ" string="&amp;#x03C7;"/>
<xsl:output-character character="Χ" string="&amp;#x03A7;"/>
<xsl:output-character character="λ" string="&amp;#x03BB;"/>
<xsl:output-character character="Λ" string="&amp;#x039B;"/>
<xsl:output-character character="μ" string="&amp;#x03BC;"/>
<xsl:output-character character="Μ" string="&amp;#x039C;"/>
<xsl:output-character character="ν" string="&amp;#x03BD;"/>
<xsl:output-character character="Ν" string="&amp;#x039D;"/>
<xsl:output-character character="ο" string="&amp;#x03BF;"/>
<xsl:output-character character="Ο" string="&amp;#x039F;"/>
<xsl:output-character character="ω" string="&amp;#x03C9;"/>
<xsl:output-character character="Ω" string="&amp;#x03A9;"/>
<xsl:output-character character="π" string="&amp;#x03C0;"/>
<xsl:output-character character="Π" string="&amp;#x03A0;"/>
<xsl:output-character character="φ" string="&amp;#x03C6;"/>
<xsl:output-character character="Φ" string="&amp;#x03A6;"/>
<xsl:output-character character="ψ" string="&amp;#x03C8;"/>
<xsl:output-character character="Ψ" string="&amp;#x03A8;"/>
<xsl:output-character character="ρ" string="&amp;#x03C1;"/>
<xsl:output-character character="Ρ" string="&amp;#x03A1;"/>
<xsl:output-character character="ς" string="&amp;#x03C2;"/>
<xsl:output-character character="σ" string="&amp;#x03C3;"/>
<xsl:output-character character="Σ" string="&amp;#x03A3;"/>
<xsl:output-character character="τ" string="&amp;#x03C4;"/>
<xsl:output-character character="Τ" string="&amp;#x03A4;"/>
<xsl:output-character character="θ" string="&amp;#x03B8;"/>
<xsl:output-character character="Θ" string="&amp;#x0398;"/>
<xsl:output-character character="υ" string="&amp;#x03C5;"/>
<xsl:output-character character="Υ" string="&amp;#x03A5;"/>
<xsl:output-character character="ξ" string="&amp;#x03BE;"/>
<xsl:output-character character="Ξ" string="&amp;#x039E;"/>
<xsl:output-character character="ζ" string="&amp;#x03B6;"/>
<xsl:output-character character="Ζ" string="&amp;#x0396;"/>
    <!-- isogrk2map.xsl -->
<xsl:output-character character="ά" string="&amp;#x03AC;"/>
<xsl:output-character character="Ά" string="&amp;#x0386;"/>
<xsl:output-character character="έ" string="&amp;#x03AD;"/>
<xsl:output-character character="Έ" string="&amp;#x0388;"/>
<xsl:output-character character="ή" string="&amp;#x03AE;"/>
<xsl:output-character character="Ή" string="&amp;#x0389;"/>
<xsl:output-character character="ί" string="&amp;#x03AF;"/>
<xsl:output-character character="Ί" string="&amp;#x038A;"/>
<xsl:output-character character="ΐ" string="&amp;#x0390;"/>
<xsl:output-character character="ϊ" string="&amp;#x03CA;"/>
<xsl:output-character character="Ϊ" string="&amp;#x03AA;"/>
<xsl:output-character character="ό" string="&amp;#x03CC;"/>
<xsl:output-character character="Ό" string="&amp;#x038C;"/>
<xsl:output-character character="ώ" string="&amp;#x03CE;"/>
<xsl:output-character character="Ώ" string="&amp;#x038F;"/>
<xsl:output-character character="ύ" string="&amp;#x03CD;"/>
<xsl:output-character character="Ύ" string="&amp;#x038E;"/>
<xsl:output-character character="ΰ" string="&amp;#x03B0;"/>
<xsl:output-character character="ϋ" string="&amp;#x03CB;"/>
<xsl:output-character character="Ϋ" string="&amp;#x03AB;"/>
    <!-- isogrk3map.xsl -->
<xsl:output-character character="α" string="&amp;#x03B1;"/>
<xsl:output-character character="β" string="&amp;#x03B2;"/>
<xsl:output-character character="χ" string="&amp;#x03C7;"/>
<xsl:output-character character="δ" string="&amp;#x03B4;"/>
<xsl:output-character character="Δ" string="&amp;#x0394;"/>
<xsl:output-character character="ϵ" string="&amp;#x220A;"/>
<xsl:output-character character="ε" string="&amp;#x03B5;"/>
<xsl:output-character character="η" string="&amp;#x03B7;"/>
<xsl:output-character character="γ" string="&amp;#x03B3;"/>
<xsl:output-character character="Γ" string="&amp;#x0393;"/>
<xsl:output-character character="ϝ" string="&amp;#x03DC;"/>
<xsl:output-character character="Ϝ" string="&amp;#x03DC;"/>
<xsl:output-character character="ι" string="&amp;#x03B9;"/>
<xsl:output-character character="κ" string="&amp;#x03BA;"/>
<xsl:output-character character="ϰ" string="&amp;#x03F0;"/>
<xsl:output-character character="λ" string="&amp;#x03BB;"/>
<xsl:output-character character="Λ" string="&amp;#x039B;"/>
<xsl:output-character character="μ" string="&amp;#x03BC;"/>
<xsl:output-character character="ν" string="&amp;#x03BD;"/>
<xsl:output-character character="ω" string="&amp;#x03C9;"/>
<xsl:output-character character="Ω" string="&amp;#x03A9;"/>
<xsl:output-character character="ϕ" string="&amp;#x03C6;"/>
<xsl:output-character character="Φ" string="&amp;#x03A6;"/>
<xsl:output-character character="φ" string="&amp;#x03D5;"/>
<xsl:output-character character="" string="&amp;#x03C6;"/>
<xsl:output-character character="π" string="&amp;#x03C0;"/>
<xsl:output-character character="Π" string="&amp;#x03A0;"/>
<xsl:output-character character="ϖ" string="&amp;#x03D6;"/>
<xsl:output-character character="ψ" string="&amp;#x03C8;"/>
<xsl:output-character character="Ψ" string="&amp;#x03A8;"/>
<xsl:output-character character="ρ" string="&amp;#x03C1;"/>
<xsl:output-character character="ϱ" string="&amp;#x03F1;"/>
<xsl:output-character character="σ" string="&amp;#x03C3;"/>
<xsl:output-character character="Σ" string="&amp;#x03A3;"/>
<xsl:output-character character="ς" string="&amp;#x03C2;"/>
<xsl:output-character character="τ" string="&amp;#x03C4;"/>
<xsl:output-character character="θ" string="&amp;#x03B8;"/>
<xsl:output-character character="Θ" string="&amp;#x0398;"/>
<xsl:output-character character="ϑ" string="&amp;#x03D1;"/>
<xsl:output-character character="υ" string="&amp;#x03C5;"/>
<xsl:output-character character="ϒ" string="&amp;#x03D2;"/>
<xsl:output-character character="ξ" string="&amp;#x03BE;"/>
<xsl:output-character character="Ξ" string="&amp;#x039E;"/>
<xsl:output-character character="ζ" string="&amp;#x03B6;"/>
    <!-- isotechmap.xsl -->
<xsl:output-character character="∿" string="&amp;#x223F;"/>
<xsl:output-character character="ℵ" string="&amp;#x2135;"/>
<xsl:output-character character="∧" string="&amp;#x2227;"/>
<xsl:output-character character="⩓" string="&amp;#x2A53;"/>
<xsl:output-character character="⩕" string="&amp;#x2A55;"/>
<xsl:output-character character="⩜" string="&amp;#x2A5C;"/>
<xsl:output-character character="⩘" string="&amp;#x2A58;"/>
<xsl:output-character character="⩚" string="&amp;#x2A5A;"/>
<xsl:output-character character="∟" string="&amp;#x221F;"/>
<xsl:output-character character="∢" string="&amp;#x2222;"/>
<xsl:output-character character="Å" string="&amp;#x212B;"/>
<xsl:output-character character="≈" string="&amp;#x2248;"/>
<xsl:output-character character="⩯" string="&amp;#x2A6F;"/>
<xsl:output-character character="∳" string="&amp;#x2233;"/>
<xsl:output-character character="⨑" string="&amp;#x2A11;"/>
<xsl:output-character character="∵" string="&amp;#x2235;"/>
<xsl:output-character character="ℬ" string="&amp;#x212C;"/>
    <!--U0003D-020E5 bne-->
    <!--U02261-020E5 bnequiv-->
<xsl:output-character character="⌐" string="&amp;#x2310;"/>
<xsl:output-character character="⫭" string="&amp;#x2AED;"/>
<xsl:output-character character="⊥" string="&amp;#x22A5;"/>
<xsl:output-character character="∩" string="&amp;#x2229;"/>
<xsl:output-character character="∰" string="&amp;#x2230;"/>
<xsl:output-character character="⨐" string="&amp;#x2A10;"/>
<xsl:output-character character="∘" string="&amp;#x2218;"/>
<xsl:output-character character="≅" string="&amp;#x2245;"/>
<xsl:output-character character="∮" string="&amp;#x222E;"/>
<xsl:output-character character="∯" string="&amp;#x222F;"/>
<xsl:output-character character="⋯" string="&amp;#x22EF;"/>
<xsl:output-character character="∪" string="&amp;#x222A;"/>
<xsl:output-character character="∲" string="&amp;#x2232;"/>
<xsl:output-character character="∱" string="&amp;#x2231;"/>
<xsl:output-character character="⌭" string="&amp;#x232D;"/>
<xsl:output-character character="⋲" string="&amp;#x22F2;"/>
<xsl:output-character character="¨" string="&amp;#x0308;"/>
<xsl:output-character character="⃜" string="&amp;#x20DC;"/>
<xsl:output-character character="⧶" string="&amp;#x29F6;"/>
<xsl:output-character character="⋱" string="&amp;#x22F1;"/>
<xsl:output-character character="⦦" string="&amp;#x29A6;"/>
<xsl:output-character character="�" string="&amp;#xFFFD;"/>
<xsl:output-character character="⋕" string="&amp;#x22D5;"/>
<xsl:output-character character="⧣" string="&amp;#x29E3;"/>
<xsl:output-character character="≡" string="&amp;#x2261;"/>
<xsl:output-character character="⧥" string="&amp;#x29E5;"/>
<xsl:output-character character="∃" string="&amp;#x2203;"/>
<xsl:output-character character="▱" string="&amp;#x25B1;"/>
<xsl:output-character character="ƒ" string="&amp;#x0192;"/>
<xsl:output-character character="∀" string="&amp;#x2200;"/>
<xsl:output-character character="⨍" string="&amp;#x2A0D;"/>
<xsl:output-character character="≥" string="&amp;#x2265;"/>
<xsl:output-character character="ℋ" string="&amp;#x210B;"/>
<xsl:output-character character="⇔" string="&amp;#xE365;"/>
<xsl:output-character character="⧜" string="&amp;#x29DC;"/>
<xsl:output-character character="Ƶ" string="&amp;#x01B5;"/>
<xsl:output-character character="∞" string="&amp;#x221E;"/>
<xsl:output-character character="⧝" string="&amp;#x29DD;"/>
<xsl:output-character character="∫" string="&amp;#x222B;"/>
<xsl:output-character character="∬" string="&amp;#x222C;"/>
<xsl:output-character character="⨗" string="&amp;#x2A17;"/>
<xsl:output-character character="∈" string="&amp;#x220A;"/>
<xsl:output-character character="⋵" string="&amp;#x22F5;"/>
<xsl:output-character character="⋹" string="&amp;#x22F9;"/>
<xsl:output-character character="⋴" string="&amp;#x22F4;"/>
<xsl:output-character character="⋳" string="&amp;#x22F3;"/>
<xsl:output-character character="∈" string="&amp;#x2208;"/>
<xsl:output-character character="ℒ" string="&amp;#x2112;"/>
<xsl:output-character character="〈" string="&amp;#x3008;"/>
<xsl:output-character character="《" string="&amp;#x300A;"/>
<xsl:output-character character="⇐" string="&amp;#x21D0;"/>
<xsl:output-character character="〔" string="&amp;#x3014;"/>
<xsl:output-character character="≤" string="&amp;#x2264;"/>
<xsl:output-character character="〘" string="&amp;#x3018;"/>
<xsl:output-character character="〚" string="&amp;#x301A;"/>
<xsl:output-character character="⦅" string="&amp;#x2985;"/>
<xsl:output-character character="∗" string="&amp;#x2217;"/>
<xsl:output-character character="−" string="&amp;#x2212;"/>
<xsl:output-character character="∓" string="&amp;#x2213;"/>
<xsl:output-character character="∇" string="&amp;#x2207;"/>
<xsl:output-character character="≠" string="&amp;#x2260;"/>
    <!--U02250-00338 nedot-->
<xsl:output-character character="⫲" string="&amp;#x2AF2;"/>
<xsl:output-character character="∋" string="&amp;#x220D;"/>
<xsl:output-character character="⋼" string="&amp;#x22FC;"/>
<xsl:output-character character="⋺" string="&amp;#x22FA;"/>
<xsl:output-character character="∋" string="&amp;#x220B;"/>
<xsl:output-character character="⫬" string="&amp;#x00AC;"/>
<xsl:output-character character="∉" string="&amp;#x2209;"/>
    <!--U022F5-00338 notindot-->
    <!--U022F9-00338 notinE-->
<xsl:output-character character="∉" string="&amp;#x2209;"/>
<xsl:output-character character="⋷" string="&amp;#x22F7;"/>
<xsl:output-character character="⋶" string="&amp;#x22F6;"/>
<xsl:output-character character="∌" string="&amp;#x220C;"/>
<xsl:output-character character="∌" string="&amp;#x220C;"/>
<xsl:output-character character="⋾" string="&amp;#x22FE;"/>
<xsl:output-character character="⋽" string="&amp;#x22FD;"/>
    <!--U02AFD-020E5 nparsl-->
    <!--U02202-00338 npart-->
<xsl:output-character character="⨔" string="&amp;#x2A14;"/>
<xsl:output-character character="⧞" string="&amp;#x29DE;"/>
<xsl:output-character character="⦻" string="&amp;#x29BB;"/>
<xsl:output-character character="∨" string="&amp;#x2228;"/>
<xsl:output-character character="⩔" string="&amp;#x2A54;"/>
<xsl:output-character character="⩝" string="&amp;#x2A5D;"/>
<xsl:output-character character="ℴ" string="&amp;#x2134;"/>
<xsl:output-character character="⩖" string="&amp;#x2A56;"/>
<xsl:output-character character="⩗" string="&amp;#x2A57;"/>
<xsl:output-character character="⩛" string="&amp;#x2A5B;"/>
<xsl:output-character character="∥" string="&amp;#x2225;"/>
<xsl:output-character character="⫽" string="&amp;#x2AFD;"/>
<xsl:output-character character="∂" string="&amp;#x2202;"/>
<xsl:output-character character="‰" string="&amp;#x2030;"/>
<xsl:output-character character="⊥" string="&amp;#x22A5;"/>
<xsl:output-character character="‱" string="&amp;#x2031;"/>
<xsl:output-character character="ℳ" string="&amp;#x2133;"/>
<xsl:output-character character="⨕" string="&amp;#x2A15;"/>
<xsl:output-character character="′" string="&amp;#x2032;"/>
<xsl:output-character character="″" string="&amp;#x2033;"/>
<xsl:output-character character="⌮" string="&amp;#x232E;"/>
<xsl:output-character character="⌒" string="&amp;#x2312;"/>
<xsl:output-character character="⌓" string="&amp;#x2313;"/>
<xsl:output-character character="∝" string="&amp;#x221D;"/>
<xsl:output-character character="⨌" string="&amp;#x2A0C;"/>
<xsl:output-character character="⁗" string="&amp;#x2057;"/>
<xsl:output-character character="⨖" string="&amp;#x2A16;"/>
<xsl:output-character character="√" string="&amp;#x221A;"/>
<xsl:output-character character="〉" string="&amp;#x3009;"/>
<xsl:output-character character="》" string="&amp;#x300B;"/>
<xsl:output-character character="⇒" string="&amp;#x2192;"/>
<xsl:output-character character="〕" string="&amp;#x3015;"/>
<xsl:output-character character="〙" string="&amp;#x3019;"/>
<xsl:output-character character="〛" string="&amp;#x301B;"/>
<xsl:output-character character="⦆" string="&amp;#x2986;"/>
<xsl:output-character character="⨒" string="&amp;#x2A12;"/>
<xsl:output-character character="⨓" string="&amp;#x2A13;"/>
<xsl:output-character character="∼" string="&amp;#x223C;"/>
<xsl:output-character character="⩪" string="&amp;#x2A6A;"/>
<xsl:output-character character="≃" string="&amp;#x2243;"/>
<xsl:output-character character="⧤" string="&amp;#x29E4;"/>
<xsl:output-character character="□" string="&amp;#x25A1;"/>
<xsl:output-character character="▪" string="&amp;#x25AA;"/>
<xsl:output-character character="¯" string="&amp;#x00AF;"/>
<xsl:output-character character="⊂" string="&amp;#x2282;"/>
<xsl:output-character character="⊆" string="&amp;#x2286;"/>
<xsl:output-character character="⊃" string="&amp;#x2283;"/>
<xsl:output-character character="⊇" string="&amp;#x2287;"/>
<xsl:output-character character="⃛" string="&amp;#x20DB;"/>
<xsl:output-character character="∴" string="&amp;#x2234;"/>
<xsl:output-character character="∭" string="&amp;#x222D;"/>
<xsl:output-character character="⊤" string="&amp;#x22A4;"/>
<xsl:output-character character="⌶" string="&amp;#x2336;"/>
<xsl:output-character character="⫱" string="&amp;#x2AF1;"/>
<xsl:output-character character="‴" string="&amp;#x2034;"/>
<xsl:output-character character="⋰" string="&amp;#x22F0;"/>
<xsl:output-character character="⦧" string="&amp;#x29A7;"/>
<xsl:output-character character="⦜" string="&amp;#x299C;"/>
<xsl:output-character character="≚" string="&amp;#x225A;"/>
<xsl:output-character character="‖" string="&amp;#x2016;"/>
<xsl:output-character character="≙" string="&amp;#x2259;"/>
<xsl:output-character character="⋻" string="&amp;#x22FB;"/>
    <!-- genentitymap.xsl -->
<xsl:output-character character="∿" string="&amp;#x223F;"/>
<xsl:output-character character="ℵ" string="&amp;#x2135;"/>
<xsl:output-character character="∧" string="&amp;#x2227;"/>
<xsl:output-character character="⩓" string="&amp;#x2A53;"/>
<xsl:output-character character="⩕" string="&amp;#x2A55;"/>
<xsl:output-character character="⩜" string="&amp;#x2A5C;"/>
<xsl:output-character character="⩘" string="&amp;#x2A58;"/>
<xsl:output-character character="⩚" string="&amp;#x2A5A;"/>
<xsl:output-character character="∟" string="&amp;#x221F;"/>
<xsl:output-character character="∢" string="&amp;#x2222;"/>
<xsl:output-character character="Å" string="&amp;#x212B;"/>
<xsl:output-character character="≈" string="&amp;#x2248;"/>
<xsl:output-character character="⩯" string="&amp;#x2A6F;"/>
<xsl:output-character character="∳" string="&amp;#x2233;"/>
<xsl:output-character character="⨑" string="&amp;#x2A11;"/>
<xsl:output-character character="∵" string="&amp;#x2235;"/>
<xsl:output-character character="ℬ" string="&amp;#x212C;"/>
    <!--U0003D-020E5 bne-->
    <!--U02261-020E5 bnequiv-->
<xsl:output-character character="⌐" string="&amp;#x2310;"/>
<xsl:output-character character="⫭" string="&amp;#x2AED;"/>
<xsl:output-character character="⊥" string="&amp;#x22A5;"/>
<xsl:output-character character="∩" string="&amp;#x2229;"/>
<xsl:output-character character="∰" string="&amp;#x2230;"/>
<xsl:output-character character="⨐" string="&amp;#x2A10;"/>
<xsl:output-character character="∘" string="&amp;#x2218;"/>
<xsl:output-character character="≅" string="&amp;#x2245;"/>
<xsl:output-character character="∮" string="&amp;#x222E;"/>
<xsl:output-character character="∯" string="&amp;#x222F;"/>
<xsl:output-character character="⋯" string="&amp;#x22EF;"/>
<xsl:output-character character="∪" string="&amp;#x222A;"/>
<xsl:output-character character="∲" string="&amp;#x2232;"/>
<xsl:output-character character="∱" string="&amp;#x2231;"/>
<xsl:output-character character="⌭" string="&amp;#x232D;"/>
<xsl:output-character character="⋲" string="&amp;#x22F2;"/>
<xsl:output-character character="¨" string="&amp;#x0308;"/>
<xsl:output-character character="⃜" string="&amp;#x20DC;"/>
<xsl:output-character character="⧶" string="&amp;#x29F6;"/>
<xsl:output-character character="⋱" string="&amp;#x22F1;"/>
<xsl:output-character character="⦦" string="&amp;#x29A6;"/>
<xsl:output-character character="�" string="&amp;#xFFFD;"/>
<xsl:output-character character="⋕" string="&amp;#x22D5;"/>
<xsl:output-character character="⧣" string="&amp;#x29E3;"/>
<xsl:output-character character="≡" string="&amp;#x2261;"/>
<xsl:output-character character="⧥" string="&amp;#x29E5;"/>
<xsl:output-character character="∃" string="&amp;#x2203;"/>
<xsl:output-character character="▱" string="&amp;#x25B1;"/>
<xsl:output-character character="ƒ" string="&amp;#x0192;"/>
<xsl:output-character character="∀" string="&amp;#x2200;"/>
<xsl:output-character character="⨍" string="&amp;#x2A0D;"/>
<xsl:output-character character="≥" string="&amp;#x2265;"/>
<xsl:output-character character="ℋ" string="&amp;#x210B;"/>
<xsl:output-character character="⇔" string="&amp;#xE365;"/>
<xsl:output-character character="⧜" string="&amp;#x29DC;"/>
<xsl:output-character character="Ƶ" string="&amp;#x01B5;"/>
<xsl:output-character character="∞" string="&amp;#x221E;"/>
<xsl:output-character character="⧝" string="&amp;#x29DD;"/>
<xsl:output-character character="∫" string="&amp;#x222B;"/>
<xsl:output-character character="∬" string="&amp;#x222C;"/>
<xsl:output-character character="⨗" string="&amp;#x2A17;"/>
<xsl:output-character character="∈" string="&amp;#x220A;"/>
<xsl:output-character character="⋵" string="&amp;#x22F5;"/>
<xsl:output-character character="⋹" string="&amp;#x22F9;"/>
<xsl:output-character character="⋴" string="&amp;#x22F4;"/>
<xsl:output-character character="⋳" string="&amp;#x22F3;"/>
<xsl:output-character character="∈" string="&amp;#x2208;"/>
<xsl:output-character character="ℒ" string="&amp;#x2112;"/>
<xsl:output-character character="〈" string="&amp;#x3008;"/>
<xsl:output-character character="《" string="&amp;#x300A;"/>
<xsl:output-character character="⇐" string="&amp;#x21D0;"/>
<xsl:output-character character="〔" string="&amp;#x3014;"/>
<xsl:output-character character="≤" string="&amp;#x2264;"/>
<xsl:output-character character="〘" string="&amp;#x3018;"/>
<xsl:output-character character="〚" string="&amp;#x301A;"/>
<xsl:output-character character="⦅" string="&amp;#x2985;"/>
<xsl:output-character character="∗" string="&amp;#x2217;"/>
<xsl:output-character character="−" string="&amp;#x2212;"/>
<xsl:output-character character="∓" string="&amp;#x2213;"/>
<xsl:output-character character="∇" string="&amp;#x2207;"/>
<xsl:output-character character="≠" string="&amp;#x2260;"/>
    <!--U02250-00338 nedot-->
<xsl:output-character character="⫲" string="&amp;#x2AF2;"/>
<xsl:output-character character="∋" string="&amp;#x220D;"/>
<xsl:output-character character="⋼" string="&amp;#x22FC;"/>
<xsl:output-character character="⋺" string="&amp;#x22FA;"/>
<xsl:output-character character="∋" string="&amp;#x220B;"/>
<xsl:output-character character="⫬" string="&amp;#x00AC;"/>
<xsl:output-character character="∉" string="&amp;#x2209;"/>
    <!--U022F5-00338 notindot-->
    <!--U022F9-00338 notinE-->
<xsl:output-character character="∉" string="&amp;#x2209;"/>
<xsl:output-character character="⋷" string="&amp;#x22F7;"/>
<xsl:output-character character="⋶" string="&amp;#x22F6;"/>
<xsl:output-character character="∌" string="&amp;#x220C;"/>
<xsl:output-character character="∌" string="&amp;#x220C;"/>
<xsl:output-character character="⋾" string="&amp;#x22FE;"/>
<xsl:output-character character="⋽" string="&amp;#x22FD;"/>
    <!--U02AFD-020E5 nparsl-->
    <!--U02202-00338 npart-->
<xsl:output-character character="⨔" string="&amp;#x2A14;"/>
<xsl:output-character character="⧞" string="&amp;#x29DE;"/>
<xsl:output-character character="⦻" string="&amp;#x29BB;"/>
<xsl:output-character character="∨" string="&amp;#x2228;"/>
<xsl:output-character character="⩔" string="&amp;#x2A54;"/>
<xsl:output-character character="⩝" string="&amp;#x2A5D;"/>
<xsl:output-character character="ℴ" string="&amp;#x2134;"/>
<xsl:output-character character="⩖" string="&amp;#x2A56;"/>
<xsl:output-character character="⩗" string="&amp;#x2A57;"/>
<xsl:output-character character="⩛" string="&amp;#x2A5B;"/>
<xsl:output-character character="∥" string="&amp;#x2225;"/>
<xsl:output-character character="⫽" string="&amp;#x2AFD;"/>
<xsl:output-character character="∂" string="&amp;#x2202;"/>
<xsl:output-character character="‰" string="&amp;#x2030;"/>
<xsl:output-character character="⊥" string="&amp;#x22A5;"/>
<xsl:output-character character="‱" string="&amp;#x2031;"/>
<xsl:output-character character="ℳ" string="&amp;#x2133;"/>
<xsl:output-character character="⨕" string="&amp;#x2A15;"/>
<xsl:output-character character="′" string="&amp;#x2032;"/>
<xsl:output-character character="″" string="&amp;#x2033;"/>
<xsl:output-character character="⌮" string="&amp;#x232E;"/>
<xsl:output-character character="⌒" string="&amp;#x2312;"/>
<xsl:output-character character="⌓" string="&amp;#x2313;"/>
<xsl:output-character character="∝" string="&amp;#x221D;"/>
<xsl:output-character character="⨌" string="&amp;#x2A0C;"/>
<xsl:output-character character="⁗" string="&amp;#x2057;"/>
<xsl:output-character character="⨖" string="&amp;#x2A16;"/>
<xsl:output-character character="√" string="&amp;#x221A;"/>
<xsl:output-character character="〉" string="&amp;#x3009;"/>
<xsl:output-character character="》" string="&amp;#x300B;"/>
<xsl:output-character character="⇒" string="&amp;#x2192;"/>
<xsl:output-character character="〕" string="&amp;#x3015;"/>
<xsl:output-character character="〙" string="&amp;#x3019;"/>
<xsl:output-character character="〛" string="&amp;#x301B;"/>
<xsl:output-character character="⦆" string="&amp;#x2986;"/>
<xsl:output-character character="⨒" string="&amp;#x2A12;"/>
<xsl:output-character character="⨓" string="&amp;#x2A13;"/>
<xsl:output-character character="∼" string="&amp;#x223C;"/>
<xsl:output-character character="⩪" string="&amp;#x2A6A;"/>
<xsl:output-character character="≃" string="&amp;#x2243;"/>
<xsl:output-character character="⧤" string="&amp;#x29E4;"/>
<xsl:output-character character="□" string="&amp;#x25A1;"/>
<xsl:output-character character="▪" string="&amp;#x25AA;"/>
<xsl:output-character character="¯" string="&amp;#x00AF;"/>
<xsl:output-character character="⊂" string="&amp;#x2282;"/>
<xsl:output-character character="⊆" string="&amp;#x2286;"/>
<xsl:output-character character="⊃" string="&amp;#x2283;"/>
<xsl:output-character character="⊇" string="&amp;#x2287;"/>
<xsl:output-character character="⃛" string="&amp;#x20DB;"/>
<xsl:output-character character="∴" string="&amp;#x2234;"/>
<xsl:output-character character="∭" string="&amp;#x222D;"/>
<xsl:output-character character="⊤" string="&amp;#x22A4;"/>
<xsl:output-character character="⌶" string="&amp;#x2336;"/>
<xsl:output-character character="⫱" string="&amp;#x2AF1;"/>
<xsl:output-character character="‴" string="&amp;#x2034;"/>
<xsl:output-character character="⋰" string="&amp;#x22F0;"/>
<xsl:output-character character="⦧" string="&amp;#x29A7;"/>
<xsl:output-character character="⦜" string="&amp;#x299C;"/>
<xsl:output-character character="≚" string="&amp;#x225A;"/>
<xsl:output-character character="‖" string="&amp;#x2016;"/>
<xsl:output-character character="≙" string="&amp;#x2259;"/>
<xsl:output-character character="⋻" string="&amp;#x22FB;"/>
<xsl:output-character character="" string="&amp;#x0061;"/>
<xsl:output-character character="" string="&amp;#x0062;"/>
<xsl:output-character character="ə" string="&amp;#x0259;"/>
<xsl:output-character character=" " string="&amp;#x2029;"/>
</xsl:character-map>
    <xsl:template match="div[@class='captionreference']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="p[parent::div[@class='captionreference']]">
        <xsl:element name="p">
            <xsl:copy-of select="@* except(@data-alias)"/>
            <xsl:attribute name="data-alias" select="'Reference'"/>
            <xsl:apply-templates></xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <!-- @@@@@@@@@@@@@@@@ -->
    <!-- 24-oct-18: Added No-B-IT property Sindhu -->  
    <xsl:template match="spanX[@data-Bold]">
        <xsl:choose>
            <xsl:when test="not(following-sibling::b)">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="data-Bold" select="'REMOVE'"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="spanX[@data-Italic]">
        <xsl:choose>
            <xsl:when test="not(descendant-or-self::i)">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="data-Italic" select="'REMOVE'"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="spanX[@data-Underline]">
        <xsl:choose>
            <xsl:when test="not(following-sibling::u)">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="data-Underline" select="'REMOVE'"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- 28-JUNE-19: To remove full b-i-u -->
    <!--<xsl:template match="span[@data-PROrange = 'proStart']">
        <xsl:text disable-output-escaping="yes">&lt;span</xsl:text>
        <xsl:if test="@data-Bold">
            <xsl:text> data-Bold="REMOVE"</xsl:text>
        </xsl:if>
        <xsl:if test="@data-Italic">
            <xsl:text> data-Italic="REMOVE"</xsl:text>
        </xsl:if>
        <xsl:if test="@data-Underline">
            <xsl:text> data-Underline="REMOVE"</xsl:text>
        </xsl:if>        
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="span[@data-PROrange = 'proEnd']">
        <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
    </xsl:template>-->
    <!-- 28-JUNE-19: To remove full b-i-u -->
    <!-- 13-MAR-19: Replacing Same DIV -->
    
    <xsl:template match="a[@style = 'mso-endnote-id:e' and @name = '_edn']"/>   
    <!-- 13-MAR-19 Ends -->
    <!-- @@@@@@@@@@@@@@@@ -->
    
    <!--Added for cic-Group 16-8-2019-->
    <xsl:template match="div[p[contains(.,'FMGroup')]] | p[contains(.,'FMGroup')][not(parent::div)]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;div data-alias="IntroGroup"&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="div[p[contains(.,'IntroGroup')]] | p[contains(.,'IntroGroup')][not(parent::div)]">
        
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;div data-alias="BodyGroup"&gt;</xsl:text>
    </xsl:template>
    <xsl:template match="div[p[contains(.,'BodyGroup')]] | p[contains(.,'BodyGroup')][not(parent::div)]">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
        <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;div data-alias="BMGroup"&gt;</xsl:text>
    </xsl:template>
    
    <!--End-->
</xsl:stylesheet>
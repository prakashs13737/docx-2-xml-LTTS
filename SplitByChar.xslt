<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mf="http://example.com/mf"
    exclude-result-prefixes="xs mf" version="2.0">
    
    <xsl:template match="/">
        <xsl:element name="body">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="text()">    
<!--                                <xsl:variable name="matches" select="mf:extract(.,'[\p{Zs}\t]')"/>-->
        <xsl:variable name="match">
            <!--<xsl:for-each select="$matches">
                <xsl:value-of select="."/>
            </xsl:for-each>
            <xsl:value-of select="'&#x2028;'"/>
            <xsl:value-of select="'&#8232;'"/>
            <xsl:value-of select="' '"/>-->
            <xsl:value-of select="."/>
        </xsl:variable>
        <xsl:call-template name="str.tokenize.keep.delimiters" xml:space="default">
            <xsl:with-param name="string" select="."/>
            <xsl:with-param name="delimiters" select="$match"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template name="str.tokenize.keep.delimiters">
        <xsl:param name="string" select="''"/>
        <xsl:param name="delimiters"/>
        <xsl:choose>
            <xsl:when test="not($string)"/>
            <xsl:when test="not($delimiters)">
                <xsl:call-template name="str.tokenize.keep.delimiters-characters">
                    <xsl:with-param name="string" select="$string"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="str.tokenize.keep.delimiters-delimiters">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="delimiters" select="$delimiters"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="str.tokenize.keep.delimiters-characters">
        <xsl:param name="string"/>
        <xsl:if test="$string">
            <xsl:value-of select="substring($string, 1, 1)"/>
            <xsl:call-template name="str.tokenize.keep.delimiters-characters">
                <xsl:with-param name="string" select="substring($string, 2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="str.tokenize.keep.delimiters-delimiters">
        <xsl:param name="string"/>
        <xsl:param name="delimiters"/>
        <xsl:variable name="delimiter" select="substring($delimiters, 1, 1)"/>
        <xsl:choose>
            <xsl:when test="not($delimiter)">
                <xsl:if test="processing-instruction() or not($string ='')">
                    <xsl:element name="span">
                        <xsl:choose>
                            <xsl:when test="processing-instruction()">
                                <xsl:copy-of select="processing-instruction()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$string"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:if>
            </xsl:when>
            <xsl:when test="contains($string, $delimiter)">
                <xsl:if test="not(starts-with($string, $delimiter))">
                    <xsl:call-template name="str.tokenize.keep.delimiters-delimiters">
                        <xsl:with-param name="string" select="substring-before($string, $delimiter)"/>
                        <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
                    </xsl:call-template>
                </xsl:if>
                <!-- output each delimiter -->
                <xsl:variable name="pattern" select="'[\p{Zs}\t]'"/>
                <xsl:variable name="delimitterName">
                    <xsl:analyze-string select="$delimiter" regex="{$pattern}">
                        <xsl:matching-substring>
                            <xsl:value-of select="'Space'"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="'Word'"/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:element name="span">
                    <xsl:value-of select="$delimiter"/>
                </xsl:element>
                <xsl:if test="not(substring-after($string, $delimiter) = '')">
                 <xsl:call-template name="str.tokenize.keep.delimiters-delimiters">
                     <xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
                     <xsl:with-param name="delimiters" select="$delimiters"/>
                 </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="str.tokenize.keep.delimiters-delimiters">
                    <xsl:with-param name="string" select="$string"/>
                    <xsl:with-param name="delimiters" select="substring($delimiters, 2)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="mf:extract" as="xs:string*">
        <xsl:param name="input" as="xs:string"/>
        <xsl:param name="pattern" as="xs:string"/>
        <xsl:analyze-string select="$input" regex="{$pattern}">
            <xsl:matching-substring>
                <xsl:sequence select="."/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    


</xsl:stylesheet>

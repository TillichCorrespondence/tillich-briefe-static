<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">    
    
    <xsl:template match="tei:biblStruct" name="bibl_detail">
        <xsl:variable name="zoteroLink" select="@corresp"/>        
        <xsl:variable name="zoteroId" select="substring-after(@xml:id, '__')"/>    
        <dl>
            
            <xsl:if test=".//tei:title">
                <dt>Titel</dt>
                <dd>
                    <xsl:value-of select="."/>
                </dd>
            </xsl:if>
            
            <xsl:if test=".//tei:author">
                <dt>Autor(en)</dt>
                <dd>
                    <ul>
                        <xsl:for-each select=".//tei:author">
                            <li>
                                <xsl:value-of select="."/>
                            </li>
                        </xsl:for-each>
                    </ul>
                </dd>
            </xsl:if>
            
            <xsl:if test=".//tei:date">
                <dt>Datum</dt>
                <dd>
                    <xsl:value-of select=".//tei:date"/>
                </dd>
            </xsl:if>
            
            <xsl:if test="$zoteroLink">
                <dt>Zotero ID</dt>
                <dd>
                    <a href="{$zoteroLink}" target="_blank">
                        <xsl:value-of select="$zoteroId"/>
                    </a>
                </dd>
            </xsl:if>
            
        </dl>
    </xsl:template>
</xsl:stylesheet>

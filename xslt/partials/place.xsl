<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:template match="tei:place" name="place_detail">
        <dl>
            <xsl:if test="./tei:idno">
                <dt>Normdaten</dt>
                <xsl:for-each select=".//tei:idno[starts-with(./text(), 'http')]">
                    <dd>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="./text()"/>
                            </xsl:attribute>
                            <xsl:value-of select="./text()"/>
                        </a>
                    </dd>
                </xsl:for-each>
            </xsl:if>
            <xsl:if test=".//tei:geo">
                <dt>Koordinaten</dt>
                <dd>
                    <xsl:value-of select=".//tei:geo"/>
                </dd>
            </xsl:if>
        </dl>
    </xsl:template>
</xsl:stylesheet>

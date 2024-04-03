<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet    
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    

    <xsl:template match="/">    
        <xsl:variable name="doc_title">
            <xsl:value-of select="normalize-space(string-join(.//tei:title//text()))"/>
        </xsl:variable>

        <root>
            <title>
                <xsl:value-of select="$doc_title"/>
            </title>
        </root>


    </xsl:template>
    
</xsl:stylesheet>
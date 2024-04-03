<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever" exclude-result-prefixes="xs" version="2.0">
    <!-- this creates the notes[@type='commentary']. included is a feature that takes the text between anchor and note as input and creates a lemma. if the
  text is too long it abbreviates it-->
    <!-- Kommentar und Textkonstitution -->
    <xsl:template match="tei:note"/>
    <xsl:template match="tei:note" mode="kommentaranhang">
        <p>
            <!-- Get the Word before the note element-->
            <xsl:variable name="textBefore" select="preceding::text()[1]" />
            <xsl:variable name="words" select="tokenize($textBefore, '\s+')" />
            <xsl:variable name="lemma" select="$words[last()]" />

            <span class="lemma">
                <xsl:value-of select="$lemma"/>
                <xsl:text>]&#160;</xsl:text>
            </span>
            <span class="kommentar-text">
                <xsl:apply-templates select="node() except Lemma"/>
            </span>
        </p>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'subscript']" mode="lemma">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'superscript']" mode="lemma">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:function name="mam:dots">
        <xsl:param name="anzahl"/>
 .        <xsl:if test="$anzahl &gt; 1">
            <xsl:value-of select="mam:dots($anzahl - 1)"/>
        </xsl:if>
    </xsl:function>
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output encoding="UTF-8" media-type="text" omit-xml-declaration="true" indent="no"/>
    
    <xsl:template match="/">
\documentclass[11pt]{article}
\usepackage{ulem}
\title{Tillich-Briefe }
\author{Tillich Briefe Team}
\date{Herbst 2024}
\begin{document}
\maketitle
\tableofcontents
<xsl:for-each select="subsequence(
        collection('../data/editions/?select=*.xml')/tei:TEI,
        10, 20
        )">
    <xsl:variable name="docId">
        <xsl:value-of select="replace(./@xml:id, '.xml', '')"/>
    </xsl:variable>
    <xsl:variable name="title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
\section{<xsl:text>(</xsl:text><xsl:value-of select="$docId"/><xsl:text>) </xsl:text><xsl:value-of select="$title"/>}
<xsl:text>
    
</xsl:text>
<xsl:apply-templates select=".//tei:dateline"/>

<xsl:text> 
    
</xsl:text>
<xsl:value-of select=".//tei:opener/tei:salute//text()"/>
<xsl:text>
    
</xsl:text>
<xsl:for-each select=".//tei:body//tei:p[not(parent::tei:postscript)]">
<xsl:apply-templates/>
<xsl:text>
    
</xsl:text>
</xsl:for-each>
<xsl:apply-templates select=".//tei:closer"/>
<xsl:text>
    
</xsl:text>
</xsl:for-each>

\end{document}
        
    </xsl:template>
    
    <xsl:template match="tei:dateline">
<xsl:value-of select="replace(
    normalize-space(string-join(.//text())),
    ' , ', ', '
    )"/>
</xsl:template>
    
<xsl:template match="tei:del">\sout{<xsl:value-of select="."/>}</xsl:template>
    
</xsl:stylesheet>
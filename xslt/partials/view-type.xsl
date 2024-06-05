<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:_="urn:acdh"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mam="whatever" exclude-result-prefixes="xs xsl tei" version="2.0">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template name="mam:view-type-img">
        <div id="text-resize" class="row transcript active">
            <xsl:for-each select="//tei:body">
                <div id="text-resize" class="col-md-8 col-lg-8 col-sm-12 text yes-index">
                    <div id="section">
                        <div class="card-body">
                            <div class="card-body-text">
                                <xsl:apply-templates select="//tei:text"/>
                                <xsl:element name="ol">
                                    <xsl:attribute name="class">
                                        <xsl:text>list-for-footnotes</xsl:text>
                                    </xsl:attribute>
                                    <xsl:apply-templates select="descendant::tei:note[@type = 'footnote']" mode="footnote"/>
                                </xsl:element>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 col-lg-4 col-sm-12">
                    <div id="section">
                        <div class="card-body">
                            <div class="card-body-text">
                                <div id="entity-error">
                                    Entität nicht im Datensatz vorhanden
                                </div>
                                <xsl:if test="//tei:listPerson/tei:person">
                                    <h2 class="entities">
                                        Personen:
                                    </h2>
                                    <ul>
                                        <xsl:for-each select="//tei:listPerson/tei:person">
                                            <li class="entities">
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="replace(@xml:id, '#', '')"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test='not(tei:persName)'>
                                                        <xsl:value-of select="tei:reference"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:text>./</xsl:text>
                                                                <xsl:value-of select="data(@xml:id)"/>
                                                                <xsl:text>.html</xsl:text>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="tei:persName"/>
                                                        </a>
                                                        <xsl:if test="tei:occupation">
                                                            <xsl:text> (</xsl:text>
                                                            <xsl:apply-templates select="tei:occupation"/>
                                                            <xsl:text>)</xsl:text>
                                                        </xsl:if>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                                <xsl:if test="//tei:listPlace/tei:place">
                                    <h2 class="entities">
                                        Orte:
                                    </h2>
                                    <ul>
                                        <xsl:for-each select="//tei:listPlace/tei:place">
                                            <li class="entities">
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="data(@xml:id)"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test='not(tei:placeName)'>
                                                        <xsl:value-of select="tei:reference"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:text>./</xsl:text>
                                                                <xsl:value-of select="data(@xml:id)"/>
                                                                <xsl:text>.html</xsl:text>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="tei:placeName"/>
                                                        </a>
                                                        <xsl:if test="tei:idno">
                                                            <xsl:text>&#160;</xsl:text>
                                                            <a class="theme-color">
                                                                <xsl:attribute name="href">
                                                                    <xsl:value-of select="tei:idno/text()"/>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="target">
                                                                    <xsl:text>_blank</xsl:text>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="rel">
                                                                    <xsl:text>noopener</xsl:text>
                                                                </xsl:attribute>
                                                                <i class="fa-solid fa-location-dot"/>
                                                            </a>
                                                        </xsl:if>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                                <xsl:if test="//tei:listBibl/tei:bibl">
                                    <h2 class="entities">
                                        Literatur:
                                    </h2>
                                    <ul>
                                        <xsl:for-each select="//tei:listBibl/tei:bibl">
                                            <li class="entities">
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="data(@xml:id)"/>
                                                </xsl:attribute>
                                                <xsl:apply-templates select="text()"/>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                                <xsl:if test="//tei:listLetter/tei:letter">
                                    <h2 class="entities">
                                        Briefe:
                                    </h2>
                                    <ul>
                                        <xsl:for-each select="//tei:listLetter/tei:letter">
                                            <li class="entities">
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="data(@xml:id)"/>
                                                </xsl:attribute>
                                                <xsl:choose>
                                                    <xsl:when test="tei:title">
                                                        <xsl:element name="a">
                                                            <xsl:attribute name="href">
                                                                <xsl:text>./</xsl:text>
                                                                <xsl:value-of select="@xml:id"/>
                                                                <xsl:text>.html</xsl:text>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="target">
                                                                <xsl:text>_blank</xsl:text>
                                                            </xsl:attribute>
                                                            <xsl:attribute name="rel">
                                                                <xsl:text>noopener</xsl:text>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="data(@xml:id)"/>
                                                        </xsl:element>
                                                        <xsl:text>: </xsl:text>
                                                        <xsl:value-of select="tei:title"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="tei:reference"/>
                                                        <xsl:text> (Nicht im Datensatz vorhanden)</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:if>
                            </div>
                        </div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
</xsl:stylesheet>
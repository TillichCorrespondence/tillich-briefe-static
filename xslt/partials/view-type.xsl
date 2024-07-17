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
                                                        <!-- 
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
                                                        -->
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
                                                <xsl:text>&#160;</xsl:text>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:text>./</xsl:text>
                                                        <xsl:value-of select="data(@xml:id)"/>
                                                        <xsl:text>.html</xsl:text>
                                                    </xsl:attribute>
                                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-book" viewBox="0 0 16 16">
                                                        <path d="M1 2.828c.885-.37 2.154-.769 3.388-.893 1.33-.134 2.458.063 3.112.752v9.746c-.935-.53-2.12-.603-3.213-.493-1.18.12-2.37.461-3.287.811zm7.5-.141c.654-.689 1.782-.886 3.112-.752 1.234.124 2.503.523 3.388.893v9.923c-.918-.35-2.107-.692-3.287-.81-1.094-.111-2.278-.039-3.213.492zM8 1.783C7.015.936 5.587.81 4.287.94c-1.514.153-3.042.672-3.994 1.105A.5.5 0 0 0 0 2.5v11a.5.5 0 0 0 .707.455c.882-.4 2.303-.881 3.68-1.02 1.409-.142 2.59.087 3.223.877a.5.5 0 0 0 .78 0c.633-.79 1.814-1.019 3.222-.877 1.378.139 2.8.62 3.681 1.02A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.293-.455c-.952-.433-2.48-.952-3.994-1.105C10.413.809 8.985.936 8 1.783"/>
                                                    </svg>
                                                </a>
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
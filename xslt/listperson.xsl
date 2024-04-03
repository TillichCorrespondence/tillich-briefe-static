<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:mam="whatever"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:variable name="teiSource" select="'listperson.xml'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis erwähnter Personen'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
            </head>
            <body class="page">
                <div class="hfeed site" id="page">
                    <xsl:call-template name="nav_bar"/>
                    <div class="container-fluid">
                        <div class="card">
                            <div class="card-header" style="text-align:center">
                                <h1>
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                            </div>
                            <div class="w-100 text-center">
                                <div class="spinner-grow table-loader" role="status">
                                    <span class="sr-only">Wird geladen…</span>
                                </div>
                            </div>
                            <div class="card">
                                <table class="table table-striped display" id="tocTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Name</th>
                                            <th scope="col">Lebensdaten</th>
                                            <th scope="col">Beruf</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="descendant::tei:listPerson[1]/tei:person">
                                            <xsl:variable name="entiyID" select="replace(@xml:id, '#', '')"/>
                                            <xsl:variable name="entity" as="node()" select="."/>
                                            <xsl:if test="$entity/tei:persName[1]/text()">
                                                <tr>
                                                    <td>
                                                        <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat($entity/@xml:id, '.html')"/>
                                                            </xsl:attribute>
                                                            <xsl:value-of select="$entity/tei:persName[1]"/>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <!-- <xsl:value-of select="mam:lebensdaten($entity)"/> -->

                                                    </td>
                                                    <td>
                                                        <xsl:if test="$entity/descendant::tei:occupation">
                                                            <xsl:value-of select="$entity/descendant::tei:occupation[1]"/>
                                                        </xsl:if>
                                                    </td>
                                                </tr>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <xsl:call-template name="html_footer"/>
                    <script type="text/javascript" src="https://cdn.datatables.net/v/bs4/jszip-2.5.0/dt-1.11.0/b-2.0.0/b-html5-2.0.0/cr-1.5.4/r-2.2.9/sp-1.4.0/datatables.min.js"></script>
                    <script type="text/javascript" src="js/dt.js"></script>
                    <script>
                        $(document).ready(function () {
                        createDataTable('tocTable')
                        });
                    </script>
                </div>
            </body>
        </html>
        <xsl:for-each select=".//tei:person[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="entity" select="." as="node()"/>
            <xsl:result-document href="{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <xsl:call-template name="html_head">
                        <xsl:with-param name="html_title" select="tei:persName"/>
                    </xsl:call-template>
                    <body class="page">
                        <div class="hfeed site" id="page">
                            <xsl:call-template name="nav_bar"/>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header">
                                        <h2 align="center">
                                            <xsl:value-of select="tei:persName"/>
                                            <xsl:text>&#160;</xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="child::tei:birth and child::tei:death">
                                                    <span class="lebensdaten">
                                                        <xsl:text>(</xsl:text>
                                                        <xsl:value-of select="child::tei:birth/tei:date"/>
                                                        <xsl:text>&#160;</xsl:text>
                                                        <xsl:value-of select="child::tei:birth/tei:settlement/tei:placeName"/>
                                                        <xsl:text> - </xsl:text>
                                                        <xsl:value-of select="child::tei:death/tei:date"/>
                                                        <xsl:text>&#160;</xsl:text>
                                                        <xsl:value-of select="child::tei:death/tei:settlement/tei:placeName"/>
                                                        <xsl:text>)</xsl:text>
                                                    </span>
                                                </xsl:when>
                                            </xsl:choose>
                                        </h2>
                                    </div>
                                    <xsl:call-template name="person_detail"/>
                                </div>
                            </div>
                            <xsl:call-template name="html_footer"/>
                        </div>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
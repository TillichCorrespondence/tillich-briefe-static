<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml">
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
                            <div class="card-header">
                                <h1>Alle Briefe</h1>
                            </div>
                            <div class="card-body">
                                <div class="w-100 text-center">
                                    <div class="spinner-grow table-loader" role="status">
                                        <span class="sr-only">Wird geladen…</span>
                                    </div>
                                </div>
                                <table class="table table-striped display" id="tocTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Titel</th>
                                            <th scope="col">Briefwechsel</th>
                                            <th scope="col">Datum (ISO)</th>
                                            <th scope="col">Art</th>
                                            <th scope="col">ID</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select="collection('../data/editions/?select=*.xml')/tei:TEI">
                                            <xsl:variable name="full_path">
                                                <xsl:value-of select="document-uri(/)"/>
                                            </xsl:variable>
                                            <tr>
                                                <td>
                                                    <sortdate hidden="true">
                                                        <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@when"/>
                                                        <xsl:text>;</xsl:text>
                                                    </sortdate>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:value-of select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')" />
                                                        </xsl:attribute>
                                                        <xsl:value-of select="descendant::tei:titleStmt/tei:title[1]/text()" />
                                                    </a>
                                                </td>
                                                <td>
                                                    <xsl:for-each select="descendant::tei:teiHeader[1]/tei:profileDesc[1]/tei:correspDesc[1]/tei:correspAction">
                                                        <!--                                                         <a>
                                                            <xsl:attribute name="href">
                                                                <xsl:value-of select="concat(replace(@target, '#pmb', 'toc_'), '.html')" />
                                                            </xsl:attribute>
                                                            <xsl:value-of select="."/>
                                                        </a> -->
                                                        <!-- exclude all Paul Tillich refs-->
                                                        <xsl:if test="not(tei:persName/@ref='#tillich_person_id__1928')">
                                                            <xsl:value-of select="tei:persName"/>
                                                            <xsl:if test="not(position() = last())">
                                                                <xsl:text>; </xsl:text>
                                                            </xsl:if>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@when"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="descendant::tei:physDesc"/>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="@xml:id"/>
                                                </td>
                                            </tr>
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
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}">
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:p">
        <p id="{generate-id()}">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:list">
        <ul id="{generate-id()}">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    <xsl:template match="tei:item">
        <li id="{generate-id()}">
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@target"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>

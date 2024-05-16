<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>
    <xsl:param name="work-day" select="document('../data/indices/index_work_day.xml')"/>
    <xsl:key name="work-day-lookup" match="item/@when" use="ref"/>
    <xsl:variable name="teiSource" select="'listwork.xml'"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Verzeichnis der Korrespondenzen'"/>
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
                            <div class="card">
                                <div class="w-100 text-center">
                                    <div class="spinner-grow table-loader" role="status">
                                        <span class="sr-only">Wird geladen…</span>
                                    </div>
                                </div>
                                <table class="table table-striped display" id="tocTable" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th scope="col">Korrespondenz</th>
                                            <th scope="col">Edierte Korrespondenzstücke</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <xsl:for-each select=".//tei:list[@xml:id]">
                                            <xsl:variable name="entiyID" select="@xml:id"/>
                                            <xsl:if test="starts-with($entiyID, 'corresp__tillich_person_id__')">
                                                <tr>
                                                    <td>
                                                        <a href="{concat($entiyID, '.html')}">
                                                            <xsl:value-of select="./tei:head/text()"/>
                                                        </a>
                                                    </td>
                                                    <td>
                                                        <xsl:value-of select="count(./tei:item)"/>
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
        
        <xsl:for-each select=".//tei:list[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name">
                <xsl:value-of select="concat('Korrespondenz Paul Tillich – ', ./tei:head/text())"/>
            </xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>
                    
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main>
                            <div class="container-fluid">
                                <div class="card">
                                    <div class="card-header" style="text-align:center">
                                        <h1>
                                            <xsl:value-of select="$name"/>
                                        </h1>
                                    </div>
                                    <div class="card">
                                        <div class="w-100 text-center">
                                            <div class="spinner-grow table-loader" role="status">
                                                <span class="sr-only">Wird geladen…</span>
                                            </div>
                                        </div>
                                        <table class="table table-striped display" id="tocTable" style="width:100%">
                                            <thead>
                                                <tr>
                                                    <th scope="col">Titel</th>
                                                    <th scope="col">Datum</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <xsl:for-each select=".//tei:item">
                                                    <xsl:variable name="entiyID" select="replace(./tei:ptr/@target, '.xml', '.html')"/>
                                                   
                                                        <tr>
                                                            <td>
                                                                <a href="{$entiyID}">
                                                                    <xsl:value-of select="./tei:title/text()"/>
                                                                </a>
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="./tei:date"/>
                                                            </td>
                                                        </tr>
                                                    
                                                </xsl:for-each>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                        <script type="text/javascript" src="https://cdn.datatables.net/v/bs4/jszip-2.5.0/dt-1.11.0/b-2.0.0/b-html5-2.0.0/cr-1.5.4/r-2.2.9/sp-1.4.0/datatables.min.js"></script>
                        <script type="text/javascript" src="js/dt.js"></script>
                        <script>
                            $(document).ready(function () {
                            createDataTable('tocTable')
                            });
                        </script>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
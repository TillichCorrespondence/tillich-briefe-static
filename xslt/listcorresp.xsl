<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/datatables_import.xsl"/>

    <xsl:output method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Korrespondenzverzeichnis'"/>
        </xsl:variable>
        <html class="h-100" lang="de">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
               <xsl:call-template name="datatables_import"/>

            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                
                <main class="flex-shrink-0 flex-grow-1">
                    
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">Tillich-Briefe</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$doc_title"/></li>
                        </ol>
                    </nav>
                    <div class="container">
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1"><span id="counter1"></span> von <span id="counter2"></span> Korrespondenzen</div>
                        <div id="custom-info-box" class="text-muted small text-center"></div>
                        
                        <table id="myTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col">Korrespondenz</th>
                                    <th scope="col">Edierte Korrespondenzstücke</th>
                                    <th scope="col" data-dt-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:list[contains(@xml:id, 'tillich_person_id__')]">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a href="{concat($id, '.html')}">
                                                <xsl:value-of select=".//tei:head/text()"/>
                                            </a>
                                        </td>
                                       
                                        <td>
                                            <xsl:value-of select="count(.//tei:item)"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
            <script src="js/datatables_custom/datatables_custom.js"></script>

        </html>
        
        <xsl:for-each select=".//tei:list[contains(@xml:id, 'tillich_person_id__')]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name">
                <xsl:value-of select="concat('Korrespondenz Paul Tillich – ', ./tei:head/text())"/>
            </xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="de">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
               <xsl:call-template name="datatables_import"/>
                        
                    </head>
                    
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="index.html">Tillich-Briefe</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="corresp_toc.html">Korrespondenzverzeichnis</a>
                                </li>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                        <div id="custom-info-box" class="text-muted small text-center"></div>

                                <table id="myTable" class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th scope="col">Titel</th>
                                            <th scope="col">Datum</th>
                                            <th scope="col" data-dt-searchlist="true">Derection</th>
                                            <th scope="col">Mitwirkende</th>

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
                                                <td>
                                                    <xsl:variable name="dir" select="normalize-space(./tei:note[@type='direction'])"/>
                                                    <xsl:choose>
                                                        <xsl:when test="$dir = 'sent_to_main'">Brief an Paul Tillich</xsl:when>
                                                        <xsl:when test="$dir = 'received_from_main'">Brief von Paul Tillich</xsl:when>
                                                        <xsl:when test="$dir = 'cosender_with_main'">Gemeinsam mit Paul Tillich verfasst</xsl:when>
                                                        <xsl:when test="$dir = 'corecipient_with_main'">Gemeinsam mit Paul Tillich empfangen</xsl:when>
                                                        <xsl:when test="$dir = 'third_party'">Brief zwischen Dritten</xsl:when>
                                                        <xsl:otherwise/>
                                                    </xsl:choose>
                                                </td>
                                                <td>
                                                    <xsl:value-of select="./tei:note[@type='additional_correspondents']"/>
                                                </td>
                                            </tr>
                                        </xsl:for-each>
                                    </tbody>
                                </table>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
               <script src="js/datatables_custom/datatables_custom.js"></script>

                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
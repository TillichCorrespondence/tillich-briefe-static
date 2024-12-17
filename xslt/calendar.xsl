<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    
    
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Briefkalender'"/>
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <link rel="stylesheet" href="vendor/calendar-component/calendar.css"/>
                <link rel="stylesheet" href="css/calendar.css"/>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">Tillich-Briefe</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page">Briefkalender</li>
                        </ol>
                    </nav>
                    
                    <div class="container pb-4">
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                    
                        <acdh-ch-calendar>
                            <div class="calendar-menu">
                                <label class="p2 text-center fs-2">
                                    <span>Jahr</span>
                                </label>
                                <acdh-ch-calendar-year-picker data-variant="sparse"/>
                            </div>
    
                            <acdh-ch-calendar-year></acdh-ch-calendar-year>
                        </acdh-ch-calendar>

                    <div class="modal fade" id="dataModal" tabindex="-1"
                        aria-labelledby="dataModalLabel" aria-hidden="true">
                        <div class="modal-dialog">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="dataModalLabel">Data Details</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                        aria-label="Schließen"/>
                                </div>
                                <div class="modal-body">
                                    <!-- Data content will be injected here by JavaScript -->
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary"
                                        data-bs-dismiss="modal">Schließen</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script type="module" src="js/calendar.js"/>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
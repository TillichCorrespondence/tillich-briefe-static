<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <html class="h-100" lang="de">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
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
                        <div class="text-center p-1"><span id="counter1"></span> von <span id="counter2"></span> Bibelstellen</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-download="true" width="250">Stelle</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-minWidth="350">Zitat</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="descendant::tei:listBibl/tei:bibl[@n]">
                                    <xsl:variable name="entiyID" select="@n"/>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="./tei:title/text()"/>
                                            </td>
                                            <td>
                                                <ul class="list-unstyled">
                                                    <xsl:for-each select=".//tei:note">
                                                        <li>
                                                            <a href="{replace(@target, '.xml', '.html')}">
                                                               <xsl:value-of select="./text()"/>
                                                           </a>
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$entiyID"/>
                                            </td>
                                        </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js">
                    <xsl:with-param name="clickme" select="false()"/>
                </xsl:call-template>
            </body>
        </html>
        
    </xsl:template>
    
</xsl:stylesheet>
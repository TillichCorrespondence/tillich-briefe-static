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
            <xsl:value-of select="'Verzeichnis erwähnter Werke'"/>
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
                        <div class="text-center p-1"><span id="counter1"></span> von <span id="counter2"></span> Werke</div>
                        
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input">Autor</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="350">Titel</th>
                                    <th scope="col" tabulator-visible="false" tabulator-download="true">titel_</th>
                                    <th scope="col" tabulator-headerFilter="input">Jahr</th>
                                    <th scope="col" tabulator-headerFilter="input">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="descendant::tei:listBibl/tei:biblStruct[@xml:id]">
                                    <xsl:variable name="entiyID" select="replace(@xml:id, '#', '')"/>
                                    <xsl:variable name="autor">
                                        <xsl:value-of select="tokenize(@n, ', ')[1]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="title">
                                        <xsl:value-of select="tokenize(@n, ', ')[2]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="year">
                                        <xsl:value-of select="tokenize(@n, ', ')[3]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:if test="text()">
                                        <tr>
                                            <td>
                                                <xsl:value-of select="$autor"/>
                                            </td>
                                            <td>
                                                <a href="{concat($entiyID, '.html')}">
                                                    <xsl:value-of select="$title"/>
                                                </a>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$title"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$year"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="count(.//tei:note[@type='mentions'])"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$entiyID"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
        <xsl:for-each select=".//tei:biblStruct[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="@n"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html class="h-100" lang="de">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>
                    
                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item">
                                    <a href="index.html">Tillich-Briefe</a>
                                </li>
                                <li class="breadcrumb-item">
                                    <a href="listperson.html"><xsl:value-of select="$doc_title"/></a>
                                </li>
                            </ol>
                        </nav>
                        <main class="flex-shrink-0 flex-grow-1">
                            <div class="container">
                                <h1 class="display-5 text-center">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <div class="text-center fs-3">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="@corresp"/>
                                        </xsl:attribute>
                                        Zotero
                                    </a>
                                </div>
                                <h2 class="fs-4">Erwähnungen</h2>
                                <ul>
                                    <xsl:for-each select=".//tei:note[@type='mentions']">
                                        <li>
                                            <xsl:value-of select="./text()"/>
                                            <xsl:text></xsl:text>
                                            <a class="link-underline-light">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                                                </xsl:attribute>
                                                <xsl:text> </xsl:text><i class="bi bi-box-arrow-up-right"></i>
                                                <span class="visually-hidden">Gehe zu <xsl:value-of select="./text()"/></span>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                                
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>
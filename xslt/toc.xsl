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
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
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
                            <li class="breadcrumb-item active" aria-current="page">Alle Briefe</li>
                        </ol>
                    </nav>
                    
                    <div class="container">
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div class="text-center p-1"><span id="counter1"></span> von <span id="counter2"></span> Briefen</div>
                        <table id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html" tabulator-download="false" tabulator-minWidth="350">Sender</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-visible="false" tabulator-download="true">sender_</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">Empfänger</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-maxWidth="130">Datum</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">von</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-formatter="html">nach</th>
                                    <th scope="col" tabulator-headerFilter="input" >Art</th>
                                    <th scope="col" tabulator-headerFilter="input" tabulator-maxWidth="100">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection('../data/editions?select=*.xml')//tei:TEI">
                                    <xsl:variable name="docId">
                                        <xsl:value-of select="replace(@xml:id, '.xml', '')"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a href="{$docId || '.html'}">
                                                <xsl:value-of select="string-join(.//tei:correspAction[@type='sent']/tei:persName/text(), ', ')"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(.//tei:correspAction[@type='sent']/tei:persName/text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(.//tei:correspAction[@type='received']/tei:persName/text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@when"/>
                                            <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@notBefore"/>
                                            <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@from"/>
                                            <xsl:if test="descendant::tei:correspAction[@type='sent']/tei:date/@notAfter and not(descendant::tei:correspAction[@type='sent']/tei:date/@notBefore)">
                                                <xsl:value-of select="descendant::tei:correspAction[@type='sent']/tei:date/@notAfter"/>
                                            </xsl:if>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(.//tei:correspAction[@type='sent']/tei:placeName/text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string-join(.//tei:correspAction[@type='received']/tei:placeName/text(), ', ')"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="descendant::tei:physDesc"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$docId"/>
                                        </td>
                                    </tr>
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
    </xsl:template>
</xsl:stylesheet>
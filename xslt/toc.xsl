<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="./partials/datatables_import.xsl"/>

    <xsl:output method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Alle Briefe'"/>
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
                            <li class="breadcrumb-item active" aria-current="page">Alle Briefe</li>
                        </ol>
                    </nav>
                    
                    <div class="container">
                        <h1 class="display-5 text-center"><xsl:value-of select="$doc_title"/></h1>
                        <div id="custom-info-box" class="text-muted small text-center"></div>
                       
                        <table id="myTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col">Sender</th>
                                    <th scope="col">Empfänger</th>
                                    <th scope="col">Datum</th>
                                    <th scope="col">von</th>
                                    <th scope="col">nach</th>
                                    <th scope="col">Art</th>
                                    <th scope="col" data-dt-visible="false">ID</th>
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
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
            <script src="js/datatables_custom/datatables_custom.js"></script>
            
        </html>
    </xsl:template>
</xsl:stylesheet>
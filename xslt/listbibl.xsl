<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/person.xsl"/>
    <xsl:import href="./partials/datatables_import.xsl"/>

    <xsl:output method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select="'Verzeichnis erwähnter Werke'"/>
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
                        <div id="custom-info-box" class="text-muted small text-center"></div>
                        
                        <table id="myTable" class="table table-striped">
                            <thead>
                                <tr>
                                    <th scope="col" >Autor</th>
                                    <th scope="col" >Titel</th>
                                    <th scope="col" data-dt-visible="false">titel_</th>
                                    <th scope="col" >Jahr</th>
                                    <th scope="col">Erwähnungen</th>
                                    <th scope="col" data-dt-visible="false">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select="descendant::tei:listBibl/tei:biblStruct[@xml:id]">
                                    <xsl:variable name="id" select="data(@xml:id)"/>
                                    <xsl:variable name="autor">
                                        <xsl:value-of select="tokenize(@n, ', ')[1]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="title">
                                        <xsl:value-of select="tokenize(@n, ', ')[2]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="year">
                                        <xsl:value-of select="tokenize(@n, ', ')[3]"></xsl:value-of>
                                    </xsl:variable>
                                    <xsl:variable name="author_full">
                                        <xsl:choose>
                                            <!-- no authors at all -->
                                            <xsl:when test="not(.//tei:author) and not(.//tei:editor)">
                                                <xsl:text>o.A.</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:variable name="names">
                                                    <xsl:for-each select=".//tei:author">
                                                        <xsl:variable name="fn" select="normalize-space(tei:forename)"/>
                                                        <xsl:variable name="sn" select="normalize-space(tei:surname)"/>
                                                        <xsl:variable name="n" select="normalize-space(tei:name)"/>
                                                        <xsl:choose>
                                                            <xsl:when test="$n">
                                                                <xsl:value-of select="$n"/>
                                                            </xsl:when>
                                                            <xsl:when test="$sn = '' and $fn !=''">
                                                                <xsl:value-of select="$fn"/>
                                                            </xsl:when>
                                                            <xsl:when test="$fn = '' and $sn !=''">
                                                                <xsl:value-of select="$sn"/>
                                                            </xsl:when>
                                                            <xsl:when test="$fn ='' and $sn =''">
                                                                <xsl:text></xsl:text>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:value-of select="normalize-space(concat($sn, ', ', $fn))"/>                                                                
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                        <xsl:if test="position() != last()">;<xsl:text> </xsl:text></xsl:if>
                                                    </xsl:for-each>
                                                </xsl:variable>
                                                <xsl:value-of select="$names"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:variable name="editors">
                                        <xsl:variable name="names">
                                            <xsl:for-each select=".//tei:editor">
                                                <xsl:variable name="fn" select="normalize-space(tei:forename)"/>
                                                <xsl:variable name="sn" select="normalize-space(tei:surname)"/>
                                                <xsl:choose>
                                                    <xsl:when test="$sn = '' and $fn !=''">
                                                        <xsl:value-of select="$fn"/>
                                                    </xsl:when>
                                                    <xsl:when test="$fn = '' and $sn !=''">
                                                        <xsl:value-of select="$sn"/>
                                                    </xsl:when>
                                                    <xsl:when test="$fn = '' and $sn =''">
                                                        <xsl:text></xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="normalize-space(concat($sn, ', ', $fn))"/>                                                                
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:if test="position() != last()">;<xsl:text> </xsl:text></xsl:if>
                                            </xsl:for-each>
                                        </xsl:variable>
                                        <xsl:value-of select="$names"/>
                                    </xsl:variable>
                                    
                                    
                                    <xsl:variable name="mentions" select="count(.//tei:note[@type='mentions'])"/>
                                    <xsl:if test="text() and $mentions &gt; 0">
                                        <tr>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="$author_full = '' and $editors !=''">
                                                        <xsl:value-of select="$editors"/><xsl:text> (Hg.)</xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$author_full"/>      
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                                                                 
                                            </td>
                                            <td>
                                                <a href="{concat($id, '.html')}">
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
                                                <xsl:value-of select="$mentions"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="$id"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </xsl:for-each>
                            </tbody>
                        </table>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
            <script src="js/datatables_custom/datatables_custom.js"></script>

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
                                    <a href="listbibl.html"><xsl:value-of select="$doc_title"/></a>
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
                                            <a class="link-underline-light">
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="replace(@target, '.xml', '.html')"/>
                                                </xsl:attribute>
                                            <xsl:value-of select="./text()"/>
                                                <xsl:text> </xsl:text><i class="bi bi-box-arrow-up-right"></i>
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
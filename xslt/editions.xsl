<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar" version="2.0" exclude-result-prefixes="xsl tei xs local">
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes"
        omit-xml-declaration="yes"/>

    <xsl:import href="partials/shared.xsl"/>
    <xsl:import href="partials/entities.xsl"/>
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/zotero.xsl"/>

        
    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"
        />
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="pdf">
        <xsl:value-of select="replace($teiSource, '.xml', '.pdf')"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="doc-url">
        <xsl:value-of select="concat('https://tillich-briefe.acdh.oeaw.ac.at/', $link)"/>
    </xsl:variable>
    <xsl:variable name="pdf-url">
        <xsl:value-of select="concat('https://tillich-briefe.acdh.oeaw.ac.at/', $pdf)"/>
</xsl:variable>

    <xsl:template match="/">
        <html class="h-100" lang="de">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"/>
                </xsl:call-template>
                <xsl:call-template name="zoterMetaTags">
                    <xsl:with-param name="pageId" select="$link"></xsl:with-param>  
                    <xsl:with-param name="zoteroTitle" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                <xsl:for-each select=".//tei:titleStmt/tei:respStmt/tei:name">
                    <meta name="citation_author" content="{./text()}"/>
                </xsl:for-each>
                <meta name="citation_pdf_url" content="{'https://tillichcorrespondence.github.io/tillich-briefe-static/'||replace($link, '.html', '.pdf')}"></meta>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.2/html2pdf.bundle.min.js"></script>
            </head>

            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0 flex-grow-1">
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb"
                        class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">Tillich-Briefe</a>
                            </li>
                            <li class="breadcrumb-item">
                                <a href="toc.html">Alle Briefe</a>
                            </li>
                        </ol>
                    </nav>
                    <div class="container">
                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12 text-start">
                                <xsl:if test="ends-with($prev, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$prev"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-left"
                                            title="Zurück zum vorigen Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Zurück zum vorigen
                                                Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12 text-center">
                                <h1 id="pdf-title">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <div>
                                    <a href="{$teiSource}">
                                        <i class="bi bi-filetype-xml fs-2" title="Zum TEI/XML Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Zum TEI/XML
                                                Dokument</span>
                                        </i>
                                    </a>
                                     <a id="download-pdf" href="#">
                                        <i class="ps-1 bi bi-file-earmark fs-2" title="Deprecated PDF"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Deprecated PDF</span>
                                        </i>
                                    </a>
                                    <a href="{$pdf-url}">
                                        <i class="ps-1 bi bi-filetype-pdf fs-2" title="Als PDF herunterladen"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Als PDF herunterladen</span>
                                        </i>
                                    </a>
                                    
                                </div>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12 text-end">
                                <xsl:if test="ends-with($next, '.html')">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$next"/>
                                        </xsl:attribute>
                                        <i class="fs-2 bi bi-chevron-right"
                                            title="Weiter zum nächsten Dokument"
                                            visually-hidden="true">
                                            <span class="visually-hidden">Weiter zum nächsten
                                                Dokument</span>
                                        </i>
                                    </a>
                                </xsl:if>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-6">
                                <div id="pdf-transcript">
                                    <h2 class="visually-hidden">Der editierte Text</h2>
                                    <xsl:apply-templates select=".//tei:body"/>
                                </div>
                                <hr/>
                                <div class="pt-3">
                                    <div class="ps-5 pe-5" id="pdf-footnotes">
                                        <h2 class="visually-hidden">Fußnoten, Anmerkungen</h2>
                                        <xsl:for-each select=".//tei:note[@type='ea' or @type='eb']">
                                            <div class="footnotes">
                                                <xsl:element name="a">
                                                    <xsl:attribute name="name">
                                                        <xsl:text>fn</xsl:text>
                                                        <xsl:number level="any" format="1" count="tei:note"
                                                        />
                                                    </xsl:attribute>
                                                    <a>
                                                        <xsl:attribute name="href">
                                                            <xsl:text>#fna_</xsl:text>
                                                            <xsl:number level="any" format="1"
                                                                count="tei:note"/>
                                                        </xsl:attribute>
                                                        <span
                                                            style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                            <xsl:number level="any" format="1"
                                                                count="tei:note"/>
                                                        </span>
                                                    </a>
                                                </xsl:element>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:for-each>
                                    </div>
                                </div>
                                <div class="pt-3">
                                     <div class="ps-5 pe-5 visually-hidden" id="pdf-entities">
                                         <h2 class="visually-hidden">Register</h2>
                                         
                                         <xsl:for-each select=".//tei:rs[starts-with(@ref, '#') and @type]">
                                             <xsl:variable name="rstype" select="@type"/>
                                             <xsl:variable name="rsids" select="tokenize(normalize-space(@ref), '\s+')"/>
                                             
                                             
                                             <xsl:variable name="doc" select="root(.)"/>
                                             
                                             <xsl:variable name="idxlabel"
                                                 select="
                                                 string-join(
                                                 for $id in tokenize(normalize-space(@ref), '\s+')
                                                 return
                                                 if (@type = ('person','place'))
                                                 then string(
                                                 $doc//tei:back//*[@xml:id = substring-after($id,'#')]
                                                 /*[contains(local-name(),'Name')][1]
                                                 )
                                                 else if (@type = 'work')
                                                 then string(
                                                 $doc//tei:back//*[@xml:id = substring-after($id,'#')]/@n
                                                 )
                                                 else if (@type = 'letter')
                                                 then string(
                                                 $doc//tei:back//*[@xml:id = substring-after($id,'#')]//text()
                                                 )
                                                 else if (@type = 'bible')
                                                 then substring-after($id,'#')
                                                 else (),
                                                 '; '
                                                 )
                                                 "></xsl:variable>
                                             
                                                 
                                                 <div>
                                                     <xsl:variable name="entId"
                                                         select="substring-after(tokenize(normalize-space(@ref), '\s+')[1], '#')"/>
                                                     <xsl:attribute name="id">
                                                         <xsl:value-of select="$entId"/>
                                                         <xsl:number level="any"
                                                             format="a"
                                                             count="tei:rs[starts-with(@ref,'#') and @type]"/>
                                                         <xsl:text>endnote</xsl:text>
                                                     </xsl:attribute>
                                                     
                                                     <sup>
                                                         <xsl:number level="any"
                                                             format="a"
                                                             count="tei:rs[starts-with(@ref,'#') and @type]"/>
                                                     </sup>
                                                     
                                                     <span class="ps-1">
                                                         <xsl:value-of select="$idxlabel"/>
                                                     </span>
                                                 </div>
                                         </xsl:for-each>
                                         
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-1"/>
                            <div class="col-lg-5">
                                <div id="pdf-metadata">
                                    <h2 class="fs-3">Überlieferung</h2>
                                    <dl>
                                        <dt>Signatur</dt>
                                        <dd>
                                            <xsl:value-of select="string-join(.//tei:msIdentifier/tei:*/text(), ', ')"/>
                                        </dd>
                                        <xsl:if test=".//tei:additional/tei:listBibl/tei:biblStruct">
                                            <dt>Erstpublikation</dt>
                                            <dd>
                                                <xsl:apply-templates 
                                                    select=".//tei:additional/tei:listBibl/tei:biblStruct"/>
                                            </dd>
                                        </xsl:if>

                                                                                      
                                        
                                        <dt>Typ</dt>
                                        <dd><xsl:apply-templates select=".//tei:physDesc"></xsl:apply-templates></dd>
                                        <dt>Postweg</dt>
                                        <dd>
                                            <xsl:choose>
                                                <xsl:when test=".//tei:correspAction[@type='sent']/tei:placeName/text()">
                                                    <xsl:value-of select="string-join(.//tei:correspAction[@type='sent']/tei:placeName/text(), '; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    unbekannt
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            -
                                            <xsl:choose>
                                                <xsl:when test=".//tei:correspAction[@type='received']/tei:placeName/text()">
                                                    <xsl:value-of select="string-join(.//tei:correspAction[@type='received']/tei:placeName/text(), '; ')"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    unbekannt
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </dd>
                                        <xsl:if test=".//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']">
                                            <dt>voriger Brief in der Korrespondenz</dt>
                                            <dd>
                                                <a href="{replace(.//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']/@target, '.xml', '.html')}">
                                                    <xsl:value-of select=".//tei:ref[@subtype='previous_letter' and @type='withinCorrespondence']/text()"/>
                                                </a>
                                            </dd>
                                        </xsl:if>
                                        <xsl:if test=".//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']">
                                            <dt>nächster Brief in der Korrespondenz</dt>
                                            <dd>
                                                <a href="{replace(.//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']/@target, '.xml', '.html')}">
                                                    <xsl:value-of select=".//tei:ref[@subtype='next_letter' and @type='withinCorrespondence']/text()"/>
                                                </a>
                                            </dd>
                                        </xsl:if>
                                    </dl>
                                    <hr />
                                </div>
                                <h2 class="visually-hidden">Entitäten</h2>
                                <xsl:if test=".//tei:back//tei:person[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Personen</h3>

                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:person[@xml:id]">
                                                <div class="form-check">
                                                  <input class="form-check-input" type="checkbox"
                                                  onchange="toggleHighlight(this)"
                                                  value="{@xml:id}" id="check-{@xml:id}"/>
                                                  <label class="form-check-label" for="check-{@xml:id}">
                                                  <xsl:value-of select="./tei:persName[1]/text()"/>
                                                  </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>

                                <xsl:if test=".//tei:back//tei:place[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Orte</h3>
                                        <div class="ps-4">
                                            <xsl:for-each select=".//tei:back//tei:place[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./tei:placeName[1]/text()"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:back//tei:biblStruct[@xml:id]">
                                    <div>
                                        <h3 class="fs-4 p-1">Literatur</h3>
                                        
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:back//tei:biblStruct[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./@n"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:rs[@type='bible' and @ref]">
                                    <div>
                                        <h3 class="fs-4 p-1">Bibelstellen</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select="distinct-values(.//tei:rs[@type='bible' and @ref]/@ref)">
                                                <xsl:variable name="biblId">
                                                    <xsl:value-of select="lower-case(replace(replace(., ',', '-'), ' ', ''))"/>
                                                </xsl:variable>
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{$biblId}" id="check-{$biblId}"/>
                                                    <label class="form-check-label" for="check-{$biblId}">
                                                        <xsl:value-of select="."/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test=".//tei:list[@xml:id = 'mentioned_letters']">
                                    <div>
                                        <h3 class="fs-4 p-1">Briefe</h3>
                                        <div class="ps-4">
                                            <xsl:for-each
                                                select=".//tei:list[@xml:id = 'mentioned_letters']//tei:item[@xml:id]">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="checkbox"
                                                        onchange="toggleHighlight(this)"
                                                        value="{@xml:id}" id="check-{@xml:id}"/>
                                                    <label class="form-check-label" for="check-{@xml:id}">
                                                        <xsl:value-of select="./text()"/>
                                                    </label>
                                                </div>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                </xsl:if>
                                
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-2"/>
                            <div class="col-md-8">
                                <h2 class="text-center p-3 fs-3">Zitiervorschlag</h2>
                                <blockquote class="blockquote">
                                    <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
                                    <xsl:text>, in: Paul Tillich, Korrespondenz. Digitale Edition, hg. von Christian Danz und Friedrich Wilhelm Graf. </xsl:text>
                                    <xsl:value-of select="$doc-url"/>
                                    <xsl:text>, Zugriff am </xsl:text>
                                    <span class="currentDate">????</span>
                                    <xsl:text>.</xsl:text>
                                </blockquote>
                                <h3 class="text-center p-3 fs-4">
                                    Für Belege in der Wikipedia
                                </h3>
                                <blockquote>
                                    <code>
                                        {{Internetquelle |url=<xsl:value-of select="$doc-url"/>
                                        <xsl:text> |titel=</xsl:text>
                                        <xsl:value-of select=".//tei:titleStmt/tei:title[1]"/>
                                        <xsl:text> |werk=Paul Tillich, Korrespondenz. Digitale Edition. |hrsg=Christian Danz, Friedrich Wilhelm Graf |sprache=de |  datum=</xsl:text>
                                        <xsl:value-of select="//tei:correspAction[@type = 'sent']/tei:date[@when]"/>
                                        <xsl:text> |abruf=</xsl:text>
                                        <span class="currentDateYYYYMMDD">????</span>
                                        <xsl:text> }}</xsl:text>
                                    </code>
                                </blockquote>
                            </div>
                            <div class="col-md-2"/>
                        </div>
                        <span id="filename" class="visually-hidden"><xsl:value-of select="replace($teiSource, '.xml', '.pdf')"/></span>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back pt-3">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                    
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="js/main.js"></script>
                <script src="js/pdf.js"></script>
            </body>

        </html>
    </xsl:template>
    <xsl:template match="tei:pb">
        <xsl:element name="span">
            <xsl:attribute name="class">pagebreak</xsl:attribute>
            <xsl:attribute name="title">Seitenbeginn, S. <xsl:value-of select="data(@n)"/>
            </xsl:attribute>
            <xsl:text>|
            </xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:dateline">
        <div class="text-end">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:closer">
        <div class="text-start pb-2">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="tei:salute">
        <p class="text-start">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:signed">
        <p class="text-start">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:choice[./tei:abbr and ./tei:expan]">
    <abbr title="{./tei:expan/text()}">
        <xsl:apply-templates select="./tei:abbr"/>
    </abbr>
    </xsl:template>
    
    <xsl:template match="tei:list/tei:head"/>
    
    <xsl:template match="tei:unclear">
        <xsl:text>{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend]">
    <xsl:choose>
        <xsl:when test="@rend = 'aq' or @rend = 'b' or @rend = 'g' or @rend = 'i' or @rend = 'u' or @rend = 'uu'">
            <span class="dse-italic">
                <xsl:apply-templates/>
            </span>
        </xsl:when>
        <xsl:when test="@rend = 'sup'">
            <sup>
                <xsl:apply-templates/>
            </sup>
        </xsl:when>
        <xsl:otherwise>
            <span>
                <xsl:attribute name="class">
                    <xsl:value-of select="concat('dse-', @rend)"/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </span>
        </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:add">
        <xsl:choose>
            <xsl:when test="@place">
                <abbr title="{'Einfügung: '||@place}">|:</abbr><xsl:apply-templates/><abbr title="Ende der Einfügung">:|</abbr>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>|:</xsl:text><xsl:apply-templates/><xsl:text>:|</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="tei:supplied">[<xsl:apply-templates/>]</xsl:template>
    <xsl:template match="tei:sic">
        <xsl:apply-templates/><xsl:text> [sic!] </xsl:text>
    </xsl:template>
    
    <!-- Main biblStruct template -->
    <xsl:template match="tei:biblStruct">
        <div class="bibl {@type}">
            <xsl:choose>
                
                <!-- ========================= -->
                <!-- MONOGRAPH FORMAT -->
                <!-- ========================= -->
                <xsl:when test="@type='monograph'">
                    
                    <!-- Author -->
                    <span class="author">
                        <xsl:value-of select="tei:monogr/tei:author"/>
                    </span>
                    <xsl:text>: </xsl:text>
                    
                    <!-- Title -->
                    <span class="dse-italic">
                        <xsl:value-of select="tei:monogr/tei:title"/>
                    </span>
                    <xsl:text>. </xsl:text>
                    
                    <!-- Edition -->
                    <xsl:if test="tei:monogr/tei:edition">
                        <xsl:value-of select="tei:monogr/tei:edition"/>
                        <xsl:text>. </xsl:text>
                    </xsl:if>
                    
                    <!-- Imprint -->
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:pubPlace"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:publisher"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
                    
                    <xsl:if test="tei:monogr/tei:imprint/tei:biblScope">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope"/>
                    </xsl:if>
                    <xsl:text>. </xsl:text>
                    
                    <!-- Series -->
                    <xsl:if test="tei:series">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="tei:series/tei:title"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="tei:series/tei:biblScope"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                    
                </xsl:when>
                
                <!-- ========================= -->
                <!-- JOURNAL FORMAT -->
                <!-- ========================= -->
                <xsl:when test="@type='journal'">
                    
                    <!-- Author -->
                    <span class="author">
                        <xsl:value-of select="tei:monogr/tei:author"/>
                    </span>
                    <xsl:text>: </xsl:text>
                    
                    <!-- Article Title -->
                    <span class="article-title">
                        „<xsl:value-of select="tei:monogr/tei:title"/>“
                    </span>
                    <xsl:text>. </xsl:text>
                    
                    <xsl:text>In: </xsl:text>
                    
                    <!-- Journal Title -->
                    <span class="dse-italic">
                        <xsl:value-of select="tei:series/tei:title"/>
                    </span>
                    <xsl:text> </xsl:text>
                    
                    <!-- Volume -->
                    <xsl:value-of select="tei:series/tei:biblScope"/>
                    <xsl:text> (</xsl:text>
                    
                    <!-- Date -->
                    <xsl:value-of select="tei:monogr/tei:imprint/tei:date"/>
                    <xsl:text>)</xsl:text>
                    
                    <!-- Pages -->
                    <xsl:if test="tei:monogr/tei:imprint/tei:biblScope">
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="tei:monogr/tei:imprint/tei:biblScope"/>
                    </xsl:if>
                    
                    <xsl:text>.</xsl:text>
                    
                </xsl:when>
                
            </xsl:choose>
        </div>
    </xsl:template>
    
</xsl:stylesheet>
